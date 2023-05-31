// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
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
    // ignore: prefer_void_to_null
    expect([null].lock, isA<IList<void>>());
    expect([null].lock.length, 1);
    expect([null].lock[0], null);

    // 5) Typical usage
    expect([1, 2, 3].lock, allOf(isA<IList<int>>(), [1, 2, 3]));
  });

  test("lockUnsafe", () {
    final List<int> list = [1, 2, 3];
    final IList<int> ilist = list.lockUnsafe;

    expect(list, ilist);

    list[1] = 4;

    expect(list, ilist);
  });
}
