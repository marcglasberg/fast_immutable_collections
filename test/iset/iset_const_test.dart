// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: non_const_call_to_literal_constructor
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(const ISetConst({}), isA<ISetConst>());
    expect(const ISetConst({}), isA<ISetConst>());
    expect(const ISetConst<String>({}), isA<ISetConst<String>>());
    expect(const ISetConst({1}), isA<ISetConst<int>>());
    expect(const ISetConst<int>({}), isA<ISetConst<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(ISetConst({}).isEmpty, isTrue);
    expect(ISetConst({}).isNotEmpty, isFalse);

    expect(ISetConst<String>({}).isEmpty, isTrue);
    expect(ISetConst<String>({}).isNotEmpty, isFalse);

    expect(ISetConst({1}).isEmpty, isFalse);
    expect(ISetConst({1}).isNotEmpty, isTrue);

    expect(ISetConst<int>({}).isEmpty, isTrue);
    expect(ISetConst<int>({}).isNotEmpty, isFalse);
  });

  test("hashCode", () {
    expect(const ISetConst({}) == const ISetConst({}), isTrue);
    expect(ISet() == ISet(), isTrue);
    expect(const ISetConst({}) == ISet(), isTrue);
    expect(const ISetConst({}) == ISet({}), isTrue);
    expect(ISet() == const ISetConst({}), isTrue);
    expect(ISet({}) == const ISetConst({}), isTrue);

    expect(const ISetConst({1, 2}) == const ISetConst({1, 2}), isTrue);
    expect(ISet({1, 2}) == ISet({1, 2}), isTrue);
    expect(const ISetConst({1, 2}) == ISet({1, 2}), isTrue);
    expect(ISet({1, 2}) == const ISetConst({1, 2}), isTrue);

    var a = ISet<int>(<int>{});
    var b = const ISetConst<String>(<String>{});
    expect(a, b);
    expect(a.hashCode, b.hashCode);

    var x = ISet({1, 2, 3});
    var y = ISet({1, 2}).add(3);
    expect(x, y);
    expect(x.hashCode, y.hashCode);
  });

  test("withConfig", () {
    // 1) Regular usage
    final ISet<int> iset = ISetConst({1, 2});

    expect(iset.isDeepEquals, isTrue);

    ISet<int> iSetNewConfig = iset.withConfig(iset.config.copyWith());

    ISet<int> iSetNewConfigIdentity = iset.withConfig(iset.config.copyWith(isDeepEquals: false));

    expect(iSetNewConfig.isDeepEquals, isTrue);
    expect(iSetNewConfigIdentity.isDeepEquals, isFalse);

    // 2) With non-empty set, non-sorted configs.
    const Set<int> nonemptySet = <int>{1, 2, 3};
    expect(const ISetConst(nonemptySet, ConfigSet(isDeepEquals: false)), [1, 2, 3]);

    // 3) With empty set and different configs.
    const Set<int> emptySet = <int>{};
    const sortedEmptyConstISet = ISetConst(emptySet, ConfigSet(sort: true));
    expect(sortedEmptyConstISet, isEmpty);

    // 4) With non-empty set, sorted configs. We can actually create a sorted const ISet,
    // but it will throw an error if we try to use it. Only EMPTY sorted const ISets
    // are allowed.
    const sortedConstISet = ISetConst(nonemptySet, ConfigSet(sort: true));
    expect(() => sortedConstISet, throwsUnsupportedError);
  });

  test("unlock", () {
    const isetConst = ISetConst({1, 2, 3});
    expect(isetConst.unlock, {1, 2, 3});
    expect(isetConst.unlock..add(4), [1, 2, 3, 4]);

    expect(isetConst.unlockLazy, {1, 2, 3});
    expect(isetConst.unlockLazy..add(4), [1, 2, 3, 4]);

    expect(isetConst.unlockView, {1, 2, 3});
    expect(() => isetConst.unlockView..add(4), throwsUnsupportedError);
  });

  test("flush", () {
    const isetConst = ISetConst({1, 2, 3});
    expect(isetConst.isFlushed, isTrue);
    isetConst.flush;
    expect(isetConst.isFlushed, isTrue);
    expect(isetConst.unlock, {1, 2, 3});
  });

  test("add/addAll, remove/removeAll", () {
    const isetConst = ISetConst({1, 2, 3});
    expect(isetConst.add(4), [1, 2, 3, 4]);
    expect(isetConst.addAll([4, 5, 6]), [1, 2, 3, 4, 5, 6]);
    expect(isetConst.remove(2), [1, 3]);
    expect(isetConst.removeAll({1, 2}), [3]);
  });

  test("ISetConst", () {
    //
    // The default constructor will always use the same const {} internals.
    expect(const ISetConst({}).same(const ISetConst({})), isTrue);
    expect(const ISetConst({}).same(ISetConst({})), isFalse);
    expect(const ISetConst({}).same(const ISetConst({})), isTrue);
    expect(ISetConst({}).same(ISetConst({})), isFalse);

    // ---

    // Both ISetConst are const. So they are the same.
    expect(const ISetConst({}).same(const ISetConst({})), isTrue);

    // One of the ISetConst is const, the other is not. So they are NOT the same.
    expect(const ISetConst({}).same(ISetConst({})), isFalse);
    expect(ISetConst({}).same(const ISetConst({})), isFalse);

    // None of the ISetConst are const. So they are NOT the same.
    expect(ISetConst({}).same(ISetConst({})), isFalse);

    // ---

    // Both ISetConst are const. So they are the same.
    expect(const ISetConst({1, 2, 3}).same(const ISetConst({1, 2, 3})), isTrue);

    // One of the ISetConst is const, the other is not. So they are NOT the same.
    expect(const ISetConst({1, 2, 3}).same(ISetConst({1, 2, 3})), isFalse);
    expect(ISetConst({1, 2, 3}).same(const ISetConst({1, 2, 3})), isFalse);

    // None of the ISetConst are const. So they are NOT the same.
    expect(ISetConst({1, 2, 3}).same(ISetConst({1, 2, 3})), isFalse);
  });

  test("Interaction between ISet and ISetConst", () {
    //
    // Empty.
    expect(ISetConst({}).same(ISet()), isFalse);
    expect(ISetConst({}).same(ISet()), isFalse);
    expect(ISet().same(ISetConst({})), isFalse);
    expect(ISet().same(ISetConst({})), isFalse);
    expect(ISet().same(ISetConst({})), isFalse);
    expect(ISet().same(ISetConst({})), isFalse);
    expect(const ISetConst({}).same(ISet()), isFalse);
    expect(const ISetConst({}).same(ISet()), isFalse);
    expect(ISet().same(const ISetConst({})), isFalse);
    expect(ISet().same(const ISetConst({})), isFalse);
    expect(ISet().same(const ISetConst({})), isFalse);
    expect(ISet().same(const ISetConst({})), isFalse);

    // Not Empty.
    expect(ISet({1, 2}).same(ISetConst({1, 2})), isFalse);
    expect(ISetConst({1, 2}).same(ISet({1, 2})), isFalse);
    expect(ISet({1, 2}).same(const ISetConst({1, 2})), isFalse);
    expect(const ISetConst({1, 2}).same(ISet({1, 2})), isFalse);

    // equalItems
    expect(ISet({}).equalItems(ISetConst({})), isTrue);
    expect(ISet({}).equalItems(const ISetConst({})), isTrue);
    expect(ISet().equalItems(const ISetConst({})), isTrue);
    expect(ISet().equalItems(ISetConst({})), isTrue);
    expect(ISet({1, 2}).equalItems(ISetConst({1, 2})), isTrue);
    expect(ISetConst({1, 2}).equalItems(ISet({1, 2})), isTrue);
    expect(ISet({1, 2}).equalItems(const ISetConst({1, 2})), isTrue);
    expect(const ISetConst({1, 2}).equalItems(ISet({1, 2})), isTrue);

    // equalItemsAndConfig
    expect(ISet({}).equalItemsAndConfig(ISetConst({})), isTrue);
    expect(ISet({}).equalItemsAndConfig(const ISetConst({})), isTrue);
    expect(ISet().equalItemsAndConfig(const ISetConst({})), isTrue);
    expect(ISet().equalItemsAndConfig(ISetConst({})), isTrue);
    expect(ISet({1, 2}).equalItemsAndConfig(ISetConst({1, 2})), isTrue);
    expect(ISetConst({1, 2}).equalItemsAndConfig(ISet({1, 2})), isTrue);
    expect(ISet({1, 2}).equalItemsAndConfig(const ISetConst({1, 2})), isTrue);
    expect(const ISetConst({1, 2}).equalItemsAndConfig(ISet({1, 2})), isTrue);

    // unorderedEqualItems
    expect(ISet({}).unorderedEqualItems(ISetConst({})), isTrue);
    expect(ISet({}).unorderedEqualItems(const ISetConst({})), isTrue);
    expect(ISet().unorderedEqualItems(const ISetConst({})), isTrue);
    expect(ISet().unorderedEqualItems(ISetConst({})), isTrue);
    expect(ISet({1, 2}).unorderedEqualItems(ISetConst({1, 2})), isTrue);
    expect(ISet({1, 2}).unorderedEqualItems(ISetConst({2, 1})), isTrue);
    expect(ISetConst({1, 2}).unorderedEqualItems(ISet({1, 2})), isTrue);
    expect(ISet({1, 2}).unorderedEqualItems(const ISetConst({1, 2})), isTrue);
    expect(ISet({1, 2}).unorderedEqualItems(const ISetConst({2, 1})), isTrue);
    expect(const ISetConst({1, 2}).unorderedEqualItems(ISet({1, 2})), isTrue);
    expect(const ISetConst({1, 2}).unorderedEqualItems(ISet([2, 1])), isTrue);
  });

  test("Make sure the internal set is Set<int>, and not Set<Never>", () {
    var l1 = const ISetConst<int>({});
    expect(l1.runtimeType.toString(), 'ISetConst<int>');

    var l2 = ISet<int>({1, 2, 3});
    expect(l2.runtimeType.toString(), 'ISetImpl<int>');

    var l3 = l1.addAll(l2);
    expect(l3.runtimeType.toString(), 'ISetImpl<int>');

    var result = l3.where((int i) => i == 2).toSet();
    expect(result, [2]);
  });

  test("Test we can cast from ISetConst<Never>, when using FromISetMixin.", () {
    MySet<int> mySet1 = MySet.empty();
    mySet1 = mySet1.add(1);
    expect(mySet1, [1]);

    MySet<int> mySet2 = MySet.empty();
    mySet2 = mySet2.addAll([1, 2, 3]);
    expect(mySet2, [1, 2, 3]);
  });
}

class MySet<A extends num> with FromISetMixin<A, MySet<A>> implements Iterable<A> {
  final ISet<A> numbs;

  MySet([Iterable<A>? activities]) : numbs = ISet(activities);

  const MySet.empty() : numbs = const ISetConst({});

  @override
  MySet<A> newInstance(ISet<A> iSet) => MySet<A>(iSet);

  @override
  ISet<A> get iter => numbs;
}
