import "dart:math";

import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";

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

  test("moveToTheEnd", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.moveToTheEnd(4);
    expect(list, [1, 2, 10, 3, 5, 4]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("moveToTheFront", () {
    final List<int> list = [1, 2, 4, 10, 3, 5];
    list.moveToTheFront(4);
    expect(list, [4, 1, 2, 10, 3, 5]);
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("toggle", () {
    List<int> list = [1, 2, 3, 4, 5];

    // 1) Toggle existing item
    expect(list.contains(4), isTrue);
    expect(list.toggle(4), isTrue);
    expect(list.contains(4), isFalse);
    expect(list.toggle(4), isFalse);
    expect(list.contains(4), isTrue);

    // 2) Toggle NON-existing item
    expect(list.contains(6), isFalse);
    expect(list.toggle(6), isFalse);
    expect(list.contains(6), isTrue);
    expect(list.toggle(6), isTrue);
    expect(list.contains(6), isFalse);

    // 3) Nulls and other checks
    list = <int>[];
    expect(list.toggle(1), isFalse);
    expect(list.contains(1), isTrue);

    list = <int>[];
    expect(list.toggle(null), isFalse);
    expect(list.contains(null), isTrue);

    list = <int>[null];
    expect(list.toggle(1), isFalse);
    expect(list.contains(1), isTrue);

    list = <int>[null];
    expect(list.toggle(null), isTrue);
    expect(list.contains(null), isFalse);

    list = <int>[1];
    expect(list.toggle(1), isTrue);
    expect(list.contains(1), isFalse);

    list = <int>[1];
    expect(list.toggle(null), isFalse);
    expect(list.contains(null), isTrue);

    list = <int>[null, null, null];
    expect(list.toggle(1), isFalse);
    expect(list.contains(1), isTrue);

    list = <int>[null, null, null];
    expect(list.toggle(null), isTrue);
    expect(list, <int>[null, null]);

    list = <int>[null, 1, null, 1];
    expect(list.toggle(1), isTrue);
    expect(list, <int>[null, null, 1]);

    list = <int>[null, 1, null, 1];
    expect(list.toggle(null), isTrue);
    expect(list, <int>[1, null, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("compareAsSets", () {
    // 1) Identical
    const List<int> list1 = [1, 2, 3];
    const List<int> list2 = [1, 2, 3];
    const List<int> list3 = [1, 2, 4];
    const List<int> list4 = [1, 2, 2, 3, 3, 3];
    const List<int> list5 = [1, 2, 2, 3, 3, 3, 4];
    expect(list1.compareAsSets(list1), isTrue);
    expect(list1.compareAsSets(list2), isTrue);
    expect(list1.compareAsSets(list3), isFalse);
    expect(list1.compareAsSets(list4), isTrue);
    expect(list1.compareAsSets(list5), isFalse);

    // 3) Nulls
    List<int> list;
    expect(list.compareAsSets(null), isTrue);
    expect(list.compareAsSets([]), isFalse);
    expect([].compareAsSets(list), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("mapIndexed", () {
    expect(
        [1, 2, 3].mapIndexed((int index, int item) => (index + item).toString()), ["1", "3", "5"]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("splitList", () {
    expect([].splitList((v) => v == 3), []);

    expect([1, 2, 3, 4, 5].splitList((v) => v == 2 || v == 4), [
      [1],
      [3],
      [5]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList((v) => v == 3), [
      [1, 2],
      [4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList((v) => v == 1), [
      [2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].splitList((v) => v == 7), [
      [1, 2, 3, 4, 5, 6]
    ]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("divideList", () {
    //
    expect([].divideList((v) => v == 3), []);

    expect([1, 2, 3, 4, 5].divideList((v) => v == 2 || v == 4), [
      [1, 2, 3],
      [4, 5]
    ]);

    expect([0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1].divideList((v) => v == 1), [
      [0, 1, 0],
      [1, 0],
      [1],
      [1, 0, 0],
      [1],
      [1],
      [1],
      [1],
      [1, 0],
      [1]
    ]);

    expect([1].divideList((v) => v == 1), [
      [1]
    ]);

    expect([1, 2].divideList((v) => v == 1), [
      [1, 2]
    ]);

    expect([1, 2].divideList((v) => v == 2), [
      [1, 2],
    ]);

    expect([1, 2, 3].divideList((v) => v == 2), [
      [1, 2, 3]
    ]);

    expect([1, 2, 3].divideList((v) => v == 2 || v == 3), [
      [1, 2],
      [3]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 3), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 1), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 7), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 8), [
      [1, 2, 3, 4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 3 || v == 4), [
      [1, 2, 3],
      [4, 5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 3 || v == 5), [
      [1, 2, 3, 4],
      [5, 6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v == 3 || v == 6), [
      [1, 2, 3, 4, 5],
      [6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v % 2 == 0), [
      [1, 2, 3],
      [4, 5],
      [6, 7]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7].divideList((v) => v % 2 == 1), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7]
    ]);

    expect([1, 2, 3, 8, 12, 1, 4, 6].divideList((v) => v % 2 == 1), [
      [1, 2],
      [3, 8, 12],
      [1, 4, 6],
    ]);
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("divideListAsMap", () {
    //
    expect([].divideListAsMap((v) => v == 3, key: (v) => -v), {});

    expect([1].divideListAsMap((v) => v == 1), {
      1: [1],
    });

    expect([1].divideListAsMap((v) => v == 1, key: (v) => -v), {
      -1: [1],
    });

    expect([1, 2].divideListAsMap((v) => v == 1, key: (v) => -v), {
      -1: [1, 2]
    });

    expect([1, 2].divideListAsMap((v) => v == 2, key: (v) => -v), {
      -2: [1, 2],
    });

    expect([1, 2, 3].divideListAsMap((v) => v == 2, key: (v) => -v), {
      -2: [1, 2, 3]
    });

    expect([1, 2, 3].divideListAsMap((v) => v == 2 || v == 3, key: (v) => -v), {
      -2: [1, 2],
      -3: [3]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 3, key: (v) => -v), {
      -3: [1, 2, 3, 4, 5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 1, key: (v) => -v), {
      -1: [1, 2, 3, 4, 5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 7, key: (v) => -v), {
      -7: [1, 2, 3, 4, 5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 8, key: (v) => -v), {
      null: [1, 2, 3, 4, 5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 3 || v == 4, key: (v) => -v), {
      -3: [1, 2, 3],
      -4: [4, 5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 3 || v == 5, key: (v) => -v), {
      -3: [1, 2, 3, 4],
      -5: [5, 6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v == 3 || v == 6, key: (v) => -v), {
      -3: [1, 2, 3, 4, 5],
      -6: [6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v % 2 == 0, key: (v) => -v), {
      -2: [1, 2, 3],
      -4: [4, 5],
      -6: [6, 7]
    });

    expect([1, 2, 3, 4, 5, 6, 7].divideListAsMap((v) => v % 2 == 1, key: (v) => -v), {
      -1: [1, 2],
      -3: [3, 4],
      -5: [5, 6],
      -7: [7]
    });

    /// Repeating keys will be joined together.
    expect([1, 2, 3, 8, 12, 1, 4, 6].divideListAsMap((v) => v % 2 == 1), {
      1: [1, 2, 1, 4, 6],
      3: [3, 8, 12],
    });
  });

  // /////////////////////////////////////////////////////////////////////////////

  test("addBetween", () {
    expect(null.addBetween("|"), null);
    expect([].addBetween("|"), []);
    expect(["A"].addBetween("|"), ["A"]);
    expect(["A", "B"].addBetween("|"), ["A", "|", "B"]);
    expect(["A", "B", "C"].addBetween("|"), ["A", "|", "B", "|", "C"]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Efficiently Concat lists. The resulting list has fixed size.", () {
    expect([].concat([], []), []);
    expect([5].concat([], []), [5]);
    expect([].concat([6], []), [6]);
    expect([].concat([], [7]), [7]);
    expect([1, 2].concat([3, 4, 5, 6], [7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect([1, 2].concat([7, 8, 9]), [1, 2, 7, 8, 9]);
    expect([1, 2].concat([], [7, 8, 9]), [1, 2, 7, 8, 9]);
    expect([1, 2].concat([2, 3], [3, 4]), [1, 2, 2, 3, 3, 4]);
    expect([1, 2].concat([2, 3], null, [3, 4]), [1, 2, 2, 3, 3, 4]);
    expect(null.concat([2, 3], null, [3, 4]), [2, 3, 3, 4]);
    expect([10, 2].concat([20, 3], [30]), [10, 2, 20, 3, 30]);
    expect(["10", 2].concat([20, "3"], [30]), ["10", 2, 20, "3", 30]);
    expect(["10", 2].concat([20, "3"], [30], ["a", "b"]), ["10", 2, 20, "3", 30, "a", "b"]);
    expect([1].concat([2], [3], [4], [5]), [1, 2, 3, 4, 5]);

    // The resulting list is not unmodifiable/immutable.
    var list = [1, 2].concat([3, 4]);
    list[2] = 100;
    expect(list, [1, 2, 100, 4]);

    // The resulting list has fixed size.
    expect(() => [1, 2].concat([3, 4])..add(5), throwsA(isA<Error>()));
  });

  /////////////////////////////////////////////////////////////////////////////

  test("splitByLength", () {
    //
    expect([1, 2, 3, 4, 5, 6, 7, 8].splitByLength(2), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8],
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(2), [
      [1, 2],
      [3, 4],
      [5, 6],
      [7, 8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(1), [
      [1],
      [2],
      [3],
      [4],
      [5],
      [6],
      [7],
      [8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(3), [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(8), [
      [1, 2, 3, 4, 5, 6, 7, 8],
      [9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(9), [
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
    ]);

    expect([1, 2, 3, 4, 5, 6, 7, 8, 9].splitByLength(50), [
      [1, 2, 3, 4, 5, 6, 7, 8, 9]
    ]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("update", () {
    //
    var list = <_WithId>[];
    var newItems = [_WithId(id: "x", name: "Lyn")];
    var updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [_WithId(id: "x", name: "Lyn")]);

    //
    list = [_WithId(id: "x", name: "Lyn")];
    newItems = <_WithId>[];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [_WithId(id: "x", name: "Lyn")]);

    //
    list = [_WithId(id: "x", name: "Marc")];
    newItems = [_WithId(id: "x", name: "Lyn")];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [_WithId(id: "x", name: "Lyn")]);

    //
    list = [_WithId(id: "x", name: "Marc")];
    newItems = [_WithId(id: "a", name: "Lyn")];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "x", name: "Marc"),
      _WithId(id: "a", name: "Lyn"),
    ]);

    //
    // Replace the first, remove the second.
    list = [_WithId(id: "x", name: "Marc"), _WithId(id: "x", name: "Marc")];
    newItems = [_WithId(id: "x", name: "Lyn")];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "x", name: "Lyn"),
    ]);

    //
    // Remove nulls.
    list = [_WithId(id: "x", name: "Marc"), null, _WithId(id: "x", name: "Marc")];
    newItems = [];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "x", name: "Marc"),
      _WithId(id: "x", name: "Marc"),
    ]);

    //
    list = [_WithId(id: "x", name: "Marc")];
    newItems = [_WithId(id: "a", name: "Lyn"), _WithId(id: "a", name: "Lyn")];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "x", name: "Marc"),
      _WithId(id: "a", name: "Lyn"),
      _WithId(id: "a", name: "Lyn"),
    ]);

    //
    list = [_WithId(id: "a", name: "Marc")];
    newItems = [_WithId(id: "a", name: "Lyn"), _WithId(id: "a", name: "Lyn")];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "a", name: "Lyn"),
      _WithId(id: "a", name: "Lyn"),
    ]);

    //
    list = [null, _WithId(id: "x", name: "Marc")];
    newItems = [null, _WithId(id: "a", name: "Lyn"), null];
    updatedList = list.update(newItems, (_WithId obj) => obj.id);
    expect(updatedList, [
      _WithId(id: "x", name: "Marc"),
      _WithId(id: "a", name: "Lyn"),
    ]);

    //
    list = [
      _WithId(id: "x", name: "Marc"),
      _WithId(id: "y", name: "Bill"),
      _WithId(id: "z", name: "Luke"),
      _WithId(id: "k", name: "July"),
      _WithId(id: "l", name: "Samy"),
      _WithId(id: "m", name: "Jane"),
      _WithId(id: "n", name: "Zack"),
    ];

    newItems = [
      _WithId(id: "x", name: "Lyn"),
      _WithId(id: "a", name: "Richard"),
      _WithId(id: "l", name: "Lea"),
      _WithId(id: "n", name: "Amy"),
    ];

    updatedList = list.update(newItems, (_WithId obj) => obj.id);

    expect(updatedList, [
      _WithId(id: "x", name: "Lyn"),
      _WithId(id: "y", name: "Bill"),
      _WithId(id: "z", name: "Luke"),
      _WithId(id: "k", name: "July"),
      _WithId(id: "l", name: "Lea"),
      _WithId(id: "m", name: "Jane"),
      _WithId(id: "n", name: "Amy"),
      _WithId(id: "a", name: "Richard"),
    ]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("distinct", () {
    expect(([].distinct()), []);
    expect(([5, 5, 5].distinct()), [5]);
    expect(([1, 2, 3, 4].distinct()), [1, 2, 3, 4]);
    expect(([1, 2, 3, 4, 3, 5, 3].distinct()), [1, 2, 3, 4, 5]);
    expect(([1, 2, 3, 4, 3, 5, 1].distinct()), [1, 2, 3, 4, 5]);
    expect((["abc", "abc", "def"].distinct()), ["abc", "def"]);
    expect((["abc", "abc", "def"].distinct()).take(1), ["abc"]);

    expect(
        (["a", "b", "abc", "ab", "def"].distinct(by: (item) => item.length)), ["a", "abc", "ab"]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversedView runtime type", () {
    expect([].reversed is Iterable, isTrue);
    expect([].reversed is List, isFalse);
    expect([].reversedView is List, isTrue);
    expect([1].reversedView is List<int>, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView | single, first, last, length", () {
    // 1) single

    expect(() => [].reversedView.single, throwsStateError);
    expect(() => [1, 2].reversedView.single, throwsStateError);
    expect([1].reversedView.single, 1);

    // 2) first | last

    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.first, 4);

    expect(reversed.last, 0);

    expect(() => [].reversedView.first, throwsStateError);
    expect(() => [].reversedView.last, throwsStateError);

    // 3) length

    expect(reversed.length, 6);

    // 4) length, first and  last setters

    list.first = 100;
    expect(list.first, 100);

    list.last = 500;
    expect(list.last, 500);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView | set length", () {
    var list = [0, 1, 2, 3, 4, 5, 6];
    var reversed = list.reversedView;

    reversed.length = 4;
    expect(reversed, [6, 5, 4, 3]);
    expect(list, [3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.indexWhere", () {
    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.indexWhere((i) => i == 0), 5);
    expect(reversed.indexWhere((i) => i == 1), 4);
    expect(reversed.indexWhere((i) => i == 2), 3);
    expect(reversed.indexWhere((i) => i == 3), 1);
    expect(reversed.indexWhere((i) => i == 4), 0);
    expect(reversed.indexWhere((i) => i == 5), null);
    expect(reversed.indexWhere((i) => i == 4, 1), null);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.lastIndexWhere", () {
    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.lastIndexWhere((i) => i == 0), 5);
    expect(reversed.lastIndexWhere((i) => i == 1), 4);
    expect(reversed.lastIndexWhere((i) => i == 2), 3);
    expect(reversed.lastIndexWhere((i) => i == 3), 2);
    expect(reversed.lastIndexWhere((i) => i == 4), 0);
    expect(reversed.lastIndexWhere((i) => i == 5), null);

    expect(reversed.lastIndexWhere((i) => i == 0, 1), null);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.+", () {
    List<int> list = [1, 2, 3].reversedView;

    expect(list + [4, 5, 6], [3, 2, 1, 4, 5, 6]);
    expect(list + [4], [3, 2, 1, 4]);
    expect(list + [null], [3, 2, 1, null]);
    expect(() => list + null, throwsNoSuchMethodError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.[]", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;

    expect(reversed[0], 4);
    expect(reversed[1], 3);
    expect(reversed[2], 2);
    expect(reversed[3], 1);
    expect(reversed[4], 0);
    expect(() => reversed[5], throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.[]=", () {
    List<int> list = [1, 2, 3].reversedView;

    expect(() => list[-100] = 10, throwsRangeError);
    expect(() => list[-1] = 10, throwsRangeError);
    expect(() => list[100] = 10, throwsRangeError);
    expect(() => list[3] = 10, throwsRangeError);

    list[0] = 10;
    expect(list, [10, 2, 1]);
    list[1] = 10;
    expect(list, [10, 10, 1]);
    list[2] = 10;
    expect(list, [10, 10, 10]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.add", () {
    List<int> reversed = [1, 2, 3].reversedView;

    reversed.add(1);
    expect(reversed, [3, 2, 1, 1]);

    reversed.add(null);
    expect(reversed, [3, 2, 1, 1, null]);

    reversed = <int>[null].reversedView;
    reversed.add(1);
    expect(reversed, <int>[null, 1]);

    reversed = [null, 1, null, 2].reversedView;
    reversed.add(10);
    expect(reversed, <int>[2, null, 1, null, 10]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.addAll", () {
    List<int> reversed = [1, 2, 3].reversedView;

    reversed.addAll([1, 2]);
    expect(reversed, [3, 2, 1, 1, 2]);

    reversed.addAll([1, null]);
    expect(reversed, [3, 2, 1, 1, 2, 1, null]);

    reversed = <int>[null].reversedView;
    reversed.addAll([1, 2]);
    expect(reversed, <int>[null, 1, 2]);

    reversed = [null, 1, null, 2].reversedView;
    reversed.addAll([10, 11]);
    expect(reversed, <int>[2, null, 1, null, 10, 11]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.elementAt", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;

    expect(reversed.elementAt(0), 4);
    expect(reversed.elementAt(1), 3);
    expect(reversed.elementAt(2), 2);
    expect(reversed.elementAt(3), 1);
    expect(reversed.elementAt(4), 0);
    expect(() => reversed.elementAt(5), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.any", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;

    expect(reversed.any((i) => i == 2), isTrue);
    expect(reversed.any((i) => i == 5), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.asMap", () {
    expect([1, 2, 3].reversedView.asMap(), {0: 3, 1: 2, 2: 1});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.cast", () {
    const TypeMatcher<TypeError> isTypeError = TypeMatcher<TypeError>();
    final Matcher throwsTypeError = throwsA(isTypeError);

    final List<int> reversed = [1, 2, 3].reversedView;
    expect(reversed.cast<num>(), allOf(isA<List<num>>(), <num>[3, 2, 1]));
    expect(() => reversed.cast<String>(), throwsTypeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.clear", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;
    expect(reversed, [4, 3, 2, 1, 0]);
    expect(reversed.isEmpty, isFalse);
    reversed.clear();
    expect(reversed, []);
    expect(reversed.isEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.contains", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;

    expect(reversed.contains(0), isTrue);
    expect(reversed.contains(1), isTrue);
    expect(reversed.contains(2), isTrue);
    expect(reversed.contains(3), isTrue);
    expect(reversed.contains(4), isTrue);
    expect(reversed.contains(5), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.every", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.every((int v) => v > 0), isTrue);
    expect(reversed.every((int v) => v < 0), isFalse);
    expect(reversed.every((int v) => v != 4), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.expand", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.expand((int v) => [v, v]),
        allOf(isA<Iterable<int>>(), [6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1]));
    expect(reversed.expand((int v) => <int>[]), allOf(isA<Iterable<int>>(), <int>[]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.fillRange", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;
    reversed.fillRange(2, 5, -1);
    expect(reversed, [9, 8, -1, -1, -1, 4, 3, 2, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.firstWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.firstWhere((int v) => v <= 1, orElse: () => 100), 1);
    expect(reversed.firstWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(reversed.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(reversed.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.fold", () {
    expect([1, 2, 3, 4, 5, 6].reversedView.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.followedBy", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.followedBy([7, 8]), [6, 5, 4, 3, 2, 1, 7, 8]);
    expect(reversed.followedBy(<int>[].lock.add(7).addAll([8, 9])), [6, 5, 4, 3, 2, 1, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.forEach", () {
    int result = 100;
    [1, 2, 3, 4, 5, 6].reversedView.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.getRange", () {
    final List<String> colors = ["red", "green", "blue", "orange", "pink"].reversedView;
    expect(colors, ["pink", "orange", "blue", "green", "red"]);
    expect(colors.getRange(1, 4), ["orange", "blue", "green"]);

    expect(() => colors.getRange(1, 400), throwsRangeError);
    expect(() => colors.getRange(4, 1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.indexOf", () {
    //
    var list = ["do", "re", "mi", "re"];
    var reversed = list.reversedView;

    // 1) Regular usage
    expect(reversed.indexOf("fa"), -1);
    expect(reversed.indexOf("do"), 3);
    expect(reversed.indexOf("re"), 0);
    expect(reversed.indexOf("re", 1), 2);

    // 2) Wrong start
    expect(list.indexOf("do", -1), 0);
    expect(reversed.indexOf("re", -1), 0);
    expect(list.indexOf("do", -10), 0);
    expect(reversed.indexOf("re", -10), 0);
    expect(list.indexOf("do", 100), -1);
    expect(reversed.indexOf("re", 100), -1);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversedView.lastIndexOf", () {
    var list = ["re", "mi", "re", "do"];
    var reversed = list.reversedView;

    // 1) Regular usage
    expect(reversed.lastIndexOf("fa"), -1);
    expect(reversed.lastIndexOf("do"), 0);
    expect(reversed.lastIndexOf("re"), 3);
    expect(reversed.lastIndexOf("re", 0), -1);
    expect(reversed.lastIndexOf("re", 1), 1);
    expect(reversed.lastIndexOf("re", 2), 1);
    expect(reversed.lastIndexOf("re", 3), 3);

    // 2) Wrong start
    expect(reversed.lastIndexOf("fa", 10), -1);
    expect(reversed.lastIndexOf("fa", -10), -1);
    expect(reversed.lastIndexOf("do", 10), 0);
    expect(reversed.lastIndexOf("do", -10), -1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.insert", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insert(2, "fa");

    expect(reversed, ["re", "mi", "fa", "re", "do"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.insertAll", () {
    List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insertAll(2, ["fa"]);
    expect(reversed, ["re", "mi", "fa", "re", "do"]);

    reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insertAll(2, ["fa", "sol"]);
    expect(reversed, ["re", "mi", "fa", "sol", "re", "do"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView || isEmpty | isNotEmpty", () {
    expect([].reversedView, isEmpty);
    expect([1].reversedView, isNotEmpty);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.iterator", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;
    var iterator = reversed.iterator;

    expect(iterator.current, isNull);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, reversed[0]);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, reversed[1]);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, reversed[2]);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, reversed[3]);

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, reversed[4]);

    expect(iterator.moveNext(), isFalse);
    expect(iterator.current, isNull);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversedView.join", () {
    expect([1, 2, 3, 4, 5, 6].reversedView.join(","), "6,5,4,3,2,1");
    expect([].reversedView.join(","), "");
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversedView.lastWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v < 5, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(reversed.lastWhere((int v) => v >= 5, orElse: () => 100), 5);
    expect(reversed.lastWhere((int v) => v < 50, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.map", () {
    expect([1, 2, 3].reversedView.map((int v) => v + 1), [4, 3, 2]);
    expect([1, 2, 3, 4, 5, 6].reversedView.map((int v) => v + 1), [7, 6, 5, 4, 3, 2]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.reduce", () {
    // 1) Regular usage
    expect([1, 2, 3, 4, 5, 6].reversedView.reduce((int p, int e) => p * (1 + e)), 4320);
    expect([5].reversedView.reduce((int p, int e) => p * (1 + e)), 5);

    // 2) State Exception
    expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.remove", () {
    List<int> reversed = [1, 2, 3].reversedView;

    expect(reversed.remove(2), isTrue);
    expect(reversed, [3, 1]);

    expect(reversed.remove(3), isTrue);
    expect(reversed, [1]);

    expect(reversed.remove(10), isFalse);
    expect(reversed, [1]);

    expect(reversed.remove(1), isTrue);
    expect(reversed, []);

    expect(reversed.remove(10), isFalse);
    expect(reversed, []);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.removeAt", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    expect(reversed.removeAt(1), "mi");
    expect(reversed, ["re", "re", "do"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.removeLast", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    expect(reversed.removeLast(), "do");
    expect(reversed, ["re", "mi", "re"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.removeRange", () {
    final List<String> reversed = ["do", "re", "mi", "fa", "sol", "la"].reversedView;
    reversed.removeRange(1, 3);
    expect(reversed, ["la", "mi", "re", "do"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.removeWhere", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    reversed.removeWhere((String item) => item.length == 3);
    expect(reversed, ["four", "three"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.replaceRange", () {
    final List<String> reversed = ["a", "b", "c", "d", "e", "f"].reversedView;
    reversed.replaceRange(1, 4, ["1", "2"]);
    expect(reversed, ["f", "1", "2", "b", "a"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.retainWhere", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    reversed.retainWhere((String item) => item.length == 3);
    expect(reversed, ["two", "one"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.reversed", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    expect(reversed.reversed, ["one", "two", "three", "four"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.setAll", () {
    List<int> reversed = [1, 2, 3, 4, 5].reversedView;
    reversed.setAll(0, [-10, -100]);
    expect(reversed, [-10, -100, 3, 2, 1]);

    reversed = [1, 2, 3, 4, 5].reversedView;
    reversed.setAll(1, [-10, -100]);
    expect(reversed, [5, -10, -100, 2, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.setRange", () {
    List<String> reversed = ["1", "2", "3", "4"].reversedView;
    reversed.setRange(1, 3, ["10", "11", "12"]);
    expect(reversed, ["4", "10", "11", "1"]);

    reversed = ["1", "2", "3", "4"].reversedView;
    reversed.setRange(1, 3, ["10", "11", "12"], 1);
    expect(reversed, ["4", "11", "12", "1"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.shuffle", () {
    List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    reversed.shuffle(Random(0));
    expect(reversed, [4, 2, 7, 8, 6, 9, 3, 5, 1]);

    reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    reversed.shuffle(Random(1));
    expect(reversed, [7, 4, 2, 8, 1, 9, 3, 6, 5]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.singleWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    // 1) Regular usage
    expect(reversed.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(reversed.singleWhere((int v) => v == 50, orElse: () => 100), 100);

    // 2) State Exception
    expect(() => reversed.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.skip", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;

    expect(reversed.skip(1), [5, 4, 3, 2, 1]);
    expect(reversed.skip(3), [3, 2, 1]);
    expect(reversed.skip(5), [1]);
    expect(reversed.skip(10), <int>[]);
    expect(() => reversed.skip(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.skipWhile", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.skipWhile((int v) => v > 3), [3, 2, 1]);
    expect(reversed.skipWhile((int v) => v >= 5), [4, 3, 2, 1]);
    expect(reversed.skipWhile((int v) => v < 6), [6, 5, 4, 3, 2, 1]);
    expect(reversed.skipWhile((int v) => v < 100), []);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.sort", () {
    List<int> list = [1, 5, 3, 2, 4, 6];
    List<int> reversed = list.reversedView;

    reversed.sort();
    expect(list, [6, 5, 4, 3, 2, 1]);
    expect(reversed, [1, 2, 3, 4, 5, 6]);

    list.sort();
    expect(list, [1, 2, 3, 4, 5, 6]);
    expect(reversed, [6, 5, 4, 3, 2, 1]);

    // ---

    list = [1, 5, 3, 4, 6];
    reversed = list.reversedView;

    reversed.sort((int a, int b) => a.compareTo(b));
    expect(list, [6, 5, 4, 3, 1]);
    expect(reversed, [1, 3, 4, 5, 6]);

    list.sort((int a, int b) => a.compareTo(b));
    expect(list, [1, 3, 4, 5, 6]);
    expect(reversed, [6, 5, 4, 3, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.sublist", () {
    final List<String> colors = ["red", "green", "blue", "orange", "pink"].reversedView;
    expect(colors.sublist(1, 3), ["orange", "blue"]);
    expect(colors.sublist(1), ["orange", "blue", "green", "red"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"].reversed);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.take", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.take(0), []);
    expect(reversed.take(1), [6]);
    expect(reversed.take(3), [6, 5, 4]);
    expect(reversed.take(5), [6, 5, 4, 3, 2]);
    expect(reversed.take(10), [6, 5, 4, 3, 2, 1]);
    expect(() => reversed.take(-1), throwsRangeError);
    expect(() => reversed.take(-100), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.takeWhile", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.takeWhile((int v) => v < 3), []);
    expect(reversed.takeWhile((int v) => v >= 5), [6, 5]);
    expect(reversed.takeWhile((int v) => v > 1), [6, 5, 4, 3, 2]);
    expect(reversed.takeWhile((int v) => v < 100), [6, 5, 4, 3, 2, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.toList", () {
    List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.toList(), [6, 5, 4, 3, 2, 1]);

    reversed.add(7);
    expect(reversed.toList(), [6, 5, 4, 3, 2, 1, 7]);

    List<int> fixedList = reversed.toList(growable: false);
    expect(() => fixedList.add(8), throwsUnsupportedError);
    expect(fixedList.toList(), [6, 5, 4, 3, 2, 1, 7]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.toSet", () {
    final List<int> reversed = [1, 2, 2, 3, 4, 4, 5, 6].reversedView;
    expect(reversed.toSet(), allOf(isA<Set<int>>(), {1, 2, 3, 4, 5, 6}));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.where", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.where((int v) => v < 0), []);
    expect(reversed.where((int v) => v < 3), [2, 1]);
    expect(reversed.where((int v) => v < 5), [4, 3, 2, 1]);
    expect(reversed.where((int v) => v < 100), [6, 5, 4, 3, 2, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("reversedView.whereType", () {
    expect(<num>[1, 2, 1.5].reversedView.whereType<double>(), [1.5]);
  });
}

//////////////////////////////////////////////////////////////////////////////

class _WithId {
  String id;
  String name;

  _WithId({this.id, this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WithId && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => "_WithId{$id, $name}";
}

// /////////////////////////////////////////////////////////////////////////////
