import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("length", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iset = baseSet.lock;
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet(iset);
    expect(modifiableSetView.length, baseSet.length);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iset = baseSet.lock;
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet(iset);
    expect(modifiableSetView.lock, allOf(isA<ISet<int>>(), baseSet));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet({1, 2, 3}.lock);
    expect(modifiableSetView.isEmpty, isFalse);
    expect(modifiableSetView.isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("contains", () {
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet({1, 2, 3}.lock);
    expect(modifiableSetView.contains(1), isTrue);
    expect(modifiableSetView.contains(2), isTrue);
    expect(modifiableSetView.contains(3), isTrue);
    expect(modifiableSetView.contains(4), isFalse);
    expect(modifiableSetView.contains(null), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("iterator", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iset = baseSet.lock;
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet(iset);
    final Iterator<int?> iterator = modifiableSetView.iterator;

    int count = 0;
    final Set<int?> result = {};
    while (iterator.moveNext()) {
      count++;
      result.add(iterator.current);
    }
    expect(count, baseSet.length);
    expect(result, baseSet);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toSet", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iset = baseSet.lock;
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet(iset);
    expect(modifiableSetView.toSet(), baseSet);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lookup", () {
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet({1, 2, 3}.lock);
    expect(modifiableSetView.lookup(1), 1);
    expect(modifiableSetView.lookup(2), 2);
    expect(modifiableSetView.lookup(3), 3);
    expect(modifiableSetView.lookup(4), null);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("add", () {
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet({1, 2, 3}.lock);
    expect(modifiableSetView.add(3), isFalse);
    expect(modifiableSetView.add(4), isTrue);
    expect(modifiableSetView.length, 4);
    expect(modifiableSetView.contains(4), isTrue);
    expect(modifiableSetView.contains(null), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    final ModifiableSetFromISet<int> modifiableSetView = ModifiableSetFromISet({1, 2, 3}.lock);
    expect(modifiableSetView.remove(4), isFalse);
    expect(modifiableSetView.remove(3), isTrue);
    expect(modifiableSetView.length, 2);
    expect(modifiableSetView.contains(3), isFalse);
    expect(modifiableSetView.contains(null), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////
}
