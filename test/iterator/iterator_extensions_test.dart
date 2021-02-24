import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

////////////////////////////////////////////////////////////////////////////////

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("toIterable", () {
    final List<int> list = [1, 2, 3];
    final Iterator<int> iterator = list.iterator;

    expect(iterator.toIterable(), allOf(isA<Iterable<int>>(), [1, 2, 3]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toList", () {
    // 1) growable = true
    final List<int> list1 = [1, 2, 3];
    final Iterator<int> iterator = list1.iterator;

    expect(iterator.toList(), allOf(isA<List<int>>(), [1, 2, 3]));
    iterator.toList(growable: true).add(4);

    // 1) growable = false
    final List<int> list2 = [1, 2, 3];
    final Iterator<int> iterator2 = list2.iterator;

    expect(iterator2.toList(growable: false), allOf(isA<List<int>>(), [1, 2, 3]));
    expect(() => iterator2.toList(growable: false).add(4), throwsUnsupportedError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toSet", () {
    final List<int> list = [1, 2, 3, 3];
    final Iterator<int> iterator = list.iterator;

    expect(iterator.toSet(), allOf(isA<Set<int>>(), {1, 2, 3}));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toIList", () {
    final List<int> list = [1, 2, 3];
    final Iterator<int> iterator = list.iterator;

    expect(iterator.toIList(), allOf(isA<IList<int>>(), [1, 2, 3]));
  }, skip: true);

  //////////////////////////////////////////////////////////////////////////////

  test("toISet", () {
    final Set<int> set = {1, 2, 3};
    final Iterator<int> iterator = set.iterator;

    expect(iterator.toISet(), allOf(isA<ISet<int>>(), {1, 2, 3}));
  }, skip: true);

  //////////////////////////////////////////////////////////////////////////////
}
