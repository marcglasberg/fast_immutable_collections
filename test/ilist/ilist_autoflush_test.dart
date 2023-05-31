// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import "package:test/test.dart";

extension TestExtension on IList {
  int get counter => InternalsForTestingPurposesIList(this).counter;
}

void main() {
  //
  test("Sync auto-flush when the list is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.flushFactor = 4;

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);
    expect(ilist.counter, 0);

    // Since the list is flushed, the counter remains at 0.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);

    // Since the list is flushed, the counter remains at 0.
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4]);
  });

  test("Sync auto-flush when the list is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.flushFactor = 4;

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);

    // We add a value, so that the list is NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(5);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    // The list is flushed, and counter so the counter is not incremented.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    // We'll repeat everything again, just to make sure
    // nothing changes the second time.
    // If we add another value, the list becomes NOT flushed again.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(6);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    // The list is flushed, and counter so the counter is not incremented.
    ilist[0]; // ignore: unnecessary_statements
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
  });

  test(
      "Method 'add' makes counter equal to the source list counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.flushFactor = 4;

    // The list is flushed. Counter is 0.
    var ilist1 = [1, 2, 3, 4].lock;
    expect(ilist1.isFlushed, isTrue);

    var ilist2 = ilist1.add(1);
    ilist2 = ilist2.add(1);

    var ilist3 = ilist2.add(1);

    expect(ilist1.counter, 0);
    expect(ilist2.counter, 2);
    expect(ilist3.counter, 3);
  });

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source lists, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.flushFactor = 100;

    // The list is flushed. Counter is 0.
    var ilist1 = [1, 2, 3, 4].lock;
    expect(ilist1.isFlushed, isTrue);
    expect(ilist1.counter, 0);

    // Adding regular iterables only increments by 1.
    var ilist2 = ilist1.addAll([1, 2, 3]);
    ilist2 = ilist2.addAll([4, 5, 6]);
    expect(ilist2.counter, 2);

    // Adding ILists will get the larger counter plus 1.

    var ilist3 = ilist2.add(1);
    expect(ilist3.counter, 3);
    expect(ilist3.isFlushed, isFalse);

    var ilist4 = ilist3.add(1);
    expect(ilist4.counter, 4);
    expect(ilist4.isFlushed, isFalse);

    /// ilist3 has counter 3.
    /// ilist4 has counter 4.
    /// Both ilist5 and ilist6 will have counter = max(3, 4) + 1.
    var ilist5 = ilist3.addAll(ilist4);
    var ilist6 = ilist4.addAll(ilist3);
    expect(ilist5.counter, max(ilist3.counter, ilist4.counter) + 1);
    expect(ilist6.counter, max(ilist3.counter, ilist4.counter) + 1);

    /// ilist7 will have counter = max(3, 3) + 1.
    var ilist7 = ilist3.addAll(ilist3);
    expect(ilist7.counter, max(ilist3.counter, ilist3.counter) + 1);

    /// ilist7 will have counter = max(4, 4) + 1.
    var ilist8 = ilist4.addAll(ilist4);
    expect(ilist8.counter, max(ilist4.counter, ilist4.counter) + 1);
  });
}
