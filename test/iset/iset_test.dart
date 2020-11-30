import "dart:collection";

import "package:flutter_test/flutter_test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////
  test("Runtime Type", () {
    expect(ISet(), isA<ISet>());
    expect(ISet({}), isA<ISet>());
    expect(ISet<String>({}), isA<ISet<String>>());
    expect(ISet([1]), isA<ISet<int>>());
    expect(ISet.empty<int>(), isA<ISet<int>>());
    expect(<int>{}.lock, isA<ISet>());
  });

  test("Emptiness Properties", () {
    expect(ISet().isEmpty, isTrue);
    expect(ISet({}).isEmpty, isTrue);
    expect(ISet<String>({}).isEmpty, isTrue);
    expect(ISet([1]).isEmpty, isFalse);
    expect(ISet.empty<int>().isEmpty, isTrue);
    expect(<int>{}.lock.isEmpty, isTrue);

    expect(ISet().isNotEmpty, isFalse);
    expect(ISet({}).isNotEmpty, isFalse);
    expect(ISet<String>({}).isNotEmpty, isFalse);
    expect(ISet([1]).isNotEmpty, isTrue);
    expect(ISet.empty<int>().isNotEmpty, isFalse);
    expect(<int>{}.lock.isNotEmpty, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Ensuring Immutability | ISet.add() | "
      "Changing the passed mutable list doesn't change the IList", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, original);

    original.add(3);
    original.add(4);

    expect(original, <int>{1, 2, 3, 4});
    expect(iset, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.add() | "
      "Changing the ISet also doesn't change the original set", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, original);

    final ISet<int> iSetNew = iset.add(3);

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3});
  });

  test(
      "Ensuring Immutability | ISet.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, original);

    int willChange = 4;
    final ISet<int> iSetNew = iset.add(willChange);

    willChange = 5;

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(willChange, 5);
    expect(iSetNew, <int>{1, 2, 4});
  });

  test(
      "Ensuring Immutability | ISet.addAll() | "
      "Changing the passed mutable list doesn't change the ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, <int>{1, 2});

    original.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2, 3, 4});
    expect(iset, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.addAll() | "
      "Changing the passed immutable set doesn't change the ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, <int>{1, 2});

    final ISet<int> iSetNew = iset.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3, 4});
  });

  test(
      "Ensuring Immutability | ISet.addAll() | "
      "If the items being passed are from a variable, "
      "it shouldn't have a pointer to the variable", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet1 = original.lock;
    final ISet<int> iSet2 = original.lock;

    expect(iSet1, original);
    expect(iSet2, original);

    final ISet<int> iSetNew = iSet1.addAll(iSet2.addAll({3, 4}));
    original.add(3);

    expect(original, <int>{1, 2, 3});
    expect(iSet1, <int>{1, 2});
    expect(iSet2, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3, 4});
  });

  test(
      "Ensuring Immutability | ISet.remove() | "
      "Changing the passed mutable set doesn't change the ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, {1, 2});

    original.remove(2);

    expect(original, <int>{1});
    expect(iset, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.remove() | "
      "Removing from the original ISet doesn't change it", () {
    final Set<int> original = {1, 2};
    final ISet<int> iset = original.lock;

    expect(iset, <int>{1, 2});

    final ISet<int> iSetNew = iset.remove(1);

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{2});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Equals Operator | " "ISet with identity-equals compares the set instance, not the items.",
      () {
    final ISet<int> mySet = ISet({1, 2}).withIdentityEquals;
    expect(mySet == mySet, isTrue);
    expect(mySet == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(mySet == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(mySet == {1, 2}.lock, isFalse);
    expect(mySet == ISet({1, 2, 3}).withIdentityEquals, isFalse);
  });

  test(
      "Equals Operator | "
      "ISet with deep-equals compares the items, not necessarily the list instance", () {
    final ISet<int> mySet = ISet({1, 2});
    expect(mySet == mySet, isTrue);
    expect(mySet == ISet({1, 2}), isTrue);
    expect(mySet == ISet({2, 1}), isTrue);
    expect(mySet == {1, 2}.lock.withDeepEquals, isTrue);
    expect(mySet == ISet({1, 2, 3}), isFalse);
  });

  test(
      "Equals Operator | "
      "ISet with deep-equals is always different from iset with identity-equals", () {
    expect(ISet({1, 2}).withDeepEquals == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(ISet({1, 2}).withIdentityEquals == ISet({1, 2}).withDeepEquals, isFalse);
    expect(ISet({1, 2}).withDeepEquals == ISet({1, 2}), isTrue);
    expect(ISet({1, 2}) == ISet({1, 2}).withDeepEquals, isTrue);
  });

  test("ISet.isIdentityEquals and ISet.isDeepEquals properties", () {
    final ISet<int> iSet1 = ISet({1, 2}), iSet2 = ISet({1, 2}).withIdentityEquals;

    expect(iSet1.isIdentityEquals, isFalse);
    expect(iSet1.isDeepEquals, isTrue);
    expect(iSet2.isIdentityEquals, isTrue);
    expect(iSet2.isDeepEquals, isFalse);
  });

  test("ISet.same()", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1.same(iSet1), isTrue);
    expect(iSet1.same(ISet({1, 2})), isFalse);
    expect(iSet1.same(ISet({1})), isFalse);
    expect(iSet1.same(ISet({2, 1})), isFalse);
    expect(iSet1.same(ISet({1, 2}).withIdentityEquals), isFalse);
    expect(iSet1.same(iSet1.add(2)), isTrue);
  });

  test("ISet.equalItemsAndConfig method", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1.equalItemsAndConfig(iSet1), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1, 2})), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1})), isFalse);
    expect(iSet1.equalItemsAndConfig(ISet({2, 1})), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1, 2}).withIdentityEquals), isFalse);
    expect(iSet1.equalItemsAndConfig(iSet1.remove(3)), isTrue);
  });

  test("ISet.== operator", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1 == iSet1, isTrue);
    expect(iSet1 == ISet({1, 2}), isTrue);
    expect(iSet1 == ISet({1}), isFalse);
    expect(iSet1 == ISet({2, 1}), isTrue);
    expect(iSet1 == ISet({1, 2}).withIdentityEquals, isFalse);
  });
  test("ISet.equalItems() | Null", () => expect(ISet({1, 2}).equalItems(null), isFalse));

  test("ISet.equalItems() | Identity", () => expect(ISet({1, 2}).equalItems([1, 2]), isTrue));

  test("ISet.equalItems() | The order doesn't matter",
      () => expect(ISet({1, 2}).equalItems([2, 1]), isTrue));

  test("ISet.equalItems() | Different items yield false",
      () => expect(ISet({1, 2}).equalItems([1]), isFalse));

  test("ISet.hashCode() | deepEquals vs deepEquals", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1 == ISet({1, 2}), isTrue);
    expect(iSet1 == ISet({1, 2, 3}), isFalse);
    expect(iSet1 == ISet({2, 1}), isTrue);
    expect(iSet1.hashCode, ISet({1, 2}).hashCode);
    expect(iSet1.hashCode, isNot(ISet({1, 2, 3}).hashCode));
    expect(iSet1.hashCode, ISet({2, 1}).hashCode);
  });

  test("ISet.hashCode() | identityEquals vs identityEquals", () {
    final ISet<int> iSet1WithIdentity = ISet({1, 2}).withIdentityEquals;
    expect(iSet1WithIdentity == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity == ISet({1, 2, 3}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity.hashCode, isNot(ISet({1, 2}).withIdentityEquals.hashCode));
    expect(iSet1WithIdentity.hashCode, isNot(ISet({1, 2, 3}).withIdentityEquals.hashCode));
    expect(iSet1WithIdentity.hashCode, isNot(ISet({2, 1}).withIdentityEquals.hashCode));
  });

  test("ISet.hashCode() | deepEquals vs identityEquals", () {
    final ISet<int> iSet1 = ISet({1, 2});
    final ISet<int> iSet1WithIdentity = iSet1.withIdentityEquals;
    expect(iSet1 == iSet1WithIdentity, isFalse);
    expect(ISet({1, 2}) == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(ISet({1, 2, 3}) == ISet({1, 2, 3}).withIdentityEquals, isFalse);
    expect(ISet({2, 1}) == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(iSet1.hashCode, isNot(iSet1WithIdentity.hashCode));
    expect(ISet({1, 2}).hashCode, isNot(ISet({1, 2}).withIdentityEquals.hashCode));
    expect(ISet({1, 2, 3}).hashCode, isNot(ISet({1, 2, 3}).withIdentityEquals.hashCode));
    expect(ISet({2, 1}).hashCode, isNot(ISet({2, 1}).withIdentityEquals.hashCode));
  });

  test("ISet.config()", () {
    final ISet<int> iset = ISet({1, 2});

    expect(iset.isDeepEquals, isTrue);
    expect(iset.config.sort, isTrue);

    final ISet<int> iSetWithCompare = iset.withConfig(
      iset.config.copyWith(sort: false),
    );

    expect(iSetWithCompare.isDeepEquals, isTrue);
    expect(iSetWithCompare.config.sort, isFalse);
  });

  test("ISet.withConfig() factory | different configs", () {
    final ISet<int> iSet1 = ISet.withConfig({1, 2, 3}, ConfigSet(isDeepEquals: false));
    final ISet<int> iSet2 = ISet.withConfig({}, ConfigSet(isDeepEquals: false));

    expect(iSet1, {1, 2, 3});
    expect(iSet1.isDeepEquals, isFalse);

    expect(iSet2, <int>{});
    expect(iSet2.isDeepEquals, isFalse);
  });

  test("ISet.withConfig() | Assertion error",
      () => expect(() => {1, 2, 3}.lock.withConfig(null), throwsAssertionError));

  test("ISet.withConfigFrom()", () {
    final ISet<int> iset = {1, 2, 3}.lock;
    final ISet<int> iSetWithIdentityEquals =
        ISet.withConfig({1, 2, 3}, const ConfigSet(isDeepEquals: false));

    expect(
        iset.withConfigFrom(iSetWithIdentityEquals).config, const ConfigSet(isDeepEquals: false));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("From an empty set", () {
    final ISet iset = <int>{}.lock;

    expect(iset, isA<ISet>());
    expect(iset.isEmpty, isTrue);
    expect(iset.isNotEmpty, isFalse);
  });

  test("From a set with one int item", () {
    final ISet iset = {1}.lock;

    expect(iset, isA<ISet<int>>());
    expect(iset.isEmpty, isFalse);
    expect(iset.isNotEmpty, isTrue);
  });

  test("From a set with one null string", () {
    final String text = null;
    final ISet<String> typedSet = {text}.lock;

    expect(typedSet, isA<ISet<String>>());
  });

  test("From an empty set typed with String", () {
    final typedSet = <String>{}.lock;

    expect(typedSet, isA<ISet<String>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Creating native mutable sets from immutable sets | " "From the default factory constructor",
      () {
    const Set<int> exampleSet = {1, 2, 3};
    final ISet<int> iset = ISet(exampleSet);

    expect(iset.unlock, exampleSet);
    expect(identical(iset.unlock, exampleSet), isFalse);
  });

  test("Creating native mutable sets from immutable sets | " "From lock", () {
    const Set<int> exampleSet = {1, 2, 3};
    final ISet<int> iset = exampleSet.lock;

    expect(iset.unlock, exampleSet);
    expect(identical(iset.unlock, exampleSet), isFalse);
  });

  test(
      "Creating native mutable sets from immutable sets | ISet.unsafe constructor | "
      "Normal usage", () {
    final Set<int> set = {1, 2, 3};
    final ISet<int> iset = ISet.unsafe(set, config: ConfigSet());

    expect(set, {1, 2, 3});
    expect(iset, {1, 2, 3});

    set.add(4);

    expect(set, {1, 2, 3, 4});
    expect(iset, {1, 2, 3, 4});
  });

  test(
      "Creating native mutable sets from immutable sets | ISet.unsafe constructor | "
      "Disallowing it", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    final Set<int> set = {1, 2, 3};

    expect(() => ISet.unsafe(set, config: ConfigSet()), throwsUnsupportedError);
  });

  test("ISet.flush()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6}).add(7).addAll({}).addAll({8, 9});

    expect(iset.isFlushed, isFalse);

    iset.flush;

    expect(iset.isFlushed, isTrue);
    expect(iset.unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet.add()", () {
    final ISet<int> baseSet = ISet<int>([1]);
    ISet<int> iset = baseSet.add(2);

    expect(iset.unlock, <int>{1, 2});
  });

  test("ISet.add() with a repeated element", () {
    final ISet<int> baseSet = ISet<int>([1]);
    ISet<int> iset = baseSet.add(1);

    expect(iset.unlock, <int>{1});
  });

  test("ISet.add() and ISet.addAll()", () {
    final ISet<int> iSet1 = {1, 2, 3}.lock;
    final ISet<int> iSet2 = iSet1.add(4);
    final ISet<int> iSet3 = iSet2.addAll({5, 6});

    expect(iSet1.unlock, {1, 2, 3});
    expect(iSet2.unlock, {1, 2, 3, 4});
    expect(iSet3.unlock, {1, 2, 3, 4, 5, 6});

    // Methods are chainable.
    expect(iSet1.add(10).addAll({20, 30}).unlock, {1, 2, 3, 10, 20, 30});
  });

  test("Adding repeated elements | Adding a repeated element", () {
    final ISet<int> iset = ISet<int>({1, 2, 3}).add(1);

    expect(iset.length, 3);
    expect(iset.unlock, {1, 2, 3});
  });

  test("Adding repeated elements | Adding multiple repeated elements", () {
    final ISet<int> iset = ISet<int>({1, 2, 3}).addAll({1, 2});

    expect(iset.length, 3);
    expect(iset.unlock, {1, 2, 3});
  });

  test("Adding repeated elements | Adding some repeated elements and another, new one", () {
    final ISet<int> iset = ISet<int>({1, 2, 3}).addAll({1, 2, 5, 7});

    expect(iset.length, 5);
    expect(iset.unlock, {1, 2, 3, 5, 7});
  });

  test("Adding repeated elements | Adding some repeated elements and new ones", () {
    final ISet<int> iset = ISet<int>({1, 2, 3}).addAll({1, 2, 5, 7, 11, 13});

    expect(iset.length, 7);
    expect(iset.unlock, {1, 2, 3, 5, 7, 11, 13});
  });

  test("ISet.remove()", () {
    final ISet<int> iSet1 = {1, 2, 3}.lock;

    final ISet<int> iSet2 = iSet1.remove(2);
    expect(iSet2.unlock, {1, 3});

    final ISet<int> iSet3 = iSet2.remove(5);
    expect(iSet3.unlock, {1, 3});

    final ISet<int> iSet4 = iSet3.remove(1);
    expect(iSet4.unlock, {3});

    final ISet<int> iSet5 = iSet4.remove(3);
    expect(iSet5.unlock, <int>{});

    final ISet<int> iSet6 = iSet5.remove(7);
    expect(iSet6.unlock, <int>{});

    expect(identical(iSet1, iSet2), false);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet.any()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.any((int v) => v == 4), isTrue);
    expect(iset.any((int v) => v == 100), isFalse);
  });

  test("ISet.cast()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.cast<num>(), isA<ISet<num>>());
  });

  test("ISet.contains()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.contains(2), isTrue);
    expect(iset.contains(4), isTrue);
    expect(iset.contains(5), isTrue);
    expect(iset.contains(100), isFalse);
  });

  test("ISet.every()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.every((int v) => v > 0), isTrue);
    expect(iset.every((int v) => v < 0), isFalse);
    expect(iset.every((int v) => v != 4), isFalse);
  });

  test("ISet.expand()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.expand((int v) => {v, v}),
        // ignore: equal_elements_in_set
        {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6});
    expect(iset.expand((int v) => <int>{}), <int>{});
  });

  test("ISet.length", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.length, 6);
  });

  test("ISet.length when the set is empty", () {
    final ISet<int> iset = ISet.empty();

    expect(iset.length, 0);
    expect(iset.isEmpty, isTrue);
  });

  test("ISet.first", () {
    expect({1, 2, 3, 4, 5, 6}.lock.first, 1);
    expect({3, 6, 4, 1, 2, 5}.lock.first, 1);
  });

  test("ISet.first | without sorting", () {
    final ISet<int> iset = {100, 2, 3}.lock.add(1).add(5).withConfig(ConfigSet(sort: false));
    expect(iset.first, 100);
  });

  test("ISet.last method", () {
    expect({1, 2, 3, 4, 5, 6}.lock.last, 6);
    expect({3, 6, 4, 1, 2, 5}.lock.last, 6);
  });

  test("ISet.last | without sorting", () {
    final ISet<int> iset = {100, 2, 3}.lock.add(1).add(5).withConfig(ConfigSet(sort: false));
    expect(iset.last, 5);
  });

  test("ISet.firstOrNull", () {
    expect(<int>{}.lock.firstOrNull, isNull);
    expect({1, 2, 3}.lock.firstOrNull, 1);
  });

  test("ISet.lastOrNull", () {
    expect(<int>{}.lock.lastOrNull, isNull);
    expect({1, 2, 3}.lock.lastOrNull, 3);
  });

  test("ISet.singleOrNull", () {
    expect(<int>{}.lock.singleOrNull, isNull);
    expect(<int>{1}.lock.singleOrNull, 1);
    expect({1, 2, 3}.lock.singleOrNull, isNull);
  });

  test("ISet.firstOr()", () {
    expect(<int>{}.lock.firstOr(10), 10);
    expect(<int>{1, 2, 3}.lock.firstOr(10), 1);
  });

  test("ISet.lastOr()", () {
    expect(<int>{}.lock.lastOr(10), 10);
    expect(<int>{1, 2, 3}.lock.lastOr(10), 3);
  });

  test("ISet.singleOr()", () {
    expect(<int>{}.lock.singleOr(10), 10);
    expect(<int>{1}.lock.singleOr(10), 1);
    expect(<int>{1, 2, 3}.lock.singleOr(10), 10);
  });

  test("ISet.single() | State exception", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.single, throwsStateError);
  });

  test("ISet.single() | Access", () => expect({10}.lock.single, 10));

  test("ISet.firstWhere()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(iset.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(iset.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(iset.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("ISet.fold()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("ISet.followedBy()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.followedBy({7, 8}).unlock, {1, 2, 3, 4, 5, 6, 7, 8});
    expect(iset.followedBy(<int>{}.lock.add(7).addAll({8, 9})).unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  test("ISet.forEach()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    int result = 100;
    iset.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("ISet.join()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.join(","), "1,2,3,4,5,6");
    expect(<int>{}.lock.join(","), "");
  });

  test("ISet.lastWhere()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(iset.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(iset.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(iset.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(iset.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(iset.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("ISet.map()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect({1, 2, 3}.lock.map((int v) => v + 1).unlock, {2, 3, 4});
    expect(iset.map((int v) => v + 1).unlock, {2, 3, 4, 5, 6, 7});
  });

  test("ISet.reduce() | Regular usage", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.reduce((int p, int e) => p * (1 + e)), 2520);
    expect({5}.lock.reduce((int p, int e) => p * (1 + e)), 5);
  });

  test(
      "ISet.reduce() | State exception",
      () => expect(
          () => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError));

  test("ISet.singleWhere() | Regular usage", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(iset.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  test("ISet.singleWhere() | State exception", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("ISet.skip()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.skip(1).unlock, {2, 3, 4, 5, 6});
    expect(iset.skip(3).unlock, {4, 5, 6});
    expect(iset.skip(5).unlock, {6});
    expect(iset.skip(10).unlock, <int>{});
  });

  test("ISet.skipWhile()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.skipWhile((int v) => v < 3).unlock, {3, 4, 5, 6});
    expect(iset.skipWhile((int v) => v < 5).unlock, {5, 6});
    expect(iset.skipWhile((int v) => v < 6).unlock, {6});
    expect(iset.skipWhile((int v) => v < 100).unlock, <int>{});
  });

  test("ISet.take()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.take(0).unlock, <int>{});
    expect(iset.take(1).unlock, {1});
    expect(iset.take(3).unlock, {1, 2, 3});
    expect(iset.take(5).unlock, {1, 2, 3, 4, 5});
    expect(iset.take(10).unlock, {1, 2, 3, 4, 5, 6});
  });

  test("ISet.takeWhile()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.takeWhile((int v) => v < 3).unlock, {1, 2});
    expect(iset.takeWhile((int v) => v < 5).unlock, {1, 2, 3, 4});
    expect(iset.takeWhile((int v) => v < 6).unlock, {1, 2, 3, 4, 5});
    expect(iset.takeWhile((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
  });

  test("ISet.toList() | Regular usage", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(iset.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test(
      "ISet.toList() | with compare",
      () => expect({1, 2, 3}.lock.add(10).add(5).toList(compare: (int a, int b) => -a.compareTo(b)),
          [10, 5, 3, 2, 1]));

  test("ISet.toList() | Unsupported exception", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.toList(growable: false)..add(7), throwsUnsupportedError);
  });

  test("ISet.toIList()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toIList(), IList([1, 2, 3, 4, 5, 6]));
  });

  test("ISet.toSet()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(iset.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("ISet.toSet() | with compare", () {
    final Set<int> set = {1, 2, 3, 10, 5}.lock.toSet(compare: (int a, int b) => -a.compareTo(b));
    expect(set, allOf(isA<LinkedHashSet>(), {1, 2, 3, 5, 10}));
    expect(set.toList(), [10, 5, 3, 2, 1]);
  });

  test("ISet.where()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.where((int v) => v < 0).unlock, <int>{});
    expect(iset.where((int v) => v < 3).unlock, {1, 2});
    expect(iset.where((int v) => v < 5).unlock, {1, 2, 3, 4});
    expect(iset.where((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
  });

  test("ISet.whereType()", () => expect((<num>{1, 2, 1.5}.lock.whereType<double>()).unlock, {1.5}));

  test("ISet.toString()", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toString(), "{1, 2, 3, 4, 5, 6}");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet.iterator getter", () {
    ISet<int> iset = {2, 5, 3, 7, 9, 6, 1}.lock;
    expect(iset.config.sort, isTrue);

    // The regular iterator is SORTED.
    expect(iset.iterator.toList(), [1, 2, 3, 5, 6, 7, 9]);

    // The for loop uses the SORTED iterator.
    var result = [];
    for (int value in iset) result.add(value);
    expect(iset.iterator.toList(), [1, 2, 3, 5, 6, 7, 9]);

    // You can also use a fast iterator which will NOT sort the result.
    expect(iset.fastIterator.toList(), [2, 5, 3, 7, 9, 6, 1]);

    // But you can configure the set NOT to sort the iterator.
    iset = iset.withConfig(const ConfigSet(sort: false));
    expect(iset.config.sort, isFalse);
    expect(iset.iterator.toList(), [2, 5, 3, 7, 9, 6, 1]);
    result = [];
    for (int value in iset) result.add(value);
    expect(iset.iterator.toList(), [2, 5, 3, 7, 9, 6, 1]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet of MapEntry gets special treatment | Equals", () {
    final ISet<MapEntry<String, int>> iSet1 = ISet([MapEntry("a", 1)]).withDeepEquals,
        iSet2 = ISet([MapEntry("a", 1)]).withDeepEquals;

    expect(iSet1, iSet2);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet.toggle() | Toggling an existing element", () {
    ISet<int> iset = {1, 2, 3}.lock;

    expect(iset.contains(3), isTrue);

    iset = iset.toggle(3);

    expect(iset.contains(3), isFalse);

    iset = iset.toggle(3);

    expect(iset.contains(3), isTrue);
  });

  test("ISet.toggle() | Toggling a nonexistent element", () {
    ISet<int> iset = {1, 2, 3}.lock;

    expect(iset.contains(4), isFalse);

    iset = iset.toggle(4);

    expect(iset.contains(4), isTrue);

    iset = iset.toggle(4);

    expect(iset.contains(4), isFalse);
  });

  test("ISet.elementAt()", () {
    final ISet<int> iset = {1, 2, 3}.lock;
    expect(() => iset.elementAt(0), throwsUnsupportedError);
  });

  test("ISet.clear()", () {
    final ISet<int> iset = ISet.withConfig({1, 2, 3}, ConfigSet(isDeepEquals: false));

    final ISet<int> iSetCleared = iset.clear();

    expect(iSetCleared, allOf(isA<ISet<int>>(), <int>{}));
    expect(iSetCleared.config.isDeepEquals, isFalse);
  });

  test("ISet.containsAll()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    // TODO: Marcelo, o argumento desses métodos não deveria ser `Iterable` ou `ISet`?
    expect(iSet1.containsAll([2, 2, 3]), isTrue);
    expect(iSet1.containsAll({1, 2, 3, 4}), isTrue);
    expect(iSet1.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("ISet.difference()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.difference({1, 2, 5}), {3, 4});
    expect(iSet1.difference({1, 2, 3, 4}), <int>{});
  });

  test("ISet.intersection()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.intersection({1, 2, 5}), {1, 2});
    expect(iSet1.intersection({10, 20, 50}), <int>{});
  });

  test("ISet.union()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.union({1}), {1, 2, 3, 4});
    expect(iSet1.union({1, 2, 5}), {1, 2, 3, 4, 5});
  });

  test("ISet.lookup()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.lookup(1), 1);
    expect(iSet1.lookup(10), isNull);
  });

  test("ISet.removeAll()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.removeAll({}), {1, 2, 3, 4});
    expect(iSet1.removeAll({2, 3}), {1, 4});
  });

  test("ISet.removeWhere()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.removeWhere((int element) => element > 10), {1, 2, 3, 4});
    expect(iSet1.removeWhere((int element) => element > 2), {1, 2});
  });

  test("ISet.retainAll()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.retainAll({}), <int>{});
    expect(iSet1.retainAll({2, 3}), {2, 3});
  });

  test("ISet.retainWhere()", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.retainWhere((int element) => element > 10), <int>{});
    expect(iSet1.retainWhere((int element) => element < 2), <int>{1});
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "ISet sort. "
      "Affects join, iterator, toList, toIList, and toSet.", () {
    var originalSet = {2, 4, 1, 9, 3};

    /// Sort: "1,2,3,4,9"
    var iset = originalSet.lock.withConfig(ConfigSet(sort: true));
    var result1 = iset.join(",");
    var result2 = iset.iterator.toIterable().join(",");
    var result3 = iset.toList().join(",");
    var result4 = iset.toIList().join(",");
    var result5 = iset.toSet().join(",");
    expect(iset.config.sort, isTrue);
    expect(result1, "1,2,3,4,9");
    expect(result2, "1,2,3,4,9");
    expect(result3, "1,2,3,4,9");
    expect(result4, "1,2,3,4,9");
    expect(result5, "1,2,3,4,9");

    /// Does not sort: "2,4,1,9,3"
    iset = originalSet.lock.withConfig(ConfigSet(sort: false));
    result1 = iset.join(",");
    result2 = iset.iterator.toIterable().join(",");
    result3 = iset.toList().join(",");
    result4 = iset.toIList().join(",");
    result5 = iset.toSet().join(",");
    expect(iset.config.sort, isFalse);
    expect(result1, "2,4,1,9,3");
    expect(result2, "2,4,1,9,3");
    expect(result3, "2,4,1,9,3");
    expect(result4, "2,4,1,9,3");
    expect(iset.toSet(), originalSet);
  });

  test("ISet.flushFactor", () => expect(ISet.flushFactor, 20));

  test("ISet.flushFactor setter", () {
    ISet.flushFactor = 200;
    expect(ISet.flushFactor, 200);
  });

  test("ISet.flushFactor setter | can't be smaller than or equal to 0", () {
    expect(() => ISet.flushFactor = 0, throwsStateError);
    expect(() => ISet.flushFactor = -100, throwsStateError);
  });

  test("ISet.asyncAutoFlush", () => expect(ISet.asyncAutoflush, isTrue));

  test("lockConfig()", () {
    ImmutableCollection.lockConfig();

    expect(() => ISet.flushFactor = 1000, throwsStateError);
    expect(() => ISet.asyncAutoflush = false, throwsStateError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ISet.unlockSorted", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(10).add(5);

    expect(iset.unlockSorted, allOf(isA<LinkedHashSet>(), {1, 2, 3, 5, 10}));
  });

  test(
      "ISet.unlockView",
      () => expect({1, 2, 3}.lock.unlockView,
          allOf(isA<UnmodifiableSetView<int>>(), isA<Set<int>>(), {1, 2, 3})));

  test(
      "ISet.unlockLazy",
      () => expect({1, 2, 3}.lock.unlockLazy,
          allOf(isA<ModifiableSetView<int>>(), isA<Set<int>>(), {1, 2, 3})));

  test("ISet.+()", () => expect({1, 2, 3}.lock + [1, 2, 4], {1, 2, 3, 4}));
}
