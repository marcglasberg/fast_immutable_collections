import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////
  test("Runtime Type", () {
    expect(ISet(), isA<ISet>());
    expect(ISet({}), isA<ISet>());
    expect(ISet<String>({}), isA<ISet<String>>());
    expect(ISet([1]), isA<ISet<int>>());
    expect(ISet.empty<int>(), isA<ISet<int>>());
    expect(<int>{}.lock, isA<ISet>());
  });

  group("Creating immutable sets |", () {
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
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test(
      "Ensuring Immutability | ISet.add() | "
      "Changing the passed mutable list doesn't change the IList", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, original);

    original.add(3);
    original.add(4);

    expect(original, <int>{1, 2, 3, 4});
    expect(iSet, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.add() | "
      "Changing the ISet also doesn't change the original set", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, original);

    final ISet<int> iSetNew = iSet.add(3);

    expect(original, <int>{1, 2});
    expect(iSet, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3});
  });

  test(
      "Ensuring Immutability | ISet.add() | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, original);

    int willChange = 4;
    final ISet<int> iSetNew = iSet.add(willChange);

    willChange = 5;

    expect(original, <int>{1, 2});
    expect(iSet, <int>{1, 2});
    expect(willChange, 5);
    expect(iSetNew, <int>{1, 2, 4});
  });

  test(
      "Ensuring Immutability | ISet.addAll() | "
      "Changing the passed mutable list doesn't change the ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, <int>{1, 2});

    original.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2, 3, 4});
    expect(iSet, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.addAll() | "
      "Changing the passed immutable set doesn't change the ISet", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, <int>{1, 2});

    final ISet<int> iSetNew = iSet.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2});
    expect(iSet, <int>{1, 2});
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
    final ISet<int> iSet = original.lock;

    expect(iSet, {1, 2});

    original.remove(2);

    expect(original, <int>{1});
    expect(iSet, <int>{1, 2});
  });

  test(
      "Ensuring Immutability | ISet.remove() | "
      "Removing from the original ISet doesn't change it", () {
    final Set<int> original = {1, 2};
    final ISet<int> iSet = original.lock;

    expect(iSet, <int>{1, 2});

    final ISet<int> iSetNew = iSet.remove(1);

    expect(original, <int>{1, 2});
    expect(iSet, <int>{1, 2});
    expect(iSetNew, <int>{2});
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

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
      "ISet with deep-equals is always different from iSet with identity-equals", () {
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
    final ISet<int> iSet = ISet({1, 2});

    expect(iSet.isDeepEquals, isTrue);
    expect(iSet.config.sort, isTrue);

    final ISet<int> iSetWithCompare = iSet.withConfig(
      iSet.config.copyWith(sort: false),
    );

    expect(iSetWithCompare.isDeepEquals, isTrue);
    expect(iSetWithCompare.config.sort, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("From an empty set", () {
    final ISet iSet = <int>{}.lock;

    expect(iSet, isA<ISet>());
    expect(iSet.isEmpty, isTrue);
    expect(iSet.isNotEmpty, isFalse);
  });

  test("From a set with one int item", () {
    final ISet iSet = {1}.lock;

    expect(iSet, isA<ISet<int>>());
    expect(iSet.isEmpty, isFalse);
    expect(iSet.isNotEmpty, isTrue);
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Creating native mutable sets from immutable sets | " "From the default factory constructor",
      () {
    const Set<int> exampleSet = {1, 2, 3};
    final ISet<int> iSet = ISet(exampleSet);

    expect(iSet.unlock, exampleSet);
    expect(identical(iSet.unlock, exampleSet), isFalse);
  });

  test("Creating native mutable sets from immutable sets | " "From lock", () {
    const Set<int> exampleSet = {1, 2, 3};
    final ISet<int> iSet = exampleSet.lock;

    expect(iSet.unlock, exampleSet);
    expect(identical(iSet.unlock, exampleSet), isFalse);
  });

  test(
      "Creating native mutable sets from immutable sets | ISet.unsafe constructor | "
      "Normal usage", () {
    final Set<int> set = {1, 2, 3};
    final ISet<int> iSet = ISet.unsafe(set, config: ConfigSet());

    expect(set, {1, 2, 3});
    expect(iSet, {1, 2, 3});

    set.add(4);

    expect(set, {1, 2, 3, 4});
    expect(iSet, {1, 2, 3, 4});
  });

  test(
      "Creating native mutable sets from immutable sets | ISet.unsafe constructor | "
      "Disallowing it", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    final Set<int> set = {1, 2, 3};

    expect(() => ISet.unsafe(set, config: ConfigSet()), throwsUnsupportedError);
  });

  test("ISet.flush()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6}).add(7).addAll({}).addAll({8, 9});

    expect(iSet.isFlushed, isFalse);

    iSet.flush;

    expect(iSet.isFlushed, isTrue);
    expect(iSet.unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("ISet.add()", () {
    final ISet<int> baseSet = ISet<int>([1]);
    ISet<int> iSet = baseSet.add(2);

    expect(iSet.unlock, <int>{1, 2});
  });

  test("ISet.add() with a repeated element", () {
    final ISet<int> baseSet = ISet<int>([1]);
    ISet<int> iSet = baseSet.add(1);

    expect(iSet.unlock, <int>{1});
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
    final ISet<int> iSet = ISet<int>({1, 2, 3}).add(1);

    expect(iSet.length, 3);
    expect(iSet.unlock, {1, 2, 3});
  });

  test("Adding repeated elements | Adding multiple repeated elements", () {
    final ISet<int> iSet = ISet<int>({1, 2, 3}).addAll({1, 2});

    expect(iSet.length, 3);
    expect(iSet.unlock, {1, 2, 3});
  });

  test("Adding repeated elements | Adding some repeated elements and another, new one", () {
    final ISet<int> iSet = ISet<int>({1, 2, 3}).addAll({1, 2, 5, 7});

    expect(iSet.length, 5);
    expect(iSet.unlock, {1, 2, 3, 5, 7});
  });

  test("Adding repeated elements | Adding some repeated elements and new ones", () {
    final ISet<int> iSet = ISet<int>({1, 2, 3}).addAll({1, 2, 5, 7, 11, 13});

    expect(iSet.length, 7);
    expect(iSet.unlock, {1, 2, 3, 5, 7, 11, 13});
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("ISet.any()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.any((int v) => v == 4), isTrue);
    expect(iSet.any((int v) => v == 100), isFalse);
  });

  test("ISet.cast()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.cast<num>(), isA<ISet<num>>());
  });

  test("ISet.contains()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.contains(2), isTrue);
    expect(iSet.contains(4), isTrue);
    expect(iSet.contains(5), isTrue);
    expect(iSet.contains(100), isFalse);
  });

  test("ISet.every()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.every((int v) => v > 0), isTrue);
    expect(iSet.every((int v) => v < 0), isFalse);
    expect(iSet.every((int v) => v != 4), isFalse);
  });

  test("ISet.expand()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.expand((int v) => {v, v}),
        // ignore: equal_elements_in_set
        {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6});
    expect(iSet.expand((int v) => <int>{}), <int>{});
  });

  test("ISet.length", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.length, 6);
  });

  test("ISet.first", () {
    expect({1, 2, 3, 4, 5, 6}.lock.first, 1);
    expect({3, 6, 4, 1, 2, 5}.lock.first, 1);
  });

  test("ISet.last method", () {
    expect({1, 2, 3, 4, 5, 6}.lock.last, 6);
    expect({3, 6, 4, 1, 2, 5}.lock.last, 6);
  });

  test("ISet.single() | State exception", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iSet.single, throwsStateError);
  });

  test("ISet.single() | Access", () => expect({10}.lock.single, 10));

  test("ISet.firstWhere()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(iSet.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(iSet.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(iSet.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("ISet.fold()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("ISet.followedBy()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.followedBy({7, 8}).unlock, {1, 2, 3, 4, 5, 6, 7, 8});
    expect(iSet.followedBy(<int>{}.lock.add(7).addAll({8, 9})).unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  test("ISet.forEach()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    int result = 100;
    iSet.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("ISet.join()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.join(","), "1,2,3,4,5,6");
    expect(<int>{}.lock.join(","), "");
  });

  test("ISet.lastWhere()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iSet.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(iSet.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(iSet.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(iSet.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(iSet.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(iSet.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("ISet.map()", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect({1, 2, 3}.lock.map((int v) => v + 1).unlock, {2, 3, 4});
    expect(iSet.map((int v) => v + 1).unlock, {2, 3, 4, 5, 6, 7});
  });

  group("ISet methods from Iterable |", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});

    group("ISet.reduce method |", () {
      test("Regular usage", () {
        expect(iSet.reduce((int p, int e) => p * (1 + e)), 2520);
        expect({5}.lock.reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          "State exception",
          () => expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.singleWhere method |", () {
      test("Regular usage", () {
        expect(iSet.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(iSet.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          "State exception",
          () => expect(
              () => iSet.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test("ISet.skip method", () {
      expect(iSet.skip(1).unlock, {2, 3, 4, 5, 6});
      expect(iSet.skip(3).unlock, {4, 5, 6});
      expect(iSet.skip(5).unlock, {6});
      expect(iSet.skip(10).unlock, <int>{});
    });

    test("ISet.skipWhile method", () {
      expect(iSet.skipWhile((int v) => v < 3).unlock, {3, 4, 5, 6});
      expect(iSet.skipWhile((int v) => v < 5).unlock, {5, 6});
      expect(iSet.skipWhile((int v) => v < 6).unlock, {6});
      expect(iSet.skipWhile((int v) => v < 100).unlock, <int>{});
    });

    test("ISet.take method", () {
      expect(iSet.take(0).unlock, <int>{});
      expect(iSet.take(1).unlock, {1});
      expect(iSet.take(3).unlock, {1, 2, 3});
      expect(iSet.take(5).unlock, {1, 2, 3, 4, 5});
      expect(iSet.take(10).unlock, {1, 2, 3, 4, 5, 6});
    });

    test("ISet.takeWhile method", () {
      expect(iSet.takeWhile((int v) => v < 3).unlock, {1, 2});
      expect(iSet.takeWhile((int v) => v < 5).unlock, {1, 2, 3, 4});
      expect(iSet.takeWhile((int v) => v < 6).unlock, {1, 2, 3, 4, 5});
      expect(iSet.takeWhile((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.toList method |", () {
      test("Regular usage", () {
        expect(iSet.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(iSet.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test("Unsupported exception",
          () => expect(() => iSet.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test("ISet.toIList method", () => expect(iSet.toIList(), IList([1, 2, 3, 4, 5, 6])));

    test("ISet.toSet method", () {
      expect(iSet.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(iSet.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("ISet.where method", () {
      expect(iSet.where((int v) => v < 0).unlock, <int>{});
      expect(iSet.where((int v) => v < 3).unlock, {1, 2});
      expect(iSet.where((int v) => v < 5).unlock, {1, 2, 3, 4});
      expect(iSet.where((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
    });

    test("ISet.whereType method",
        () => expect((<num>{1, 2, 1.5}.lock.whereType<double>()).unlock, {1.5}));

    test("ISet.toString method", () => expect(iSet.toString(), "{1, 2, 3, 4, 5, 6}"));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("ISet.iterator |", () {
    test("ISet.iterator getter", () {
      ISet<int> iSet = {2, 5, 3, 7, 9, 6, 1}.lock;
      expect(iSet.config.sort, isTrue);

      // The regular iterator is SORTED.
      expect(iSet.iterator.toList(), [1, 2, 3, 5, 6, 7, 9]);

      // The for loop uses the SORTED iterator.
      var result = [];
      for (int value in iSet) result.add(value);
      expect(iSet.iterator.toList(), [1, 2, 3, 5, 6, 7, 9]);

      // You can also use a fast iterator which will NOT sort the result.
      expect(iSet.fastIterator.toList(), [2, 5, 3, 7, 9, 6, 1]);

      // ---

      // But you can configure the set NOT to sort the iterator.
      iSet = iSet.withConfig(const ConfigSet(sort: false));
      expect(iSet.config.sort, isFalse);
      expect(iSet.iterator.toList(), [2, 5, 3, 7, 9, 6, 1]);
      result = [];
      for (int value in iSet) result.add(value);
      expect(iSet.iterator.toList(), [2, 5, 3, 7, 9, 6, 1]);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("ISet of MapEntry gets special treatment |", () {
    test("Equals", () {
      final ISet<MapEntry<String, int>> iSet1 = ISet([MapEntry("a", 1)]).withDeepEquals,
          iSet2 = ISet([MapEntry("a", 1)]).withDeepEquals;

      expect(iSet1, iSet2);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("ISet.toggle method |", () {
    ISet<int> iSet = {1, 2, 3}.lock;

    test("Toggling an existing element", () {
      expect(iSet.contains(3), isTrue);

      iSet = iSet.toggle(3);

      expect(iSet.contains(3), isFalse);

      iSet = iSet.toggle(3);

      expect(iSet.contains(3), isTrue);
    });

    test("Toggling a nonexistent element", () {
      expect(iSet.contains(4), isFalse);

      iSet = iSet.toggle(4);

      expect(iSet.contains(4), isTrue);

      iSet = iSet.toggle(4);

      expect(iSet.contains(4), isFalse);
    });
  });

  test("ISet.elementAt method", () {
    final ISet<int> iSet = {1, 2, 3}.lock;
    expect(() => iSet.elementAt(0), throwsUnsupportedError);
  });

  test("ISet.clear method", () {
    final ISet<int> iSet = ISet.withConfig({1, 2, 3}, ConfigSet(isDeepEquals: false));

    final ISet<int> iSetCleared = iSet.clear();

    expect(iSetCleared, allOf(isA<ISet<int>>(), <int>{}));
    expect(iSetCleared.config.isDeepEquals, isFalse);
  });

  group("Remove, Union and Other Related Methods |", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;

    tearDown(() => expect(iSet1, {1, 2, 3, 4}));

    group("Set Math Operations |", () {
      test("ISet.containsAll method", () {
        // TODO: Marcelo, o argumento desses métodos não deveria ser `Iterable` ou `ISet`?
        expect(iSet1.containsAll([2, 2, 3]), isTrue);
        expect(iSet1.containsAll({1, 2, 3, 4}), isTrue);
        expect(iSet1.containsAll({10, 20, 30, 40}), isFalse);
      });

      test("ISet.difference method", () {
        expect(iSet1.difference({1, 2, 5}), {3, 4});
        expect(iSet1.difference({1, 2, 3, 4}), <int>{});
      });

      test("ISet.intersection method", () {
        expect(iSet1.intersection({1, 2, 5}), {1, 2});
        expect(iSet1.intersection({10, 20, 50}), <int>{});
      });

      test("ISet.union method", () {
        expect(iSet1.union({1}), {1, 2, 3, 4});
        expect(iSet1.union({1, 2, 5}), {1, 2, 3, 4, 5});
      });

      test("ISet.lookup method", () {
        expect(iSet1.lookup(1), 1);
        expect(iSet1.lookup(10), isNull);
      });
    });

    group("Remove |", () {
      test("ISet.removeAll method", () {
        expect(iSet1.removeAll({}), {1, 2, 3, 4});
        expect(iSet1.removeAll({2, 3}), {1, 4});
      });

      test("ISet.removeWhere method", () {
        expect(iSet1.removeWhere((int element) => element > 10), {1, 2, 3, 4});
        expect(iSet1.removeWhere((int element) => element > 2), {1, 2});
      });
    });

    group("Retain |", () {
      test("ISet.retainAll method", () {
        expect(iSet1.retainAll({}), <int>{});
        expect(iSet1.retainAll({2, 3}), {2, 3});
      });

      test("ISet.retainWhere method", () {
        expect(iSet1.retainWhere((int element) => element > 10), <int>{});
        expect(iSet1.retainWhere((int element) => element < 2), <int>{1});
      });
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

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
}
