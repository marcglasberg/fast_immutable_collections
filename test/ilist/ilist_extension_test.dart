import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    // 1) From an empty list
    expect([].lock, isA<IList>());
    expect([].lock.isEmpty, isTrue);
    expect([].lock.isNotEmpty, isFalse);

    // 2) Type Check: from an empty list typed with String
    final typedList = <String>[].lock;
    expect(typedList, isA<IList<String>>());

    // 3) From a list with one item
    expect([1].lock, isA<IList<int>>());
    expect([1].lock.isEmpty, isFalse);
    expect([1].lock.isNotEmpty, isTrue);

    // 4) Nulls
    expect([null].lock, allOf(isA<IList<String>>(), [null]));

    // 5) Typical usage
    expect([1, 2, 3].lock, allOf(isA<IList<int>>(), [1, 2, 3]));
  });

  /////////////////////////////////////////////////////////////////////////////

  test("lockUnsafe", () {
    final List<int> list = [1, 2, 3];
    final IList<int> ilist = list.lockUnsafe;

    expect(list, ilist);

    list[1] = 4;

    expect(list, ilist);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sortOrdered", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.sortOrdered((int a, int b) => a.compareTo(b));

    expect(list, [1, 2, 3, 4, 5, 10]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sortLike", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.sortLike([1, 2, 3]);

    expect(list, [1, 2, 3, 4, 10, 5]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sortLike | the ordering can't be null", () {
    expect(() => [1, 2, 3, 4, 10, 5].sortLike(null), throwsAssertionError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("whereMoveToTheEnd", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.whereMoveToTheEnd((int item) => item > 4);

    expect(list, [1, 2, 4, 3, 10, 5]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("whereMoveToTheFront", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.whereMoveToTheFront((int item) => item > 4);

    expect(list, [10, 5, 1, 2, 4, 3]);
  });

  /////////////////////////////////////////////////////////////////////////////
}
