// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';
import "package:test/test.dart";

extension TestExtension on ISet {
  int get counter => InternalsForTestingPurposesISet(this).counter;
}

void main() {
  //
  test("Sync auto-flush when the set is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.flushFactor = 4;

    // The set is flushed. Counter is 0.
    var iset = {1, 2, 3, 4}.lock;
    expect(iset.isFlushed, isTrue);
    expect(iset.counter, 0);

    // Since the set is flushed, the counter remains at 0.
    iset.contains(0);
    expect(iset.counter, 0);

    // Since the set is flushed, the counter remains at 0.
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(iset, [1, 2, 3, 4]);
  });

  test("Sync auto-flush when the set is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.flushFactor = 4;

    // The set is flushed. Counter is 0.
    var iset = {1, 2, 3, 4}.lock;
    expect(iset.isFlushed, isTrue);

    // We add a value, so that the set is NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    iset = iset.add(5);
    expect(iset.counter, 1);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 2.
    iset.contains(0);
    expect(iset.counter, 2);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 3.
    iset.contains(0);
    expect(iset.counter, 3);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    // The set is flushed, and counter so the counter is not incremented.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    // We'll repeat everything again, just to make sure
    // nothing changes the second time.
    // If we add another value, the set becomes NOT flushed again.
    // Counter is 1 (the add method increments counter by 1).
    iset = iset.add(6);
    expect(iset.counter, 1);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 2.
    iset.contains(0);
    expect(iset.counter, 2);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 3.
    iset.contains(0);
    expect(iset.counter, 3);
    expect(iset.isFlushed, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    // The set is flushed, and counter so the counter is not incremented.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
  });

  test(
      "Method 'add' makes counter equal to the source set counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.flushFactor = 4;

    // The set is flushed. Counter is 0.
    var iset = {1, 2, 3, 4}.lock;
    expect(iset.isFlushed, isTrue);

    // Adds 1, but the set already contains it. So it's not changed.
    iset = iset.add(1);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    // Adds 10. Actually changes the set.
    iset = iset.add(10);
    expect(iset.counter, 1);
    expect(iset.isFlushed, isFalse);

    // Adds 20. Actually changes the set, again.
    iset = iset.add(20);
    expect(iset.counter, 2);
    expect(iset.isFlushed, isFalse);
  });

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source sets, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.flushFactor = 100;

    // The set is flushed. Counter is 0.
    var iset1 = {1, 2, 3, 4}.lock;
    expect(iset1.isFlushed, isTrue);
    expect(iset1.counter, 0);

    // Adding regular iterables only increments by 1.
    var iset2 = iset1.addAll([1, 2, 3]);
    iset2 = iset2.addAll([4, 5, 6]);
    expect(iset2.counter, 1);

    // Adding ISets will get the larger counter plus 1.

    var iset3 = iset2.add(8);
    expect(iset3.counter, 2);

    var iset4 = iset3.add(9);
    expect(iset4.counter, 3);

    /// iset3 has counter 3.
    /// iset4 has counter 4.
    /// Both iset5 and iset6 will have counter = max(3, 4) + 1.
    var iset5 = iset3.addAll(iset4);
    var iset6 = iset4.addAll(iset3);
    expect(iset5.counter, max(iset3.counter, iset4.counter) + 1);
    expect(iset6.counter, max(iset3.counter, iset4.counter) + 1);

    /// iset7 will have counter = max(3, 3) + 1.
    var iset7 = iset3.addAll(iset3);
    expect(iset7.counter, max(iset3.counter, iset3.counter) + 1);

    /// iset7 will have counter = max(4, 4) + 1.
    var iset8 = iset4.addAll(iset4);
    expect(iset8.counter, max(iset4.counter, iset4.counter) + 1);
  });
}
