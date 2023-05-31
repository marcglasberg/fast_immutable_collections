// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:test/test.dart";

extension TestExtension on IMap {
  int get counter => InternalsForTestingPurposesIMap(this).counter;
}

void main() {
  //
  test("Sync auto-flush when the map is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.flushFactor = 4;

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap.isFlushed, isTrue);
    expect(imap.counter, 0);

    // Since the map is flushed, the counter remains at 0.
    imap.containsKey("a");
    expect(imap.counter, 0);

    // Since the map is flushed, the counter remains at 0.
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  test("Sync auto-flush when the map is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.flushFactor = 4;

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // We add a value, so that the map is NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    imap = imap.add("e", 5);
    expect(imap.counter, 1);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 2.
    imap.containsKey("a");
    expect(imap.counter, 2);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 3.
    imap.containsKey("a");
    expect(imap.counter, 3);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // The map is flushed, and counter so the counter is not incremented.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // We'll repeat everything again, just to make sure
    // nothing changes the second time.
    // If we add another value, the map becomes NOT flushed again.
    // Counter is 1 (the add method increments counter by 1).
    imap = imap.add("f", 6);
    expect(imap.counter, 1);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 2.
    imap.containsKey("a");
    expect(imap.counter, 2);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 3.
    imap.containsKey("a");
    expect(imap.counter, 3);
    expect(imap.isFlushed, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // The map is flushed, and counter so the counter is not incremented.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
  });

  test(
      "Method 'add' makes counter equal to the source map counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.flushFactor = 4;

    // The map is flushed. Counter is 0.
    var imap1 = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap1.isFlushed, isTrue);

    var imap2 = imap1.add("e", 5);
    imap2 = imap2.add("e", 5);

    var imap3 = imap2.add("e", 5);

    expect(imap1.counter, 0);
    expect(imap2.counter, 2);
    expect(imap3.counter, 3);
  });

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source maps, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.flushFactor = 4;

    // The map is flushed. Counter is 0.
    var imap1 = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap1.isFlushed, isTrue);
    expect(imap1.counter, 0);

    // Adding IMaps will get the larger counter plus 1.
    var imap2 = imap1.add("e", 5);
    expect(imap2.counter, 1);

    var imap3 = imap2.add("e", 5);
    expect(imap3.counter, 2);

    /// imap2 has counter 1.
    /// imap3 has counter 2.
    /// Both imap5 and imap6 will have counter greater than those of imap3 and imap4.
    expect(imap2.counter, 1);
    expect(imap3.counter, 2);
    var imap5 = imap2.addAll(imap3);
    var imap6 = imap3.addAll(imap2);
    expect(imap5.counter > imap2.counter, isTrue);
    expect(imap5.counter > imap3.counter, isTrue);
    expect(imap6.counter > imap2.counter, isTrue);
    expect(imap6.counter > imap3.counter, isTrue);

    /// imap7 will have counter greater than imap3.
    var imap7 = imap2.addAll(imap2);
    expect(imap7.counter > imap2.counter, isTrue);

    /// imap8 will have counter greater than imap4.
    var imap8 = imap3.addAll(imap3);
    expect(imap8.counter > imap3.counter, isTrue);
  });
}
