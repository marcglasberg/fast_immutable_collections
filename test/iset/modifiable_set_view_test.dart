import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Non-mutable operations | ModifiableSetView.length getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iSet = baseSet.lock;
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView(iSet);
    expect(modifiableSetView.length, baseSet.length);
  });

  test("Non-mutable operations | ModifiableSetView.lock getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iSet = baseSet.lock;
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView(iSet);
    expect(modifiableSetView.lock, allOf(isA<ISet<int>>(), baseSet));
  });

  test("Non-mutable operations | isEmpty | isNotEmpty", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView({1, 2, 3}.lock);
    expect(modifiableSetView.isEmpty, isFalse);
    expect(modifiableSetView.isNotEmpty, isTrue);
  });

  test("Non-mutable operations | ModifiableSetView.contains()", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView({1, 2, 3}.lock);
    expect(modifiableSetView.contains(1), isTrue);
    expect(modifiableSetView.contains(2), isTrue);
    expect(modifiableSetView.contains(3), isTrue);
    expect(modifiableSetView.contains(4), isFalse);
  });

  test("Non-mutable operations | ModifiableSetView.iterator getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iSet = baseSet.lock;
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView(iSet);
    final Iterator<int> iterator = modifiableSetView.iterator;

    int count = 0;
    final Set<int> result = {};
    while (iterator.moveNext()) {
      count++;
      result.add(iterator.current);
    }
    expect(count, baseSet.length);
    expect(result, baseSet);
  });

  test("Non-mutable operations | ModifiableSetView.toSet()", () {
    const Set<int> baseSet = {1, 2, 3};
    final ISet<int> iSet = baseSet.lock;
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView(iSet);
    expect(modifiableSetView.toSet(), baseSet);
  });

  test("Non-mutable operations | ModifiableSetView.lookup()", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView({1, 2, 3}.lock);
    expect(modifiableSetView.lookup(1), 1);
    expect(modifiableSetView.lookup(2), 2);
    expect(modifiableSetView.lookup(3), 3);
    expect(modifiableSetView.lookup(4), null);
  });

  test("Mutations are allowed | ModifiableSetView.add method", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView({1, 2, 3}.lock);
    expect(modifiableSetView.add(3), isFalse);
    expect(modifiableSetView.add(4), isTrue);
    expect(modifiableSetView.length, 4);
    expect(modifiableSetView.contains(4), isTrue);
  });

  test("Mutations are allowed | ModifiableSetView.remove method", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView({1, 2, 3}.lock);
    expect(modifiableSetView.remove(4), isFalse);
    expect(modifiableSetView.remove(3), isTrue);
    expect(modifiableSetView.length, 2);
    expect(modifiableSetView.contains(3), isFalse);
  });
}
