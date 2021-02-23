import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    expect(<int>{}.lock, allOf(isA<ISet<int>>(), <int>{}));
    expect(<int>{1}.lock, allOf(isA<ISet<int>>(), {1}));
    expect(<int?>{null}.lock, isA<ISet<int?>>());
    expect(<int?>{null}.lock, {null});
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

  test("diffAndIntersect", () {
    Set<int> set = {1, 2, 3, 4};

    // 1.1) Diff This Minus Other

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: true,
          diffOtherMinusThis: false,
          intersectOtherWithThis: false,
          intersectThisWithOther: false,
        ),
        IListOf4([1, 2], null, null, null));

    // 1.2) Diff Other Minus This

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: true,
          intersectOtherWithThis: false,
          intersectThisWithOther: false,
        ),
        IListOf4(null, [5], null, null));

    // 1.3) Intersect This With Other

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: false,
          intersectOtherWithThis: true,
          intersectThisWithOther: false,
        ),
        IListOf4(null, null, [3, 4], null));

    // 1.4) Intersect Other With This

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: false,
          intersectOtherWithThis: false,
          intersectThisWithOther: true,
        ),
        IListOf4(null, null, null, [4, 3]));

    // 2) Complete Example

    expect(set.diffAndIntersect({5, 4, 3}), IListOf4([1, 2], [5], [3, 4], [4, 3]));
  });

  //////////////////////////////////////////////////////////////////////////////
}
