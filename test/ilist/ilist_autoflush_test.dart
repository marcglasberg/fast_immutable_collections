import "dart:collection";
import "dart:math";

import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Auto-flush when the list is already flushed.", () async {
    resetAsyncCounter();
    expect(asyncCounter, 1);

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);
    expect(ilist.counter, 0);

    // Since the list is flushed, the counter remains at 0.
    ilist[0];
    expect(ilist.counter, 0);

    expect(asyncCounter, 1);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Async gap.
    await Future.delayed(Duration(milliseconds: 1));

    // No asyncCounter increment was scheduled.
    expect(asyncCounter, 1);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Since the list is flushed, the counter remains at 0.
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);

    ilist[0];
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Auto-flush when the list is NOT flushed.", () async {
    resetAsyncCounter();
    expect(asyncCounter, 1);
    IList.refreshFactor = 3;

    // The list is flushed. Counter is 0.
    var ilist = [1, 2, 3, 4].lock;
    expect(ilist.isFlushed, isTrue);

    // The list is NOT flushed. Counter is 0.
    ilist = ilist.add(5);
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 1.
    ilist[0];
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    // The counter reached the refreshFactor (3), so it turns into
    // negative asyncCounter (-1). Also, the asyncCounter increment
    // is scheduled.
    ilist[0];
    expect(ilist.counter, -1);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isTrue);

    // The list is NOT flushed, but since the counter is already negative
    // it doesn't change anymore.
    ilist[0];
    expect(ilist.counter, -1);
    expect(ilist.isFlushed, isFalse);

    expect(asyncCounter, 1);
    expect(asyncCounterMarkedForIncrement, isTrue);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (2).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(asyncCounter, 2);
    expect(asyncCounterMarkedForIncrement, isFalse);

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
    expect(asyncCounter, 2);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Now the list is NOT flushed.
    ilist = ilist.add(6);
    expect(ilist.counter, 0);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 1.
    ilist[0];
    expect(ilist.counter, 1);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 2.
    ilist[0];
    expect(ilist.counter, 2);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isFalse);

    // Since the list is NOT flushed, the counter grows to 3.
    // The counter again reached the refreshFactor (3), so it turns into
    // negative asyncCounter (-2). Also, the asyncCounter increment
    // is scheduled.
    ilist[0];
    expect(ilist.counter, -2);
    expect(ilist.isFlushed, isFalse);
    expect(asyncCounterMarkedForIncrement, isTrue);

    // Counter is still negative. And the list is still NOT flushed.
    expect(ilist.counter, -2);
    expect(ilist.isFlushed, isFalse);

    await Future.delayed(Duration(milliseconds: 1));

    // The asyncCounter is incremented (3).
    // The asyncCounter increment is NOT scheduled anymore.
    expect(asyncCounter, 3);
    expect(asyncCounterMarkedForIncrement, isFalse);

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
}
