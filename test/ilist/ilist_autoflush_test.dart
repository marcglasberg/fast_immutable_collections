import "dart:math";
import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

extension TestExtension on IList {
  int get counter => InternalsForTestingPurposesIList(this).counter;
}

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the list is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = false;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);
    expect(ilist.counter, 0);

    // Since the list is flushed, the counter remains at 0.
    ilist[0];
    expect(ilist.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is flushed, the counter remains at 0.
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the list is already flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = true;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);
    expect(ilist.counter, 0);

    // Since the list is flushed, the counter remains at 0.
    ilist[0];
    expect(ilist.counter, 0);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is flushed, the counter remains at 0.
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Async auto-flush when the list is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = true;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);

    // We add a value, so that the list is NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(5);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0];
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it turns into
    // negative asyncCounter (-1). Also, the asyncCounter increment
    // is scheduled.
    ilist[0];
    expect(ilist.counter, -1);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // The list is NOT flushed, but since the counter is already negative
    // it doesn't change anymore.
    ilist[0];
    expect(ilist.counter, -1);
    expect(ilist.isFlushed, isFalse);

    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (2).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the list is still NOT flushed.
    expect(ilist.counter, -1);
    expect(ilist.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the list will be flushed and counter will be reset to 0.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4, 5]);

    // Since the list is now flushed, the counter remains at 0.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ImmutableCollection.asyncCounter, 2);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // We add a value, so that the list is now NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(6);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0];
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter again reached the flushFactor (4), so it turns into
    // negative asyncCounter (-2). Also, the asyncCounter increment
    // is scheduled.
    ilist[0];
    expect(ilist.counter, -2);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isTrue);

    // Counter is still negative. And the list is still NOT flushed.
    expect(ilist.counter, -2);
    expect(ilist.isFlushed, isFalse);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (3).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(ImmutableCollection.asyncCounter, 3);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Counter is still negative. And the list is still NOT flushed.
    expect(ilist.counter, -2);
    expect(ilist.isFlushed, isFalse);

    // Now that the counter is negative, but it's NOT equal no negative
    // asyncCounter, the list will be flushed and counter will be reset to 0.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Sync auto-flush when the list is NOT flushed.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = false;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);

    // We add a value, so that the list is NOT flushed.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(5);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0];
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The list is flushed, and counter so the counter is not incremented.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

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
    // If we add another value, the list becomes NOT flushed again.
    // Counter is 1 (the add method increments counter by 1).
    ilist = ilist.add(6);
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    ilist[0];
    expect(ilist.counter, 3);
    expect(ilist.isFlushed, isFalse);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 4.
    // The counter reached the flushFactor (4), so it is flushed
    // and counter is reset to zero.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);

    // The list is flushed, and counter so the counter is not incremented.
    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    // The asyncCounter is not touched (and in fact is irrelevant).
    expect(ImmutableCollection.asyncCounter, 1);
    expect(ImmutableCollection.asyncCounterMarkedForIncrement, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'add' makes counter equal to the source list counter, "
      "plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = true;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

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

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Method 'addAll' makes counter equal to "
      "the larger counter of its source lists, plus one.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = true;
    IList.flushFactor = 4;
    expect(ImmutableCollection.asyncCounter, 1);

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

    var ilist4 = ilist3.add(1);
    expect(InternalsForTestingPurposesIList(ilist4).counter, 4);

    /// ilist3 has counter 3.
    /// ilist4 has counter 4.
    /// Both ilist5 and ilist6 will have counter = max(3, 4) + 1.
    var ilist5 = ilist3.addAll(ilist4);
    var ilist6 = ilist4.addAll(ilist3);
    expect(ilist5.counter, max(3, 4) + 1);
    expect(ilist6.counter, max(3, 4) + 1);

    /// ilist7 will have counter = max(3, 3) + 1.
    var ilist7 = ilist3.addAll(ilist3);
    expect(ilist7.counter, max(3, 3) + 1);

    /// ilist7 will have counter = max(4, 4) + 1.
    var ilist8 = ilist4.addAll(ilist4);
    expect(ilist8.counter, max(4, 4) + 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Async auto-flush: "
      "Make sure asyncCounter increments only once when its marked to "
      "increment, and only after the async gap. "
      "Also check it resets to 1, at some point.", () async {
    ImmutableCollection.resetAllConfigurations();
    IList.asyncAutoflush = true;
    IList.flushFactor = 4;
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
