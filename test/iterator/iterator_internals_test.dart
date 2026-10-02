// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/src/iterator/iterator_add.dart";
import "package:fast_immutable_collections/src/iterator/iterator_add_all.dart";
import "package:fast_immutable_collections/src/iterator/iterator_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("IteratorAdd | Iterates the items and then the extra item", () {
    final IteratorAdd<int> iterator = IteratorAdd([1, 2].iterator, 3);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);
    expect(iterator.extraMove, isFalse);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 3);
    expect(iterator.extraMove, isTrue);
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);
  });

  test("IteratorAdd | Empty iterator", () {
    final IteratorAdd<int> iterator = IteratorAdd(<int>[].iterator, 7);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 7);
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
  });

  test("IteratorAdd | Nullable item", () {
    final IteratorAdd<int?> iterator = IteratorAdd<int?>(<int?>[1].iterator, null);
    final List<int?> result = [];
    while (iterator.moveNext()) result.add(iterator.current);
    expect(result, [1, null]);
  });

  test("IteratorAddAll | Iterates the items and then the extra items", () {
    final IteratorAddAll<int> iterator = IteratorAddAll([1, 2].iterator, [3, 4].iterator);
    expect(() => iterator.current, throwsStateError);
    final List<int> result = [];
    while (iterator.moveNext()) result.add(iterator.current);
    expect(result, [1, 2, 3, 4]);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);
  });

  test("IteratorAddAll | Empty iterators", () {
    final IteratorAddAll<int> empty = IteratorAddAll(<int>[].iterator, <int>[].iterator);
    expect(() => empty.current, throwsStateError);
    expect(empty.moveNext(), isFalse);
    expect(() => empty.current, throwsStateError);

    final IteratorAddAll<int> firstEmpty = IteratorAddAll(<int>[].iterator, [1].iterator);
    expect(firstEmpty.moveNext(), isTrue);
    expect(firstEmpty.current, 1);
    expect(firstEmpty.moveNext(), isFalse);

    final IteratorAddAll<int> secondEmpty = IteratorAddAll([1].iterator, <int>[].iterator);
    expect(secondEmpty.moveNext(), isTrue);
    expect(secondEmpty.current, 1);
    expect(secondEmpty.moveNext(), isFalse);
  });

  test("IteratorFlat | Wraps the iterator and gives better error messages", () {
    final IteratorFlat<int> iterator = IteratorFlat([1, 2].iterator);
    expect(
        () => iterator.current,
        throwsA(isA<StateError>().having((e) => e.message, "message",
            "No current value available. Call moveNext() first.")));
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);
    expect(iterator.moveNext(), isFalse);
    expect(
        () => iterator.current,
        throwsA(
            isA<StateError>().having((e) => e.message, "message", "No move values available.")));
  });

  test("IteratorFlat | Empty iterator", () {
    final IteratorFlat<int> iterator = IteratorFlat(<int>[].iterator);
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
  });
}
