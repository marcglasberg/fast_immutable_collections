import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

extension TestExtension on IMap {
  int get counter => InternalsForTestingPurposesIMap(this).counter;
}

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the map is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = false;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap.isFlushed, isTrue);
    expect(imap.counter, 0);

    // Since the map is flushed, the counter remains at 0.
    imap.containsKey("a");
    expect(imap.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is flushed, the counter remains at 0.
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the map is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = true;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap.isFlushed, isTrue);
    expect(imap.counter, 0);

    // Since the map is flushed, the counter remains at 0.
    imap.containsKey("a");
    expect(imap.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is flushed, the counter remains at 0.
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the map is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = true;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it turns into
    // negative asyncCounter (-1). Also, the asyncCounter increment
    // is scheduled.
    imap.containsKey("a");
    expect(imap.counter, -1);
    expect(imap.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // The map is NOT flushed, but since the counter is already negative
    // it doesn't change anymore.
    imap.containsKey("a");
    expect(imap.counter, -1);
    expect(imap.isFlushed, isFalse);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (2).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the map is still NOT flushed.
    expect(imap.counter, -1);
    expect(imap.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the map will be flushed and counter will be reset to 0.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5});

    // Since the map is now flushed, the counter remains at 0.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // We add a value, so that the map is now NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    imap = imap.add("f", 6);
    expect(imap.counter, 1);
    expect(imap.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 2.
    imap.containsKey("a");
    expect(imap.counter, 2);
    expect(imap.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 3.
    imap.containsKey("a");
    expect(imap.counter, 3);
    expect(imap.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter again reached the flushFactor (4), so it turns into
    // negative asyncCounter (-2). Also, the asyncCounter increment
    // is scheduled.
    imap.containsKey("a");
    expect(imap.counter, -2);
    expect(imap.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // Counter is still negative. And the map is still NOT flushed.
    expect(imap.counter, -2);
    expect(imap.isFlushed, isFalse);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (3).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 3);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the map is still NOT flushed.
    expect(imap.counter, -2);
    expect(imap.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the map will be flushed and counter will be reset to 0.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(imap.unlock, {"a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the map is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = false;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The map is flushed. Counter is 0.
    var imap = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The map is flushed, and counter so the counter is not incremented.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // The asyncCounter is not touched (and in fact is irrelevant).
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is NOT incremented.
    // The asyncCounter increment is NOT scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the map is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The map is flushed, and counter so the counter is not incremented.
    imap.containsKey("a");
    expect(imap.counter, 0);
    expect(imap.isFlushed, isTrue);

    // The asyncCounter is not touched (and in fact is irrelevant).
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'add' makes counter equal to the source map counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = true;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

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

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source maps, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = true;
    IMap.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The map is flushed. Counter is 0.
    var imap1 = {"a": 1, "b": 2, "c": 3, "d": 4}.lock;
    expect(imap1.isFlushed, isTrue);
    expect(imap1.counter, 0);

    // Adding regular maps only increments by 1.
    var imap2 = imap1.addMap({"a": 1, "b": 2, "c": 3});
    imap2 = imap2.addMap({"d": 4, "e": 5, "f": 6});
    expect(imap2.counter, 2);

    // Adding IMaps will get the larger counter plus 1.

    var imap3 = imap2.add("e", 5);
    expect(imap3.counter, 3);

    var imap4 = imap3.add("e", 5);
    expect(InternalsForTestingPurposesIMap(imap4).counter, 4);

    /// imap3 has counter 3.
    /// imap4 has counter 4.
    /// Both imap5 and imap6 will have counter greater than those of imap3 and imap4.
    expect(imap3.counter, 3);
    expect(imap4.counter, 4);
    var imap5 = imap3.addAll(imap4);
    var imap6 = imap4.addAll(imap3);
    expect(imap5.counter > imap3.counter, isTrue);
    expect(imap5.counter > imap4.counter, isTrue);
    expect(imap6.counter > imap3.counter, isTrue);
    expect(imap6.counter > imap4.counter, isTrue);

    /// imap7 will have counter greater than imap3.
    var imap7 = imap3.addAll(imap3);
    expect(imap7.counter > imap3.counter, isTrue);

    /// imap8 will have counter greater than imap4.
    var imap8 = imap4.addAll(imap4);
    expect(imap8.counter > imap4.counter, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Async auto-flush: "
      "Make sure asyncCounter increments only once when its marked to "
      "increment, and only after the async gap. "
      "Also check it resets to 1, at some point.", () async {
    ImmutableCollection.resetAllConfigurations();
    IMap.asyncAutoflush = true;
    IMap.flushFactor = 4;
    await Future.delayed(Duration(milliseconds: 100));

    // When reset, the asyncCounter is 1.
    expect(ImmutableCollection.asyncCounter, 1);

    // When we mark to increment it does not increment before the async gap.
    ImmutableCollection.markAsyncCounterToIncrement();
    ImmutableCollection.markAsyncCounterToIncrement();
    ImmutableCollection.markAsyncCounterToIncrement();
    ImmutableCollection.markAsyncCounterToIncrement();
    expect(ImmutableCollection.asyncCounter, 1);

    // After an async gap, it increments.
    await Future.delayed(Duration(milliseconds: 0));
    expect(ImmutableCollection.asyncCounter, 2);

    // But if it was not market to increment,
    // it does not increment after the async gap.
    await Future.delayed(Duration(milliseconds: 0));
    expect(ImmutableCollection.asyncCounter, 2);

    // Increment after each async gap.
    for (int i = 2; i <= 9998; i++) {
      ImmutableCollection.markAsyncCounterToIncrement();
      expect(ImmutableCollection.asyncCounter, i);
      await Future.delayed(Duration(milliseconds: 0));
    }

    // Almost at 10.000
    expect(ImmutableCollection.asyncCounter, 9999);
    ImmutableCollection.markAsyncCounterToIncrement();

    // When it reaches 10.000, it resets to 1.
    //
    await Future.delayed(Duration(milliseconds: 0));
    expect(ImmutableCollection.asyncCounter, 1);
  });

  //////////////////////////////////////////////////////////////////////////////
}
