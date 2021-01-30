import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    expect(<int>{}.lock, allOf(isA<ISet<int>>(), <int>{}));
    expect(<int>{1}.lock, allOf(isA<ISet<int>>(), {1}));
    expect(<int>{null}.lock, allOf(isA<ISet<int>>(), {null}));
    expect({1, 2, 3}.lock, allOf(isA<ISet<int>>(), {1, 2, 3}));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lockUnsafe", () {
    final Set<int> set = {1, 2, 3};
    final ISet<int> iset = set.lockUnsafe;

    expect(set, iset);

    set.add(4);

    expect(set, iset);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toggle", () {
    // 1) Toggling an existing element
    Set<int> iset = {1, 2, 3};
    expect(iset.contains(3), isTrue);

    iset.toggle(3);
    expect(iset.contains(3), isFalse);

    iset.toggle(3);
    expect(iset.contains(3), isTrue);

    // 2) Toggling an nonexistent element
    iset = {1, 2, 3};
    expect(iset.contains(4), isFalse);

    iset.toggle(4);
    expect(iset.contains(4), isTrue);

    iset.toggle(4);
    expect(iset.contains(4), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////
}
