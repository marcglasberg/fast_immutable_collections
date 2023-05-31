// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("toIterable", () {
    final List<int> list = [1, 2, 3];
    final Iterator<int> iterator = list.iterator;

    expect(iterator.toIterable(), allOf(isA<Iterable<int>>(), [1, 2, 3]));
  });

  test("toList", () {
    // 1) growable = true
    final List<int> list1 = [1, 2, 3];
    final Iterator<int> iterator = list1.iterator;

    expect(iterator.toList(), allOf(isA<List<int>>(), [1, 2, 3]));
    iterator.toList(growable: true).add(4);

    // 2) growable = false
    final List<int> list2 = [1, 2, 3];
    final Iterator<int> iterator2 = list2.iterator;

    expect(iterator2.toList(growable: false), allOf(isA<List<int>>(), [1, 2, 3]));
    expect(() => iterator2.toList(growable: false).add(4), throwsUnsupportedError);
  });

  test("toIList", () {
    expect([1, 2, 3].iterator.toIList(), isA<IList<int>>());
    expect([1, 2, 3].iterator.toIList(), [1, 2, 3]);
  });

  test("toSet/toISet", () {
    expect([1, 2, 3, 3].iterator.toSet(), isA<Set<int>>());
    expect([1, 2, 3, 3].iterator.toSet(), {1, 2, 3});

    expect({1, 2, 3}.iterator.toISet(), isA<ISet<int>>());
    expect({1, 2, 3}.iterator.toISet(), {1, 2, 3});
  });
}
