import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("IListExtension.lock", () => expect([1, 2, 3].lock, allOf(isA<IList<int>>(), [1, 2, 3])));

  test("IListExtension.lockUnsafe", () {
    final List<int> list = [1, 2, 3];
    final IList<int> iList = list.lockUnsafe;

    expect(list, iList);

    list[1] = 4;

    expect(list, iList);
  });

  test("IListExtension.sortOrdered()", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.sortOrdered((int a, int b) => a.compareTo(b));

    expect(list, [1, 2, 3, 4, 5, 10]);
  });

  test("IListExtension.sortLike()", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.sortLike([1, 2, 3]);

    expect(list, [1, 2, 3, 4, 10, 5]);
  });

  test("IListExtension sortLike() | the ordering can't be null",
      () => expect(() => [1, 2, 3, 4, 10, 5].sortLike(null), throwsAssertionError));

  test("IListExtension.whereMoveToTheEnd()", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.whereMoveToTheEnd((int item) => item > 4);

    expect(list, [1, 2, 4, 3, 10, 5]);
  });

  test("IListExtension.whereMoveToTheFront()", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];

    list.whereMoveToTheFront((int item) => item > 4);

    expect(list, [10, 5, 1, 2, 4, 3]);
  });
}
