// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(ISet(), isA<ISet>());
    expect(ISet({}), isA<ISet>());
    expect(ISet<String>({}), isA<ISet<String>>());
    expect(ISet([1]), isA<ISet<int>>());
    expect(ISet<int>(), isA<ISet<int>>());
    expect(<int>{}.lock, isA<ISet>());
    expect(const ISet.empty(), isA<ISet>());
    expect(const ISet<int>.empty(), isA<ISet<int>>());
    const ISet untypedList = ISet.empty();
    expect(untypedList, isA<ISet>());
    const ISet<int> typedList = ISet.empty();
    expect(typedList, isA<ISet<int>>());
  });

  test("fromIterable", () {
    // 1) Regular usage
    ISet<int> iset =
        ISet.fromIterable<int, String>(["a", "b", "c"], mapper: (String char) => char.codeUnits);
    expect(iset, {97, 98, 99});

    // 2) With sorting
    iset = ISet.fromIterable([1, 3, 2],
        mapper: (int value) => [2 * value], config: const ConfigSet(sort: true));

    expect(iset.config, const ConfigSet(sort: true));
    expect(iset, [2, 4, 6]);
    expect(iset.elementAt(0), 2);
    expect(iset.elementAt(1), 4);
    expect(iset.elementAt(2), 6);
  });

  test("orNull", () {
    // 1) Null -> Null
    Set<int>? set;
    expect(ISet.orNull(set), isNull);

    // 2) Set -> ISet
    set = <int>{1, 2, 3};
    expect(ISet.orNull(set), {1, 2, 3});

    // 3) Set with Config -> ISet with Config
    ISet<int>? iset = ISet.orNull(set, ConfigSet(isDeepEquals: false));
    expect(iset, {1, 2, 3});
    expect(iset?.config, ConfigSet(isDeepEquals: false));
  });

  test("isEmpty | isNotEmpty", () {
    expect(ISet().isEmpty, isTrue);
    expect(ISet({}).isEmpty, isTrue);
    expect(ISet<String>({}).isEmpty, isTrue);
    expect(ISet([1]).isEmpty, isFalse);
    expect(ISet<int>().isEmpty, isTrue);
    expect(<int>{}.lock.isEmpty, isTrue);
    expect(const ISet.empty().isEmpty, isTrue);
    expect(const ISet<String>.empty().isEmpty, isTrue);

    expect(ISet().isNotEmpty, isFalse);
    expect(ISet({}).isNotEmpty, isFalse);
    expect(ISet<String>({}).isNotEmpty, isFalse);
    expect(ISet([1]).isNotEmpty, isTrue);
    expect(ISet<int>().isNotEmpty, isFalse);
    expect(<int>{}.lock.isNotEmpty, isFalse);
    expect(const ISet.empty().isNotEmpty, isFalse);
    expect(const ISet<String>.empty().isNotEmpty, isFalse);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable list doesn't change the ISet
    Set<int> original = {1, 2};
    ISet<int> iset = original.lock;

    expect(iset, original);

    original.add(3);
    original.add(4);

    expect(original, <int>{1, 2, 3, 4});
    expect(iset, <int>{1, 2});

    // 1.2) Changing the ISet also doesn't change the original set
    original = {1, 2};
    iset = original.lock;

    expect(iset, original);

    ISet<int?> iSetNew = iset.add(3);

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside ISet
    original = {1, 2};
    iset = original.lock;

    expect(iset, original);

    int willChange = 4;
    iSetNew = iset.add(willChange);

    willChange = 5;

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(willChange, 5);
    expect(iSetNew, <int>{1, 2, 4});

    // 2) addAll

    // 2.1) Changing the passed mutable list doesn't change the ISet
    original = {1, 2};
    iset = original.lock;

    expect(iset, <int>{1, 2});

    original.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2, 3, 4});
    expect(iset, <int>{1, 2});

    // 2.2) Changing the passed immutable set doesn't change the ISet
    original = {1, 2};
    iset = original.lock;

    expect(iset, <int>{1, 2});

    iSetNew = iset.addAll(<int>{2, 3, 4});

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3, 4});

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {1, 2};
    final ISet<int?> iSet1 = original.lock;
    final ISet<int> iSet2 = original.lock;

    expect(iSet1, original);
    expect(iSet2, original);

    iSetNew = iSet1.addAll(iSet2.addAll({3, 4}));
    original.add(3);

    expect(original, <int>{1, 2, 3});
    expect(iSet1, <int>{1, 2});
    expect(iSet2, <int>{1, 2});
    expect(iSetNew, <int>{1, 2, 3, 4});

    // 3) remove

    // 3.1) Changing the passed mutable set doesn't change the ISet
    original = {1, 2};
    iset = original.lock;

    expect(iset, {1, 2});

    original.remove(2);

    expect(original, <int>{1});
    expect(iset, <int>{1, 2});

    // 3.2) Removing from the original ISet doesn't change it
    original = {1, 2};
    iset = original.lock;

    expect(iset, <int>{1, 2});

    iSetNew = iset.remove(1);

    expect(original, <int>{1, 2});
    expect(iset, <int>{1, 2});
    expect(iSetNew, <int>{2});
  });

  test("==", () {
    // 1) ISet with identity-equals compares the set instance, not the items
    ISet<int> iset = ISet({1, 2}).withIdentityEquals;
    expect(iset == iset, isTrue);
    expect(iset == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(iset == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(iset == {1, 2}.lock, isFalse);
    expect(iset == ISet({1, 2, 3}).withIdentityEquals, isFalse);

    // 2) ISet with deep-equals compares the items, not necessarily the list instance
    iset = ISet({1, 2});
    expect(iset == iset, isTrue);
    expect(iset == ISet({1, 2}), isTrue);
    expect(iset == ISet({2, 1}), isTrue);
    expect(iset == {1, 2}.lock.withDeepEquals, isTrue);
    expect(iset == ISet({1, 2, 3}), isFalse);

    // 3) ISet with deep-equals is always different from iset with identity-equals
    expect(ISet({1, 2}).withDeepEquals == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(ISet({1, 2}).withIdentityEquals == ISet({1, 2}).withDeepEquals, isFalse);
    expect(ISet({1, 2}).withDeepEquals == ISet({1, 2}), isTrue);
    expect(ISet({1, 2}) == ISet({1, 2}).withDeepEquals, isTrue);
  });

  test("isIdentityEquals and isDeepEquals properties", () {
    final ISet<int> iSet1 = ISet({1, 2});
    final ISet<int> iSet2 = ISet({1, 2}).withIdentityEquals;

    expect(iSet1.isIdentityEquals, isFalse);
    expect(iSet1.isDeepEquals, isTrue);
    expect(iSet2.isIdentityEquals, isTrue);
    expect(iSet2.isDeepEquals, isFalse);
  });

  test("same", () {
    final ISet<int> iset = ISet({1, 2});
    expect(iset.same(iset), isTrue);
    expect(iset.same(ISet({1, 2})), isFalse);
    expect(iset.same(ISet({1})), isFalse);
    expect(iset.same(ISet({2, 1})), isFalse);
    expect(iset.same(ISet({1, 2}).withIdentityEquals), isFalse);
    expect(iset.same(iset.add(2)), isTrue);
  });

  test("equalItemsAndConfig", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1.equalItemsAndConfig(iSet1), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1, 2})), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1})), isFalse);
    expect(iSet1.equalItemsAndConfig(ISet({2, 1})), isTrue);
    expect(iSet1.equalItemsAndConfig(ISet({1, 2}).withIdentityEquals), isFalse);
    expect(iSet1.equalItemsAndConfig(iSet1.remove(3)), isTrue);
  });

  test("==", () {
    final ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1 == iSet1, isTrue);
    expect(iSet1 == ISet({1, 2}), isTrue);
    expect(iSet1 == ISet({1}), isFalse);
    expect(iSet1 == ISet({2, 1}), isTrue);
    expect(iSet1 == ISet({1, 2}).withIdentityEquals, isFalse);
  });

  test("equalItems", () {
    // 1) Regular usage
    expect(ISet({1, 2}).equalItems(null), isFalse);
    expect(ISet({1, 2}).equalItems([1, 2]), isTrue);
    expect(ISet({1, 2}).equalItems([2, 1]), isTrue);
    expect(ISet({1, 2}).equalItems([1]), isFalse);

    // 2) if other is ISet<T> (we only take into account the items, not the configs)
    expect(ISet({1, 2}).equalItems({1, 2}.lock), isTrue);
    expect(ISet({1, 2}).equalItems({1, 2}.lock.withIdentityEquals), isTrue);
    expect(ISet({1, 2}).equalItems({1, 3}.lock), isFalse);
    expect(ISet({1, 2}).equalItems({1, 3}.lock.withIdentityEquals), isFalse);
  });

  test("hashCode", () {
    // 1) deepEquals vs deepEquals
    ISet<int> iSet1 = ISet({1, 2});
    expect(iSet1 == ISet({1, 2}), isTrue);
    expect(iSet1 == ISet({1, 2, 3}), isFalse);
    expect(iSet1 == ISet({2, 1}), isTrue);
    expect(iSet1.hashCode, ISet({1, 2}).hashCode);
    expect(iSet1.hashCode, isNot(ISet({1, 2, 3}).hashCode));
    expect(iSet1.hashCode, ISet({2, 1}).hashCode);

    // 2) identityEquals vs identityEquals
    ISet<int> iSet1WithIdentity = ISet({1, 2}).withIdentityEquals;
    expect(iSet1WithIdentity == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity == ISet({1, 2, 3}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(iSet1WithIdentity.hashCode, isNot(ISet({1, 2}).withIdentityEquals.hashCode));
    expect(iSet1WithIdentity.hashCode, isNot(ISet({1, 2, 3}).withIdentityEquals.hashCode));
    expect(iSet1WithIdentity.hashCode, isNot(ISet({2, 1}).withIdentityEquals.hashCode));

    // 3) deepEquals vs identityEquals
    iSet1 = ISet({1, 2});
    iSet1WithIdentity = iSet1.withIdentityEquals;
    expect(iSet1 == iSet1WithIdentity, isFalse);
    expect(ISet({1, 2}) == ISet({1, 2}).withIdentityEquals, isFalse);
    expect(ISet({1, 2, 3}) == ISet({1, 2, 3}).withIdentityEquals, isFalse);
    expect(ISet({2, 1}) == ISet({2, 1}).withIdentityEquals, isFalse);
    expect(iSet1.hashCode, isNot(iSet1WithIdentity.hashCode));
    expect(ISet({1, 2}).hashCode, isNot(ISet({1, 2}).withIdentityEquals.hashCode));
    expect(ISet({1, 2, 3}).hashCode, isNot(ISet({1, 2, 3}).withIdentityEquals.hashCode));
    expect(ISet({2, 1}).hashCode, isNot(ISet({2, 1}).withIdentityEquals.hashCode));

    // 4) when cache is on
    Set<int> set = {1, 2, 3};

    final ISet<int> iSetWithCache = ISet.unsafe(set, config: ConfigSet(cacheHashCode: true));

    int hashBefore = iSetWithCache.hashCode;

    set.add(4);

    int hashAfter = iSetWithCache.hashCode;

    expect(hashAfter, hashBefore);

    // 5) when cache is off
    set = {1, 2, 3};

    final ISet<int> iSetWithoutCache = ISet.unsafe(set, config: ConfigSet(cacheHashCode: false));

    hashBefore = iSetWithoutCache.hashCode;

    set.add(4);

    hashAfter = iSetWithoutCache.hashCode;

    expect(hashAfter, isNot(hashBefore));
  });

  test("config", () {
    final ISet<int> iset = ISet({1, 2});

    expect(iset.isDeepEquals, isTrue);
    expect(iset.config.sort, isFalse);

    final ISet<int> iSetWithCompare = iset.withConfig(
      iset.config.copyWith(sort: true),
    );

    expect(iSetWithCompare.isDeepEquals, isTrue);
    expect(iSetWithCompare.config.sort, isTrue);
  });

  test("withConfig factory", () {
    // 1) Regular usage
    final ISet<int> iSet1 = ISet.withConfig({1, 2, 3}, ConfigSet(isDeepEquals: false));
    final ISet<int> iSet2 = ISet.withConfig({}, ConfigSet(isDeepEquals: false));

    expect(iSet1, {1, 2, 3});
    expect(iSet1.isDeepEquals, isFalse);

    expect(iSet2, <int>{});
    expect(iSet2.isDeepEquals, isFalse);

    // 2) With empty set and different configs
    final ISet<int> emptyIList = <int>{}.lock;
    expect(ISet.withConfig(emptyIList, const ConfigSet(cacheHashCode: false)), []);

    // 3) With non-empty set and different configs
    final ISet<int> nonemptyIList = <int>{1, 2, 3}.lock;
    expect(ISet.withConfig(nonemptyIList, const ConfigSet(cacheHashCode: false)), [1, 2, 3]);

    // 4) With sorting
    ISet<int> iset = ISet.withConfig({1, 3, 2}, ConfigSet(sort: true));
    expect(iset, [1, 2, 3]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 2);
    expect(iset.elementAt(2), 3);
  });

  test("Changing configs", () {
    var iset1 = ISet.withConfig({1, 3, 2}, ConfigSet(sort: true)).withConfig(ConfigSet(sort: true));
    expect(iset1, [1, 2, 3]);
    expect(iset1.elementAt(0), 1);
    expect(iset1.elementAt(1), 2);
    expect(iset1.elementAt(2), 3);

    var iset2 =
        ISet.withConfig({1, 3, 2}, ConfigSet(sort: true)).withConfig(ConfigSet(sort: false));
    expect(iset2, [1, 2, 3]);
    expect(iset2.elementAt(0), 1);
    expect(iset2.elementAt(1), 2);
    expect(iset2.elementAt(2), 3);

    var iset3 =
        ISet.withConfig({1, 3, 2}, ConfigSet(sort: false)).withConfig(ConfigSet(sort: true));
    expect(iset3, [1, 2, 3]);
    expect(iset3.elementAt(0), 1);
    expect(iset3.elementAt(1), 2);
    expect(iset3.elementAt(2), 3);

    var iset4 =
        ISet.withConfig({1, 3, 2}, ConfigSet(sort: false)).withConfig(ConfigSet(sort: false));
    expect(iset4, [1, 3, 2]);
    expect(iset4.elementAt(0), 1);
    expect(iset4.elementAt(1), 3);
    expect(iset4.elementAt(2), 2);
  });

  test("withConfigFrom", () {
    // 1) Regular usage
    ISet<int> iset = {1, 3, 2}.lock;
    ISet<int> iSetWithIdentityEquals =
        ISet.withConfig({1, 2, 3}, const ConfigSet(isDeepEquals: false));

    expect(iset.withConfigFrom(iSetWithIdentityEquals), [1, 3, 2]);
    expect(
        iset.withConfigFrom(iSetWithIdentityEquals).config, const ConfigSet(isDeepEquals: false));

    // 2) With sorting
    iset = {1, 3, 2}.lock.withConfigFrom(ISet.withConfig({}, ConfigSet(sort: true)));
    expect(iset, [1, 2, 3]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 2);
    expect(iset.elementAt(2), 3);
  });

  test("withConfig method", () {
    // 1) Regular usage
    ISet<int> iset = {1, 3, 2}.lock.withConfig(ConfigSet(isDeepEquals: false));

    expect(iset.config, ConfigSet(isDeepEquals: false));
    expect(iset, [1, 3, 2]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 2);

    // 2) With sorting
    iset = {1, 3, 2}.lock.withConfig(ConfigSet(sort: true));

    expect(iset.config, ConfigSet(sort: true));
    expect(iset, [1, 2, 3]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 2);
    expect(iset.elementAt(2), 3);
  });

  test("default constructor", () {
    const Set<int> exampleSet = {1, 2, 3};
    final ISet<int> iset = ISet(exampleSet);

    expect(iset.unlock, exampleSet);
    expect(identical(iset.unlock, exampleSet), isFalse);
  });

  test("unsafe", () {
    // 1) Regular Usage
    Set<int> set = {1, 2, 3};
    ISet<int> iset = ISet.unsafe(set, config: ConfigSet(isDeepEquals: true));

    expect(iset.config, ConfigSet(isDeepEquals: true));

    expect(set, {1, 2, 3});
    expect(iset, {1, 2, 3});

    set.add(4);

    expect(set, {1, 2, 3, 4});
    expect(iset, {1, 2, 3, 4});

    // 2) With sort true, will break the set if it is not already sorted.
    iset = ISet.unsafe({1, 3, 2}, config: const ConfigSet(sort: true));

    // Broken!
    expect(iset.config, const ConfigSet(sort: true));
    expect(iset, [1, 3, 2]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 2);

    // 3) Disallowing it
    ImmutableCollection.disallowUnsafeConstructors = true;
    set = {1, 2, 3};

    expect(() => ISet.unsafe(set, config: ConfigSet()), throwsUnsupportedError);
  });

  test("empty", () {
    // 1) Regular usage
    ISet<int> iset = ISet<int>();
    iset = iset.addAll({2, 3}).add(1);

    expect(iset, [2, 3, 1]);
    expect(iset.elementAt(0), 2);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 1);

    // 2) With sorting
    iset = ISet<int>.withConfig([], const ConfigSet(sort: true));
    iset = iset.addAll({2, 3}).add(1);

    expect(iset, [1, 2, 3]);
    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 2);
    expect(iset.elementAt(2), 3);
  });

  test("flush", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({10, 11}).add(7).addAll({}).addAll({8, 9});

    expect(iset.isFlushed, isFalse);

    iset.flush;

    expect(iset.isFlushed, isTrue);
    expect(iset.unlock, {1, 2, 3, 4, 10, 11, 7, 8, 9});
  });

  test("add", () {
    // 1) Adding a new element
    ISet<int> baseSet = ISet<int>([1]);
    ISet<int> iset = baseSet.add(2);

    expect(iset.unlock, <int>{1, 2});

    // 2) Adding a repeated element
    baseSet = ISet<int>([1]);
    iset = baseSet.add(1);

    expect(iset.unlock, <int>{1});

    // 3) Null checks

    // 3.1) Regular usage
    expect(<int>{}.lock.add(1), {1});
    expect(<int?>{null}.lock.add(1), {null, 1});
    expect(<int>{1}.lock.add(10), {1, 10});
    expect(<int?>{null}.lock.add(10), {null, 10});
    expect(<int?>{null, 1, 3}.lock.add(10), {null, 1, 3, 10});
    expect({1, 2, 3}.lock.add(4), {1, 2, 3, 4});

    // 3.2) Adding a null
    expect(<int?>{null}.lock.add(null), {null});
    expect(<int?>{null, 1, 3}.lock.add(null), {null, 1, 3});

    // 4) With sort
    iset = <int>{}.lock.withConfig(ConfigSet(sort: true)).add(1).add(20).add(3).add(20);

    expect(iset.config, ConfigSet(sort: true));

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 20);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(3), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 3);
    expect(iset[2], 20);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[3], throwsRangeError);
  });

  test("addAll", () {
    // 1) Adding a repeated element
    ISet<int> iset = ISet<int>({1, 2, 3}).addAll({1});

    expect(iset.length, 3);
    expect(iset.unlock, {1, 2, 3});

    // 2) Adding a repeated and a new element
    iset = ISet<int>({1, 2, 3}).addAll({1, 2});

    expect(iset.length, 3);
    expect(iset.unlock, {1, 2, 3});

    // 3) Adding some repeated and some new elements
    iset = ISet<int>({1, 2, 3}).addAll({1, 2, 5, 7, 11, 13});

    expect(iset.length, 7);
    expect(iset.unlock, {1, 2, 3, 5, 7, 11, 13});

    // 4) Null checks

    // 4.1) Regular Usage
    expect(<int>{}.lock.addAll({1, 2}), {1, 2});
    expect(<int?>{null}.lock.addAll({1, 2}), {null, 1, 2});
    expect(<int>{1}.lock.addAll({2, 3}), {1, 2, 3});
    expect(<int?>{null}.lock.addAll({1, 2}), {null, 1, 2});
    expect(<int?>{null, 1, 3}.lock.addAll({10, 11}), {null, 1, 3, 10, 11});
    expect({1, 2, 3, 4}.lock.addAll({5, 6}), {1, 2, 3, 4, 5, 6});

    // 4.2) Adding nulls
    expect(<int?>{null}.lock.addAll({null}), {null});
    expect(<int?>{null, 1, 3}.lock.addAll({null}), {null, 1, 3});

    // 4.3) Adding null and an item
    expect(<int?>{null}.lock.addAll({null, 1}), {null, 1});
    expect(<int?>{null, 1, 3}.lock.addAll({null, 1}), {null, 1, 3});

    // 4) With sort
    iset = <int>{}
        .lock
        .withConfig(const ConfigSet(sort: true))
        .addAll({1, 100})
        .add(20)
        .addAll({3, 100, 10});

    expect(iset.config, const ConfigSet(sort: true));

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 10);
    expect(iset.elementAt(3), 20);
    expect(iset.elementAt(4), 100);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(5), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 3);
    expect(iset[2], 10);
    expect(iset[3], 20);
    expect(iset[4], 100);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[5], throwsRangeError);
  });

  test("+", () {
    // 1) Simple example
    expect({1, 2, 3}.lock + [1, 2, 4], {1, 2, 3, 4});

    // 2) Regular Usage
    expect(<int>{}.lock + {1, 2}, {1, 2});
    expect(<int?>{null}.lock + {1, 2}, {null, 1, 2});
    expect(<int>{1}.lock + {2, 3}, {1, 2, 3});
    expect(<int?>{null, 1, 3}.lock + {10, 11}, {null, 1, 3, 10, 11});
    expect({1, 2, 3, 4}.lock + {5, 6}, {1, 2, 3, 4, 5, 6});

    // 3) Adding nulls
    expect(<int?>{null}.lock + {null}, {null});
    expect(<int?>{null, 1, 3}.lock + {null}, {null, 1, 3});

    // 4) Adding null and an item
    expect(<int?>{null}.lock + {null, 1}, {null, 1});
    expect(<int?>{null, 1, 3}.lock + {null, 1}, {null, 1, 3});

    // 4) With sort
    final ISet<int> iset = <int>{}.lock.withConfig(ConfigSet(sort: true)) + {1} + {20, 3} + {20};

    expect(iset.config, ConfigSet(sort: true));

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 20);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(3), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 3);
    expect(iset[2], 20);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[3], throwsRangeError);
  });

  test("add and addAll", () {
    final ISet<int> iSet1 = {1, 2, 3}.lock;
    final ISet<int> iSet2 = iSet1.add(4);
    final ISet<int> iSet3 = iSet2.addAll({5, 6});

    expect(iSet1.unlock, {1, 2, 3});
    expect(iSet2.unlock, {1, 2, 3, 4});
    expect(iSet3.unlock, {1, 2, 3, 4, 5, 6});

    // Methods are chainable.
    expect(iSet1.add(10).addAll({20, 30}).unlock, {1, 2, 3, 10, 20, 30});
  });

  test("remove", () {
    // 1) Regular usage
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

    // 2) Poking around with nulls
    expect(<int>{}.lock.remove(1), <int>{});

    expect(<int?>{null}.lock.remove(null), <int>{});
    expect(<int?>{null}.lock.remove(1), <int?>{null});

    expect(<int>{1}.lock.remove(1), <int>{});

    expect(<int?>{null, 1}.lock.remove(null), <int>{1});
    expect(<int?>{null, 1}.lock.remove(1), <int?>{null});
  });

  test("any", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.any((int? v) => v == 4), isTrue);
    expect(iset.any((int? v) => v == 100), isFalse);
  });

  test("cast", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.cast<num>(), isA<Iterable<num>>());
  });

  test("contains", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.contains(2), isTrue);
    expect(iset.contains(4), isTrue);
    expect(iset.contains(5), isTrue);
    expect(iset.contains(100), isFalse);
    expect(iset.contains(null), isFalse);
  });

  test("every", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.every((int? v) => v! > 0), isTrue);
    expect(iset.every((int? v) => v! < 0), isFalse);
    expect(iset.every((int? v) => v != 4), isFalse);
  });

  test("expand", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(
        iset.expand((int? v) => {v, v}),
        // ignore: equal_elements_in_set
        {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6});
    expect(iset.expand((int? v) => <int>{}), <int>{});
  });

  test("length", () {
    // 1) Regular usage
    ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.length, 6);

    // 2) When the set is empty
    iset = ISet();

    expect(iset.length, 0);
    expect(iset.isEmpty, isTrue);
  });

  test("first", () {
    // 1) Regular usage
    expect({1, 2, 3, 4, 5, 6}.lock.first, 1);
    expect({3, 6, 4, 1, 2, 5}.lock.first, 3);

    // 2) Without sorting
    final ISet<int> iset = {100, 2, 3}.lock.add(1).add(5).withConfig(ConfigSet(sort: false));
    expect(iset.first, 100);

    // 3) With sorting
    expect({3, 6, 4, 1, 2, 5}.lock.withConfig(ConfigSet(sort: true)).first, 1);
  });

  test("last", () {
    // 1) Regular usage
    expect({1, 2, 3, 4, 5, 6}.lock.last, 6);
    expect({3, 6, 4, 1, 2, 5}.lock.last, 5);

    // 2) Without sorting
    final ISet<int> iset = {100, 2, 3}.lock.add(1).add(5).withConfig(ConfigSet(sort: false));
    expect(iset.last, 5);
    expect({3, 6, 4, 1, 2, 5}.lock.withConfig(ConfigSet(sort: true)).first, 1);

    // 3) With sorting
    expect({3, 6, 4, 1, 2, 5}.lock.withConfig(ConfigSet(sort: true)).last, 6);
  });

  test("anyItem", () {
    final ISet<List<int>> iset = <List<int>>{
      [1, 2, 3],
      [11, 12]
    }.lock.add([100, 101]);

    expect(iset.anyItem.isEmpty, isFalse);
  });

  test("firstOrNull", () {
    expect(<int>{}.lock.firstOrNull, isNull);
    expect({1, 2, 3}.lock.firstOrNull, 1);
  });

  test("lastOrNull", () {
    expect(<int>{}.lock.lastOrNull, isNull);
    expect({1, 2, 3}.lock.lastOrNull, 3);
  });

  test("singleOrNull", () {
    expect(<int>{}.lock.singleOrNull, isNull);
    expect(<int>{1}.lock.singleOrNull, 1);
    expect({1, 2, 3}.lock.singleOrNull, isNull);
  });

  test("firstOr", () {
    expect(<int>{}.lock.firstOr(10), 10);
    expect(<int>{1, 2, 3}.lock.firstOr(10), 1);
  });

  test("lastOr", () {
    expect(<int>{}.lock.lastOr(10), 10);
    expect(<int>{1, 2, 3}.lock.lastOr(10), 3);
  });

  test("singleOr", () {
    expect(<int>{}.lock.singleOr(10), 10);
    expect(<int>{1}.lock.singleOr(10), 1);
    expect(<int>{1, 2, 3}.lock.singleOr(10), 10);
  });

  test("single", () {
    // 1) Regular usage
    expect({10}.lock.single, 10);

    // 2) Exception when more than 1 item
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.single, throwsStateError);
  });

  test("firstWhere", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({10, 6});
    expect(iset.firstWhere((int? v) => v! > 1, orElse: () => 100), 2);
    expect(iset.firstWhere((int? v) => v! > 4, orElse: () => 100), 10);
    expect(iset.firstWhere((int? v) => v! > 100, orElse: () => 100), 100);
  });

  test("fold", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.fold(100, (int p, int? e) => p * (1 + e!)), 504000);
  });

  test("followedBy", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.followedBy({7, 8}), {1, 2, 3, 4, 5, 6, 7, 8});
    expect(iset.followedBy({7, 8}.lock), {1, 2, 3, 4, 5, 6, 7, 8});
    expect(iset.followedBy(<int>{}.lock.add(7).addAll({8, 9})), {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  test("forEach", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    int result = 100;
    iset.forEach((int? v) => result *= 1 + v!);
    expect(result, 504000);
  });

  test("join", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.join(","), "1,2,3,4,5,6");
    expect(<int>{}.lock.join(","), "");
  });

  test("lastWhere", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.lastWhere((int? v) => v! < 2, orElse: () => 100), 1);
    expect(iset.lastWhere((int? v) => v! < 5, orElse: () => 100), 4);
    expect(iset.lastWhere((int? v) => v! < 6, orElse: () => 100), 5);
    expect(iset.lastWhere((int? v) => v! < 7, orElse: () => 100), 6);
    expect(iset.lastWhere((int? v) => v! < 50, orElse: () => 100), 6);
    expect(iset.lastWhere((int? v) => v! < 1, orElse: () => 100), 100);
  });

  test("map", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect({1, 2, 3}.lock.map((int v) => v + 1), {2, 3, 4});
    expect(iset.map((int? v) => v! + 1), {2, 3, 4, 5, 6, 7});
  });

  test("reduce", () {
    // 1) Regular usage
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.reduce((int? p, int? e) => p! * (1 + e!)), 2520);
    expect({5}.lock.reduce((int p, int e) => p * (1 + e)), 5);

    // 2) Exception
    expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  test("singleWhere", () {
    // 1) Regular usage
    ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.singleWhere((int? v) => v == 4, orElse: () => 100), 4);
    expect(iset.singleWhere((int? v) => v == 50, orElse: () => 100), 100);

    // 2) Exception
    iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.singleWhere((int? v) => v! < 4, orElse: () => 100), throwsStateError);
  });

  test("skip", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.skip(1), {2, 3, 4, 5, 6});
    expect(iset.skip(3), {4, 5, 6});
    expect(iset.skip(5), {6});
    expect(iset.skip(10), <int>{});
  });

  test("skipWhile", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.skipWhile((int? v) => v! < 3), {3, 4, 5, 6});
    expect(iset.skipWhile((int? v) => v! < 5), {5, 6});
    expect(iset.skipWhile((int? v) => v! < 6), {6});
    expect(iset.skipWhile((int? v) => v! < 100), <int>{});
  });

  test("take", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.take(0), <int>{});
    expect(iset.take(1), {1});
    expect(iset.take(3), {1, 2, 3});
    expect(iset.take(5), {1, 2, 3, 4, 5});
    expect(iset.take(10), {1, 2, 3, 4, 5, 6});
  });

  test("takeWhile", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.takeWhile((int? v) => v! < 3), {1, 2});
    expect(iset.takeWhile((int? v) => v! < 5), {1, 2, 3, 4});
    expect(iset.takeWhile((int? v) => v! < 6), {1, 2, 3, 4, 5});
    expect(iset.takeWhile((int? v) => v! < 100), {1, 2, 3, 4, 5, 6});
  });

  test("toList", () {
    // 1) Regular usage
    ISet<int> iset = {1, 10, 11}.lock.add(4).addAll({5, 6});
    expect(iset.toList()..add(7), [1, 10, 11, 4, 5, 6, 7]);
    expect(iset, [1, 10, 11, 4, 5, 6]);

    // 2) With compare
    expect({1, 2, 3}.lock.add(10).add(5).toList(compare: (int a, int b) => -a.compareTo(b)),
        [10, 5, 3, 2, 1]);

    // 3) Unsupported operation
    iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(() => iset.toList(growable: false)..add(7), throwsUnsupportedError);

    // 4) With Config: sort
    iset = {1, 10, 11}.lock.add(4).addAll({5, 6});
    ISet<int> isetWithSort = iset.withConfig(ConfigSet(sort: true));
    expect(isetWithSort.toList(), [1, 4, 5, 6, 10, 11]);
  });

  test("toIList", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toIList(), IList([1, 2, 3, 4, 5, 6]));
  });

  test("toSet", () {
    ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(iset, [1, 2, 3, 4, 5, 6]);

    // 2) With compare
    final Set<int> set = {1, 2, 3, 10, 5}.lock.toSet(compare: (int a, int b) => -a.compareTo(b));
    expect(set, allOf(isA<LinkedHashSet>(), {1, 2, 3, 5, 10}));
    expect(set.toList(), [10, 5, 3, 2, 1]);
  });

  test("where", () {
    final ISet<int> iset = {1, 2, 3}.lock.add(4).addAll({5, 6});
    expect(iset.where((int? v) => v! < 0), <int>{});
    expect(iset.where((int? v) => v! < 3), {1, 2});
    expect(iset.where((int? v) => v! < 5), {1, 2, 3, 4});
    expect(iset.where((int? v) => v! < 100), {1, 2, 3, 4, 5, 6});
  });

  test("whereType", () {
    expect((<num>{1, 2, 1.5}.lock.whereType<double>()), {1.5});
  });

  test("toString", () {
    // 1) Global configuration prettyPrint == false
    ImmutableCollection.prettyPrint = false;
    expect({}.lock.toString(), "{}");
    expect({1}.lock.toString(), "{1}");
    expect({1, 10, 3}.lock.toString(), "{1, 10, 3}");

    // 2) Global configuration prettyPrint == true
    ImmutableCollection.prettyPrint = true;
    expect({}.lock.toString(), "{}");
    expect({1}.lock.toString(), "{1}");
    expect(
        {1, 10, 3}.lock.toString(),
        "{\n"
        "   1,\n"
        "   10,\n"
        "   3\n"
        "}");

    // 3) Local prettyPrint = false
    ImmutableCollection.prettyPrint = true;
    expect({}.lock.toString(false), "{}");
    expect({1}.lock.toString(false), "{1}");
    expect({1, 10, 3}.lock.toString(false), "{1, 10, 3}");

    // 4) Local prettyPrint = true
    ImmutableCollection.prettyPrint = false;
    expect({}.lock.toString(true), "{}");
    expect({1}.lock.toString(true), "{1}");
    expect(
        {1, 10, 3}.lock.toString(true),
        "{\n"
        "   1,\n"
        "   10,\n"
        "   3\n"
        "}");
  });

  test("unlockView", () {
    expect({1, 2, 3}.lock.unlockView,
        allOf(isA<UnmodifiableSetFromISet<int>>(), isA<Set<int>>(), {1, 2, 3}));
  });

  test("unlockLazy", () {
    expect({1, 2, 3}.lock.unlockLazy,
        allOf(isA<ModifiableSetFromISet<int>>(), isA<Set<int>>(), {1, 2, 3}));
  });

  test("iterator", () {
    ISet<int> iset = {2, 5, 3, 7, 9, 6, 1}.lock;
    expect(iset.config.sort, isFalse);

    // The regular iterator is NOT SORTED.
    expect(iset.iterator.toList(), [2, 5, 3, 7, 9, 6, 1]);

    // The for loop uses the UNSORTED iterator (if the config says so).
    var result = [];
    for (int? value in iset) result.add(value);
    expect(result, [2, 5, 3, 7, 9, 6, 1]);

    // But you can configure the set to sort the iterator.
    iset = iset.withConfig(const ConfigSet(sort: true));
    expect(iset.config.sort, isTrue);
    expect(iset.iterator.toList(), [1, 2, 3, 5, 6, 7, 9]);
    result = [];
    for (int? value in iset) result.add(value);
    expect(result, [1, 2, 3, 5, 6, 7, 9]);
  });

  test("ISet of MapEntry gets special treatment", () {
    final ISet<MapEntry<String, int>> iSet1 = ISet([MapEntry("a", 1)]).withDeepEquals,
        iSet2 = ISet([MapEntry("a", 1)]).withDeepEquals;

    expect(iSet1, iSet2);
  });

  test("toggle", () {
    // 1) Toggling an existing element
    ISet<int> iset = {1, 2, 3}.lock;
    expect(iset.contains(3), isTrue);

    iset = iset.toggle(3);
    expect(iset.contains(3), isFalse);

    iset = iset.toggle(3);
    expect(iset.contains(3), isTrue);

    // 2) Toggling an nonexistent element
    iset = {1, 2, 3}.lock;
    expect(iset.contains(4), isFalse);

    iset = iset.toggle(4);
    expect(iset.contains(4), isTrue);

    iset = iset.toggle(4);
    expect(iset.contains(4), isFalse);

    // 2) With sort
    iset = <int>{}
        .lock
        .withConfig(ConfigSet(sort: true))
        .toggle(1)
        .toggle(20)
        .toggle(3)
        .toggle(2)
        .toggle(10)
        .toggle(20);

    expect(iset.config, ConfigSet(sort: true));

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 2);
    expect(iset.elementAt(2), 3);
    expect(iset.elementAt(3), 10);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(4), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 2);
    expect(iset[2], 3);
    expect(iset[3], 10);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[4], throwsRangeError);
  });

  test("elementAt | []", () {
    // 1) Regular usage
    ISet<int> iset = {1, 20, 3}.lock;

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 20);
    expect(iset.elementAt(2), 3);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(3), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 20);
    expect(iset[2], 3);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[3], throwsRangeError);
  });

  test("clear", () {
    final ISet<int> iset = ISet.withConfig({1, 2, 3}, ConfigSet(isDeepEquals: false));

    final ISet<int> iSetCleared = iset.clear();

    expect(iSetCleared, allOf(isA<ISet<int>>(), <int>{}));
    expect(iSetCleared.config.isDeepEquals, isFalse);
  });

  test("containsAll", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;
    expect(iset.containsAll([2, 2, 3]), isTrue);
    expect(iset.containsAll({1, 2, 3, 4}), isTrue);
    expect(iset.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(iset.containsAll({1, 2, 3, 4, 10}.lock), isFalse);
    expect(iset.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;
    expect(iset.difference({1, 2, 5}), {3, 4});
    expect(iset.difference({1, 2, 3, 4}), <int>{});
  });

  test("intersection", () {
    final ISet<int> iset = {1, 2, 3, 4}.lock;
    expect(iset.intersection({1, 2, 5}), {1, 2});
    expect(iset.intersection({10, 20, 50}), <int>{});
  });

  test("union", () {
    final ISet<int> iSet = {1, 2, 3, 4}.lock;
    expect(iSet.union({1}), {1, 2, 3, 4});
    expect(iSet.union({1, 2, 5}), {1, 2, 3, 4, 5});

    // With sort == true
    final ISet<int> iset = <int>{1, 20, 3}.lock.withConfig(ConfigSet(sort: true)).union({10, 4});

    expect(iset.config, ConfigSet(sort: true));

    expect(iset.elementAt(0), 1);
    expect(iset.elementAt(1), 3);
    expect(iset.elementAt(2), 4);
    expect(iset.elementAt(3), 10);
    expect(iset.elementAt(4), 20);
    expect(() => iset.elementAt(-1), throwsRangeError);
    expect(() => iset.elementAt(5), throwsRangeError);

    expect(iset[0], 1);
    expect(iset[1], 3);
    expect(iset[2], 4);
    expect(iset[3], 10);
    expect(iset[4], 20);
    expect(() => iset[-1], throwsRangeError);
    expect(() => iset[5], throwsRangeError);
  });

  test("lookup", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.lookup(1), 1);
    expect(iSet1.lookup(10), isNull);
  });

  test("removeAll", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.removeAll({}), {1, 2, 3, 4});
    expect(iSet1.removeAll({2, 3}), {1, 4});
  });

  test("removeWhere", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.removeWhere((int? element) => element! > 10), {1, 2, 3, 4});
    expect(iSet1.removeWhere((int? element) => element! > 2), {1, 2});
  });

  test("retainAll", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.retainAll({}), <int>{});
    expect(iSet1.retainAll({2, 3}), {2, 3});
  });

  test("retainWhere", () {
    final ISet<int> iSet1 = {1, 2, 3, 4}.lock;
    expect(iSet1.retainWhere((int? element) => element! > 10), <int>{});
    expect(iSet1.retainWhere((int? element) => element! < 2), <int>{1});
  });

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

  test("flushFactor", () {
    // 1) Default value
    expect(ISet.flushFactor, 50);

    // 2) Setter
    ISet.flushFactor = 200;
    expect(ISet.flushFactor, 200);

    // 3) Can't be smaller than or equal to 0
    expect(() => ISet.flushFactor = 0, throwsStateError);
    expect(() => ISet.flushFactor = -100, throwsStateError);
  });

  test("iter (to get a simple Iterable)", () {
    //
    var set = <int?>{1, 2, 3, 4, 5, 6, 7};
    var iset = set.lock;

    // -------------

    // 1) Set methods that return an Iterable do lazy processing.

    int count1 = 0;

    var iterableFromList = set.where((x) {
      count1++;
      return x != null;
    }).take(3);

    // Only 3 (not 7) because we're doing it lazily.
    iterableFromList.join();
    expect(count1, 3);

    // Now it's 6 (= 3+3) because we did it lazily AGAIN.
    iterableFromList.join();
    expect(count1, 6);

    // -------------

    // 2) ISet methods that return an Iterable do lazy processing.

    int count2 = 0;

    var iterableFromIList = iset.where((x) {
      count2++;
      return x != null;
    }).take(3);

    // Only 3 (not 7) because we're doing it lazily.
    iterableFromIList.join();
    expect(count2, 3);

    // Now it's 6 (= 3+3) because we did it lazily AGAIN.
    iterableFromIList.join();
    expect(count2, 6);

    // -------------
  });

  test("Reuse ISets only if they have the exact same generic type.", () {
    //
    // Reuse? No!
    final ISet<int> iset1 = {1, 2}.lock;
    final ISet<num> iset2 = ISet<num>(iset1);
    expect(iset1.runtimeType.toString().endsWith("<int>"), isTrue);
    expect(iset2.runtimeType.toString().endsWith("<num>"), isTrue);
    expect(identical(iset1, iset2), isFalse);

    // Reuse? Yes!
    ISet<num> iset3 = <num>{1, 2}.lock;
    ISet<num> iset4 = ISet<num>(iset3);
    expect(identical(iset3, iset4), isTrue);

    // Reuse? Yes!
    ISet<int> iset5 = {1, 2}.lock;
    ISet<int> iset6 = ISet<int>(iset5);
    expect(identical(iset5, iset6), isTrue);

    // Reuse? Yes!
    ISet<int> iset7 = {1, 2}.lock;
    ISet<int> iset8 = ISet(iset7);
    expect(identical(iset7, iset8), isTrue);
  });

  test("Testing SAddAll.difference, SAdd.difference, and SFlat.difference", () {
    //
    expect((<int>{}.lock.addAll({1}.lock)).difference({}), {1});
    expect((<int>{}.lock.add(1)).difference({}), {1});
    expect(<int>{1}.difference({}), {1});

    expect((<int>{1}.lock.addAll({2}.lock)).difference({}), {1, 2});
    expect((<int>{1}.lock.add(2)).difference({}), {1, 2});
    expect(<int>{1, 2}.difference({}), {1, 2});

    expect((<int>{1}.lock.addAll({2}.lock)).difference({3, 4}), {1, 2});
    expect((<int>{1}.lock.add(2)).difference({3, 4}), {1, 2});
    expect(<int>{1, 2}.difference({3, 4}), {1, 2});

    expect((<int>{1}.lock.addAll({2}.lock)).difference({1}), {2});
    expect((<int>{1}.lock.add(2)).difference({1}), {2});
    expect(<int>{1, 2}.difference({1}), {2});

    expect((<int>{1}.lock.addAll({2}.lock)).difference({2, 1}), <int>{});
    expect((<int>{1}.lock.add(2)).difference({2, 1}), <int>{});
    expect(<int>{1, 2}.difference({2, 1}), <int>{});
  });

  test("Testing SAddAll.intersection, SAdd.intersection, and SFlat.intersection", () {
    //
    expect((<int>{}.lock.addAll(<int>{}.lock)).intersection({}), <int>{});
    expect(<int>{}.intersection({}), <int>{});

    expect((<int>{}.lock.addAll({1}.lock)).intersection({}), <int>{});
    expect((<int>{}.lock.add(1)).intersection({}), <int>{});
    expect(<int>{1}.intersection({}), <int>{});

    expect((<int>{}.lock.addAll({1}.lock)).intersection({1}), {1});
    expect((<int>{}.lock.add(1)).intersection({1}), {1});
    expect(<int>{1}.intersection({1}), {1});

    expect((<int>{1}.lock.addAll({2}.lock)).intersection({}), <int>{});
    expect((<int>{1}.lock.add(2)).intersection({}), <int>{});
    expect(<int>{1, 2}.intersection({}), <int>{});

    expect((<int>{1}.lock.addAll({2}.lock)).intersection({3, 4}), <int>{});
    expect((<int>{1}.lock.add(2)).intersection({3, 4}), <int>{});
    expect(<int>{1, 2}.intersection({3, 4}), <int>{});

    expect((<int>{1}.lock.addAll({2}.lock)).intersection({2, 4}), {2});
    expect((<int>{1}.lock.add(2)).intersection({2, 4}), {2});
    expect(<int>{1, 2}.intersection({2, 4}), {2});
  });

  test("Testing SAddAll.union, SAdd.union, and SFlat.union", () {
    //
    expect((<int>{}.lock.addAll(<int>{}.lock)).union({}), <int>{});
    expect(<int>{}.union({}), <int>{});

    expect((<int>{}.lock.addAll({1}.lock)).union({}), {1});
    expect((<int>{}.lock.add(1)).union({}), {1});
    expect(<int>{}.union({1}), {1});

    expect((<int>{1}.lock.addAll({2}.lock)).union({}), {1, 2});
    expect((<int>{1}.lock.add(2)).union({}), {1, 2});
    expect(<int>{1}.union({2}), {1, 2});

    expect((<int>{1, 3}.lock.addAll({2, 4}.lock)).union({}), {1, 3, 2, 4});
    expect((<int>{1, 3}.lock.add(2).add(4)).union({}), {1, 3, 2, 4});
    expect(<int>{1, 3}.union({2, 4}), {1, 3, 2, 4});
  });
}
