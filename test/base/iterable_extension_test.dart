import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = true;
    ImmutableCollection.prettyPrint = true;
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("deepEqualsByIdentity", () {
    expect([].deepEqualsByIdentity(null), false);
    expect([].deepEqualsByIdentity([]), true);
    expect([1].deepEqualsByIdentity([1]), true);
    expect([1].deepEqualsByIdentity([2]), false);
    expect([1, 2].deepEqualsByIdentity([1, 2]), true);
    expect([1, 2].deepEqualsByIdentity([3, 4]), false);
    expect([1, 2].deepEqualsByIdentity([1, 3]), false);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2]), false);

    // Now with objects that are equal by value:
    var obj1 = _ClassEqualsByValue();
    expect(obj1 == obj1, true);
    expect([obj1].deepEqualsByIdentity([obj1]), true);
    expect([obj1].deepEqualsByIdentity([_ClassEqualsByValue()]), false);

    var obj2 = _ClassEqualsByValue();
    expect(obj1 == obj2, true);
    expect([obj1].deepEqualsByIdentity([obj2]), false);
    expect([obj1, obj2].deepEqualsByIdentity([obj1, obj2]), true);

    // Comparing to non-list objects
    expect([].deepEqualsByIdentity({}), true);
    expect([1].deepEqualsByIdentity({1}), true);
    expect([1].deepEqualsByIdentity({2}), false);
    expect([1, 2].deepEqualsByIdentity({1, 2}), true);
    expect([1, 2].deepEqualsByIdentity({3, 4}), false);
    expect([1, 2].deepEqualsByIdentity({1, 3}), false);
    expect([1, 2].deepEqualsByIdentity([1, 2, 2].iterator.toIterable()), false);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("removeDuplicates", () {
    expect(([].removeDuplicates()), []);
    expect(([5, 5, 5].removeDuplicates()), [5]);
    expect(([1, 2, 3, 4].removeDuplicates()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3].removeDuplicates()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1].removeDuplicates()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"].removeDuplicates()), ["abc", "def"]);
    expect((["abc", "abc", "def"].removeDuplicates()).take(1), ["abc"]);

    expect((["a", "b", "abc", "ab", "def"].removeDuplicates(by: (item) => item.length)),
        ["a", "abc", "ab"]);

    expect(
        (["a", "b", "abc", "ab", "def"]
            .removeDuplicates(by: (item) => item.length, removeNulls: true)),
        ["a", "abc", "ab"]);

    expect(([null, 1, 2, 3, null, 4, 3, 5, 1, null].removeDuplicates(removeNulls: true)),
        [1, 2, 3, 4, 5]);

    expect(
        ([null, "a", "b", null, "abc", "ab", "def", null]
            .removeDuplicates(by: ((item) => item?.length), removeNulls: true)),
        ["a", "abc", "ab"]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("sortedLike", () {
    expect([1, 2, 3].sortedLike([1, 2, 3]), [1, 2, 3]);
    expect([1, 2, 3].sortedLike(<int>[]), [1, 2, 3]);
    expect(<int>[].sortedLike([1, 2, 3]), isEmpty);
    expect([2, 3].sortedLike([1, 2]), [2, 3]);
    expect([3, 4, 5, 6, 7].sortedLike([5, 4, 3, 2, 1]), [5, 4, 3, 6, 7]);
    expect([3, 4, 5, 7, 6].sortedLike([5, 4, 3, 2, 1]), [5, 4, 3, 7, 6]);
    expect([7, 3, 4, 6].sortedLike([5, 4, 3, 2, 1]), [4, 3, 7, 6]);
    expect([2, 3, 1].sortedLike([1, 2, 2, 1]), [1, 2, 3]);
    expect([3, 2].sortedLike([3, 1, 2, 3, 2, 1]), [3, 2]);
    expect([3, 2].sortedLike([1, 5, 2]), [2, 3]);
    expect([3, 2].sortedLike([10, 50, 20]), [3, 2]);
    expect([3, 2].sortedLike([1, 2, 3, 2, 1]), [2, 3]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("findDuplicates", () {
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), {"C", "A"});
    expect(["A", "B", "C", "D", "C", "A", "E"].findDuplicates(), ["C", "A"]);
    expect(["A", "B", "C", "E"].findDuplicates(), <String>{});
    expect(["A", "B", "C", "E"].findDuplicates(), <String>[]);
    expect(["A", "B", "B", "B"].findDuplicates(), {"B"});
    expect(["A", "B", "B", "B"].findDuplicates(), ["B"]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("firstWhereOrNull", () {
    List<String> list = ["A", "B", "C"];
    expect(list.firstWhereOrNull((String value) => value == "C"), "C");
    expect(list.firstWhereOrNull((String value) => value == "D"), null);
    expect(list.firstWhereOrNull((String value) => value == "D", orElse: () => "Z"), "Z");
  });
}

class _ClassEqualsByValue {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _ClassEqualsByValue && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

// /////////////////////////////////////////////////////////////////////////////
