import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";

import "../utils.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("Initialization Assertion Errors", () {
    expect(() => LAdd<int>(null, 2), throwsAssertionError);
    expect(() => LAdd<int>(null, 2), throwsAssertionError);
    expect(() => LAdd<int>(null, null), throwsAssertionError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Runtime Type", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd, isA<LAdd<int>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("unlock", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.unlock, <int>[1, 2, 3, 4]);
    expect(lAdd.unlock, isA<List<int>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.isEmpty, isFalse);
    expect(lAdd.isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("length, first, last, single", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([4, 2, 3]), 1);
    expect(lAdd.length, 4);
    expect(lAdd.first, 4);
    expect(lAdd.last, 1);
    expect(() => lAdd.single, throwsStateError);
    expect(LAdd<int>(LFlat<int>([]), 1).single, 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("[]", () {
    // 1. Regular usage
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd[0], 1);
    expect(lAdd[1], 2);
    expect(lAdd[2], 3);
    expect(lAdd[3], 4);

    // 2. Range errors
    expect(() => lAdd[4], throwsA(isA<RangeError>()));
    expect(() => lAdd[-1], throwsA(isA<RangeError>()));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("contains", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    expect(lAdd.contains(1), isTrue);
    expect(lAdd.contains(5), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("iter", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([4, 2, 3]), 1);
    expect(lAdd.iter, allOf(isA<Iterable<int>>(), [4, 2, 3, 1]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("iterator", () {
    final LAdd<int> lAdd = LAdd<int>(LFlat<int>([1, 2, 3]), 4);
    final Iterator<int> iter = lAdd.iterator;

    expect(iter.current, isNull);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 1);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 2);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 3);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 4);
    expect(iter.moveNext(), isFalse);
    expect(iter.current, isNull);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable list doesn't change the LAdd
    List<int> original = [1, 2];
    LFlat<int> lFlat = LFlat(original);
    LAdd<int> lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.add(3);
    original.add(4);

    expect(original, <int>[1, 2, 3, 4]);
    expect(lAdd, <int>[1, 2, 3]);

    // 1.2) Adding to the original LAdd doesn't change it
    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd<int>(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    L<int> l = lAdd.add(4);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4]);

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside LAdd
    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    int willChange = 4;
    l = lAdd.add(willChange);

    willChange = 5;

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(willChange, 5);
    expect(l, <int>[1, 2, 3, 4]);

    // 2) addAll

    // 2.1) Changing the passed mutable list doesn't change the LAdd
    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.addAll(<int>[3, 4]);

    expect(original, <int>[1, 2, 3, 4]);
    expect(lAdd, <int>[1, 2, 3]);

    // 2.2) Changing the passed immutable list doesn't change the original LAdd

    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd<int>(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    l = lAdd.addAll([4, 5]);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4, 5]);

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = [1, 2];
    lFlat = LFlat(original);
    final LAdd<int> lAdd1 = LAdd<int>(lFlat, 3), lAdd2 = LAdd<int>(lFlat, 4);

    expect(lAdd1, <int>[1, 2, 3]);
    expect(lAdd2, <int>[1, 2, 4]);

    l = lAdd1.addAll(lAdd2);
    original.add(5);

    expect(original, <int>[1, 2, 5]);
    expect(lAdd1, <int>[1, 2, 3]);
    expect(lAdd2, <int>[1, 2, 4]);
    expect(l, <int>[1, 2, 3, 1, 2, 4]);

    // 3) remove

    // 3.1) Changing the passed mutable list doesn't change the LAdd
    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    original.remove(2);

    expect(original, <int>[1]);
    expect(lAdd, <int>[1, 2, 3]);

    // 3.2) Removing from the original LAdd doesn't change it
    original = [1, 2];
    lFlat = LFlat(original);
    lAdd = LAdd(lFlat, 3);

    expect(lAdd, <int>[1, 2, 3]);

    l = lAdd.remove(1);

    expect(original, <int>[1, 2]);
    expect(lAdd, <int>[1, 2, 3]);
    expect(l, <int>[2, 3]);
  });

  //////////////////////////////////////////////////////////////////////////////
}
