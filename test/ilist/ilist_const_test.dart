// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: non_const_call_to_literal_constructor
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(const IListConst([]), isA<IListConst>());
    expect(const IListConst([]), isA<IListConst>());
    expect(const IListConst<String>([]), isA<IListConst<String>>());
    expect(const IListConst([1]), isA<IListConst<int>>());
    expect(const IListConst<int>([]), isA<IListConst<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(const IListConst([]), isEmpty);
    expect(const IListConst([]).isEmpty, isTrue);
    expect(const IListConst([]).isNotEmpty, isFalse);

    expect(const IListConst<String>([]).isEmpty, isTrue);
    expect(const IListConst<String>([]).isNotEmpty, isFalse);

    expect(const IListConst([1]), isNotEmpty);
    expect(const IListConst([1]).isEmpty, isFalse);
    expect(const IListConst([1]).isNotEmpty, isTrue);

    expect(const IListConst<int>([]), isEmpty);
    expect(const IListConst<int>([]).isEmpty, isTrue);
    expect(const IListConst<int>([]).isNotEmpty, isFalse);
  });

  test("hashCode", () {
    expect(const IListConst([]) == const IListConst([]), isTrue);
    expect(IList() == IList(), isTrue);
    expect(const IListConst([]) == IList(), isTrue);
    expect(const IListConst([]) == IList([]), isTrue);
    expect(IList() == const IListConst([]), isTrue);
    expect(IList([]) == const IListConst([]), isTrue);

    expect(const IListConst([1, 2]) == const IListConst([1, 2]), isTrue);
    expect(IList([1, 2]) == IList([1, 2]), isTrue);
    expect(const IListConst([1, 2]) == IList([1, 2]), isTrue);
    expect(IList([1, 2]) == const IListConst([1, 2]), isTrue);

    var a = IList<int>(<int>[]);
    var b = const IListConst<String>(<String>[]);
    expect(a, b);
    expect(a.hashCode, b.hashCode);

    var x = IList([1, 2, 3]);
    var y = IList([1, 2]).add(3);
    expect(x, y);
    expect(x.hashCode, y.hashCode);
  });

  test("withConfig", () {
    // 1) Regular usage
    const IList<int> ilist = IListConst([1, 2]);

    expect(ilist.isDeepEquals, isTrue);

    IList<int> iListNewConfig = ilist.withConfig(ilist.config.copyWith());

    IList<int> iListNewConfigIdentity =
        ilist.withConfig(ilist.config.copyWith(isDeepEquals: false));

    expect(iListNewConfig.isDeepEquals, isTrue);
    expect(iListNewConfigIdentity.isDeepEquals, isFalse);

    // 2) With empty list and different configs.
    const List<int> emptyList = <int>[];
    expect(const IListConst(emptyList, ConfigList(cacheHashCode: false)), []);

    // 3) With non-empty list and different configs.
    const List<int> nonemptyList = <int>[1, 2, 3];
    expect(const IListConst(nonemptyList, ConfigList(cacheHashCode: false)), [1, 2, 3]);
  });

  test("unlock", () {
    const ilistConst = IListConst([1, 2, 3]);
    expect(ilistConst.unlock, [1, 2, 3]);
    expect(ilistConst.unlock..add(4), [1, 2, 3, 4]);

    expect(ilistConst.unlockLazy, [1, 2, 3]);
    expect(ilistConst.unlockLazy..add(4), [1, 2, 3, 4]);

    expect(ilistConst.unlockView, [1, 2, 3]);
    expect(() => ilistConst.unlockView..add(4), throwsUnsupportedError);
  });

  test("flush", () {
    const ilistConst = IListConst([1, 2, 3]);
    expect(ilistConst.isFlushed, isTrue);
    ilistConst.flush;
    expect(ilistConst.isFlushed, isTrue);
    expect(ilistConst.unlock, [1, 2, 3]);
  });

  test("add/addAll, remove/removeAll", () {
    const ilistConst = IListConst([1, 2, 3]);
    expect(ilistConst.add(4), [1, 2, 3, 4]);
    expect(ilistConst.addAll([4, 5, 6]), [1, 2, 3, 4, 5, 6]);
    expect(ilistConst.remove(2), [1, 3]);
    expect(ilistConst.removeAll([1, 2]), [3]);
  });

  test("IListConst", () {
    //
    // The default constructor will always use the same const [] internals.
    expect(const IListConst([]).same(const IListConst([])), isTrue);
    expect(const IListConst([]).same(IListConst([])), isFalse);
    expect(const IListConst([]).same(const IListConst([])), isTrue);
    expect(IListConst([]).same(IListConst([])), isFalse);

    // ---

    // Both IListConst are const. So they are the same.
    expect(const IListConst([]).same(const IListConst([])), isTrue);

    // One of the IListConst is const, the other is not. So they are NOT the same.
    expect(const IListConst([]).same(IListConst([])), isFalse);
    expect(IListConst([]).same(const IListConst([])), isFalse);

    // None of the IListConst are const. So they are NOT the same.
    expect(IListConst([]).same(IListConst([])), isFalse);

    // ---

    // Both IListConst are const. So they are the same.
    expect(const IListConst([1, 2, 3]).same(const IListConst([1, 2, 3])), isTrue);

    // One of the IListConst is const, the other is not. So they are NOT the same.
    expect(const IListConst([1, 2, 3]).same(IListConst([1, 2, 3])), isFalse);
    expect(IListConst([1, 2, 3]).same(const IListConst([1, 2, 3])), isFalse);

    // None of the IListConst are const. So they are NOT the same.
    expect(IListConst([1, 2, 3]).same(IListConst([1, 2, 3])), isFalse);
  });

  test("Interaction between IList and IListConst", () {
    //
    // Empty.
    expect(IListConst([]).same(IList()), isFalse);
    expect(IListConst([]).same(IList()), isFalse);
    expect(IList().same(IListConst([])), isFalse);
    expect(IList().same(IListConst([])), isFalse);
    expect(IList().same(IListConst([])), isFalse);
    expect(IList().same(IListConst([])), isFalse);
    expect(const IListConst([]).same(IList()), isFalse);
    expect(const IListConst([]).same(IList()), isFalse);
    expect(IList().same(const IListConst([])), isFalse);
    expect(IList().same(const IListConst([])), isFalse);
    expect(IList().same(const IListConst([])), isFalse);
    expect(IList().same(const IListConst([])), isFalse);

    // Not Empty.
    expect(IList([1, 2]).same(IListConst([1, 2])), isFalse);
    expect(IListConst([1, 2]).same(IList([1, 2])), isFalse);
    expect(IList([1, 2]).same(const IListConst([1, 2])), isFalse);
    expect(const IListConst([1, 2]).same(IList([1, 2])), isFalse);

    // equalItems
    expect(IList([]).equalItems(IListConst([])), isTrue);
    expect(IList([]).equalItems(const IListConst([])), isTrue);
    expect(IList().equalItems(const IListConst([])), isTrue);
    expect(IList().equalItems(IListConst([])), isTrue);
    expect(IList([1, 2]).equalItems(IListConst([1, 2])), isTrue);
    expect(IListConst([1, 2]).equalItems(IList([1, 2])), isTrue);
    expect(IList([1, 2]).equalItems(const IListConst([1, 2])), isTrue);
    expect(const IListConst([1, 2]).equalItems(IList([1, 2])), isTrue);

    // equalItemsAndConfig
    expect(IList([]).equalItemsAndConfig(IListConst([])), isTrue);
    expect(IList([]).equalItemsAndConfig(const IListConst([])), isTrue);
    expect(IList().equalItemsAndConfig(const IListConst([])), isTrue);
    expect(IList().equalItemsAndConfig(IListConst([])), isTrue);
    expect(IList([1, 2]).equalItemsAndConfig(IListConst([1, 2])), isTrue);
    expect(IListConst([1, 2]).equalItemsAndConfig(IList([1, 2])), isTrue);
    expect(IList([1, 2]).equalItemsAndConfig(const IListConst([1, 2])), isTrue);
    expect(const IListConst([1, 2]).equalItemsAndConfig(IList([1, 2])), isTrue);

    // unorderedEqualItems
    expect(IList([]).unorderedEqualItems(IListConst([])), isTrue);
    expect(IList([]).unorderedEqualItems(const IListConst([])), isTrue);
    expect(IList().unorderedEqualItems(const IListConst([])), isTrue);
    expect(IList().unorderedEqualItems(IListConst([])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems(IListConst([1, 2])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems(IListConst([2, 1])), isTrue);
    expect(IListConst([1, 2]).unorderedEqualItems(IList([1, 2])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems(const IListConst([1, 2])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems(const IListConst([2, 1])), isTrue);
    expect(const IListConst([1, 2]).unorderedEqualItems(IList([1, 2])), isTrue);
    expect(const IListConst([1, 2]).unorderedEqualItems(IList([2, 1])), isTrue);
  });

  test("Make sure the internal list is List<int>, and not List<Never>", () {
    var l1 = const IListConst<int>([]);
    expect(l1.runtimeType.toString(), 'IListConst<int>');

    var l2 = IList<int>([1, 2, 3]);
    expect(l2.runtimeType.toString(), 'IListImpl<int>');

    var l3 = l1.addAll(l2);
    expect(l3.runtimeType.toString(), 'IListImpl<int>');

    var result = l3.where((int i) => i == 2).toList();
    expect(result, [2]);
  });

  test("Test we can cast from IListConst<Never>, when using FromIListMixin.", () {
    MyList<int> myList1 = MyList.empty();
    myList1 = myList1.add(1);
    expect(myList1, [1]);

    MyList<int> myList2 = MyList.empty();
    myList2 = myList2.addAll([1, 2, 3]);
    expect(myList2, [1, 2, 3]);
  });
}

class MyList<A extends num> with FromIListMixin<A, MyList<A>> implements Iterable<A> {
  final IList<A> numbs;

  MyList([Iterable<A>? activities]) : numbs = IList(activities);

  const MyList.empty() : numbs = const IListConst([]);

  @override
  MyList<A> newInstance(IList<A> ilist) => MyList<A>(ilist);

  @override
  IList<A> get iter => numbs;
}
