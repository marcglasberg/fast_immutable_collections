// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("lock", () {
    expect(<int>{}.lock, allOf(isA<ISet<int>>(), <int>{}));
    expect(<int>{1}.lock, allOf(isA<ISet<int>>(), {1}));
    expect(<int?>{null}.lock, isA<ISet<int?>>());
    expect(<int?>{null}.lock, {null});
    expect({1, 2, 3}.lock, allOf(isA<ISet<int>>(), {1, 2, 3}));
  });

  test("lockUnsafe", () {
    final Set<int> set = {1, 2, 3};
    final ISet<int> iset = set.lockUnsafe;

    expect(set, iset);

    set.add(4);

    expect(set, iset);
  });

  test("toggle", () {
    // 1) Toggling an existing element
    Set<int> iset = {1, 2, 3};
    expect(iset.contains(3), isTrue);

    expect(iset.toggle(3), isFalse);
    expect(iset.contains(3), isFalse);

    expect(iset.toggle(3), isTrue);
    expect(iset.contains(3), isTrue);

    // 2) Toggling an nonexistent element
    iset = {1, 2, 3};
    expect(iset.contains(4), isFalse);

    expect(iset.toggle(4), isTrue);
    expect(iset.contains(4), isTrue);

    expect(iset.toggle(4), isFalse);
    expect(iset.contains(4), isFalse);
  });

  test("removeNulls", () {
    expect(({1, 2, null, 3, 4}..removeNulls()), {1, 2, 3, 4});
    // ignore: equal_elements_in_set
    expect(({1, 2, null, 3, 2, 4}..removeNulls()), {1, 2, 3, 2, 4});
    expect(({null}..removeNulls()), isEmpty);
    expect(({null, 1}..removeNulls()), {1});
  });

  test("diffAndIntersect", () {
    Set<int> set = {1, 2, 3, 4};

    // 1.1) Diff This Minus Other

    expect(
        set.diffAndIntersect(
          <int>{5, 4, 3},
          diffThisMinusOther: true,
          diffOtherMinusThis: false,
          intersectThisWithOther: false,
          intersectOtherWithThis: false,
        ),
        DiffAndIntersectResult<int, int>(
          diffThisMinusOther: [1, 2],
          diffOtherMinusThis: null,
          intersectThisWithOther: null,
          intersectOtherWithThis: null,
        ));

    // 1.2) Diff Other Minus This

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: true,
          intersectThisWithOther: false,
          intersectOtherWithThis: false,
        ),
        DiffAndIntersectResult<int, int>(
          diffThisMinusOther: null,
          diffOtherMinusThis: [5],
          intersectThisWithOther: null,
          intersectOtherWithThis: null,
        ));

    // 1.3) Intersect This With Other

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: false,
          intersectThisWithOther: true,
          intersectOtherWithThis: false,
        ),
        DiffAndIntersectResult<int, int>(
          diffThisMinusOther: null,
          diffOtherMinusThis: null,
          intersectThisWithOther: [3, 4],
          intersectOtherWithThis: null,
        ));

    // 1.4) Intersect Other With This

    expect(
        set.diffAndIntersect(
          {5, 4, 3},
          diffThisMinusOther: false,
          diffOtherMinusThis: false,
          intersectThisWithOther: false,
          intersectOtherWithThis: true,
        ),
        DiffAndIntersectResult<int, int>(
          diffThisMinusOther: null,
          diffOtherMinusThis: null,
          intersectThisWithOther: null,
          intersectOtherWithThis: [4, 3],
        ));

    // 2) Complete Example

    expect(
        set.diffAndIntersect({5, 4, 3}),
        DiffAndIntersectResult<int, int>(
          diffThisMinusOther: [1, 2],
          diffOtherMinusThis: [5],
          intersectThisWithOther: [3, 4],
          intersectOtherWithThis: [4, 3],
        ));
  });

  test("DiffAndIntersectResult.toString", () {
    Set<int> set = {1, 2, 3, 4};

    expect(
        set.diffAndIntersect({5, 4, 3}).toString(),
        "DiffAndIntersectResult{\n"
        "diffThisMinusOther: [1, 2],\n"
        "diffOtherMinusThis: [5],\n"
        "intersectThisWithOther: [3, 4],\n"
        "intersectOtherWithThis: [4, 3]\n"
        "}");
  });

  test("DiffAndIntersectResult.==", () {
    Set<int> set = {1, 2, 3, 4};
    DiffAndIntersectResult setDiffAndIntersect = set.diffAndIntersect({5, 4, 3});

    var otherIntersect = <int>{1, 2, 3, 4}.diffAndIntersect({5, 4, 3});

    expect(setDiffAndIntersect == setDiffAndIntersect, isTrue);
    expect(setDiffAndIntersect.diffThisMinusOther, otherIntersect.diffThisMinusOther);
    expect(setDiffAndIntersect.diffOtherMinusThis, otherIntersect.diffOtherMinusThis);
    expect(setDiffAndIntersect.intersectThisWithOther, otherIntersect.intersectThisWithOther);
    expect(setDiffAndIntersect.intersectOtherWithThis, otherIntersect.intersectOtherWithThis);
    expect(setDiffAndIntersect == otherIntersect, isTrue);

    expect(setDiffAndIntersect == <int>{1, 2, 3, 4}.diffAndIntersect({10, 100}), isFalse);
  });

  test("DiffAndIntersectResult.hashCode", () {
    Set<int> set = {1, 2, 3, 4};
    DiffAndIntersectResult setDiffAndIntersect = set.diffAndIntersect({5, 4, 3});

    var otherIntersect = <int>{1, 2, 3, 4}.diffAndIntersect({10, 100});
    expect(setDiffAndIntersect.hashCode, isNot(otherIntersect.hashCode));

    expect(setDiffAndIntersect.hashCode, setDiffAndIntersect.hashCode);
    expect(setDiffAndIntersect.hashCode, <int>{1, 2, 3, 4}.diffAndIntersect({5, 4, 3}).hashCode);
  });
}
