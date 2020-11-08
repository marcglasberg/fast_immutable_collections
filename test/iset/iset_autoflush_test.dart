import "dart:math";
import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

extension TestExtension on ISet {
  int get counter => InternalsForTestingPurposesISet(this).counter;
}

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the set is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = false;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The set is flushed. Counter is 0.
    var iset = {1, 2, 3, 4}.lock;
    expect(iset.isFlushed, isTrue);
    expect(iset.counter, 0);

    // Since the set is flushed, the counter remains at 0.
    iset.contains(0);
    expect(iset.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is flushed, the counter remains at 0.
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(iset, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the set is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = true;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The set is flushed. Counter is 0.
    var iset = {1, 2, 3, 4}.lock;
    expect(iset.isFlushed, isTrue);
    expect(iset.counter, 0);

    // Since the set is flushed, the counter remains at 0.
    iset.contains(0);
    expect(iset.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is flushed, the counter remains at 0.
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(iset, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the set is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = true;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it turns into
    // negative asyncCounter (-1). Also, the asyncCounter increment
    // is scheduled.
    iset.contains(0);
    expect(iset.counter, -1);
    expect(iset.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // The set is NOT flushed, but since the counter is already negative
    // it doesn't change anymore.
    iset.contains(0);
    expect(iset.counter, -1);
    expect(iset.isFlushed, isFalse);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (2).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the set is still NOT flushed.
    expect(iset.counter, -1);
    expect(iset.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the set will be flushed and counter will be reset to 0.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(iset, [1, 2, 3, 4, 5]);

    // Since the set is now flushed, the counter remains at 0.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // We add a value, so that the set is now NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    iset = iset.add(6);
    expect(iset.counter, 1);
    expect(iset.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 2.
    iset.contains(0);
    expect(iset.counter, 2);
    expect(iset.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 3.
    iset.contains(0);
    expect(iset.counter, 3);
    expect(iset.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter again reached the flushFactor (4), so it turns into
    // negative asyncCounter (-2). Also, the asyncCounter increment
    // is scheduled.
    iset.contains(0);
    expect(iset.counter, -2);
    expect(iset.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // Counter is still negative. And the set is still NOT flushed.
    expect(iset.counter, -2);
    expect(iset.isFlushed, isFalse);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (3).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 3);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the set is still NOT flushed.
    expect(iset.counter, -2);
    expect(iset.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the set will be flushed and counter will be reset to 0.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(iset, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the set is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = false;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The set is flushed, and counter so the counter is not incremented.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

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
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the set is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The set is flushed, and counter so the counter is not incremented.
    iset.contains(0);
    expect(iset.counter, 0);
    expect(iset.isFlushed, isTrue);

    // The asyncCounter is not touched (and in fact is irrelevant).
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'add' makes counter equal to the source set counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = true;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The set is flushed. Counter is 0.
    var iset1 = {1, 2, 3, 4}.lock;
    expect(iset1.isFlushed, isTrue);

    var iset2 = iset1.add(1);
    iset2 = iset2.add(1);

    var iset3 = iset2.add(1);

    expect(iset1.counter, 0);
    expect(iset2.counter, 2);
    expect(iset3.counter, 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source sets, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = true;
    ISet.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The set is flushed. Counter is 0.
    var iset1 = {1, 2, 3, 4}.lock;
    expect(iset1.isFlushed, isTrue);
    expect(iset1.counter, 0);

    // Adding regular iterables only increments by 1.
    var iset2 = iset1.addAll([1, 2, 3]);
    iset2 = iset2.addAll([4, 5, 6]);
    expect(iset2.counter, 2);

    // Adding ISets will get the larger counter plus 1.

    var iset3 = iset2.add(8);
    expect(iset3.counter, 3);

    var iset4 = iset3.add(9);
    expect(InternalsForTestingPurposesISet(iset4).counter, 4);

    /// iset3 has counter 3.
    /// iset4 has counter 4.
    /// Both iset5 and iset6 will have counter = max(3, 4) + 1.
    var iset5 = iset3.addAll(iset4);
    var iset6 = iset4.addAll(iset3);
    expect(iset5.counter, max(3, 4) + 1);
    expect(iset6.counter, max(3, 4) + 1);

    /// iset7 will have counter = max(3, 3) + 1.
    var iset7 = iset3.addAll(iset3);
    expect(iset7.counter, max(3, 3) + 1);

    /// iset7 will have counter = max(4, 4) + 1.
    var iset8 = iset4.addAll(iset4);
    expect(iset8.counter, max(4, 4) + 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Async auto-flush: "
      "Make sure asyncCounter increments only once when its marked to "
      "increment, and only after the async gap. "
      "Also check it resets to 1, at some point.", () async {
    ImmutableCollection.resetAllConfigurations();
    ISet.asyncAutoflush = true;
    ISet.flushFactor = 4;
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
