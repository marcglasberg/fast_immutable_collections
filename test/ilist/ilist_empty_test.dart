// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  test("Runtime Type", () {
    expect(const IList.empty(), isA<IListEmpty>());
    expect(const IList.empty(), isA<IListEmpty>());
    expect(const IList<String>.empty(), isA<IListEmpty<String>>());
    expect(const IList<int>.empty(), isA<IListEmpty<int>>());

    expect(const IList.empty(), isA<IList>());
    expect(const IList.empty(), isA<IList>());
    expect(const IList<String>.empty(), isA<IList<String>>());
    expect(const IList<int>.empty(), isA<IList<int>>());
  });

  test("Make sure the IListEmpty can be modified and later iterated", () {
    // LAddAll
    IList<String> list = const IList.empty();
    list = list.addAll(["a", "b", "c"]);
    list.forEach((_) {});

    // LAdd
    list = const IList.empty();
    list = list.add("d");
    list.forEach((_) {});
  });

  test("Make sure the internal list is List<int>, and not List<Never>", () {
    const l1 = IList<int>.empty();
    expect(l1.runtimeType.toString(), 'IListEmpty<int>');

    const l2 = IListConst<int>([1, 2, 3]);
    expect(l2.runtimeType.toString(), 'IListConst<int>');

    final l3 = l1.addAll(l2);
    expect(l3.runtimeType.toString(), 'IListImpl<int>');

    final result = l3.where((int i) => i == 2).toList();
    expect(result, [2]);
  });

  test(".same() is working properly", () {
    expect(const IList.empty().same(const IList.empty()), isTrue);
    expect(const IList.empty().same(const IList.empty()), isTrue);
    expect(const IList.empty().same(const IListConst([])), isTrue);
    expect(const IListConst([]).same(const IList.empty()), isTrue);
    expect(const IListConst([]).hashCode, const IList.empty().hashCode);
  });

  test("equality", () {
    // equalItems
    expect(IList(["a", "b"]).equalItems(const IList.empty()), isFalse);
    expect(const IListConst(["a", "b"]).equalItems(const IList.empty()), isFalse);

    expect(IList().equalItems(const IList.empty()), isTrue);
    expect(const IListConst([]).equalItems(const IList.empty()), isTrue);
    expect(const IList.empty().equalItems(const IList.empty()), isTrue);
    expect(const IList.empty().equalItems(const IList.empty()), isTrue);

    // equalItemsAndConfig
    expect(IList(["a", "b"]).equalItemsAndConfig(const IList.empty()), isFalse);
    expect(const IListConst(["a", "b"]).equalItemsAndConfig(const IList.empty()), isFalse);

    expect(IList().equalItemsAndConfig(const IList.empty()), isTrue);
    expect(const IListConst([]).equalItemsAndConfig(const IList.empty()), isTrue);
    expect(const IList.empty().equalItemsAndConfig(const IList.empty()), isTrue);
    expect(const IList.empty().equalItemsAndConfig(const IList.empty()), isTrue);
  });

  test("isEmpty | isNotEmpty", () {
    expect(const IList.empty().isEmpty, isTrue);
    expect(const IList.empty().isNotEmpty, isFalse);
  });

  test("contains", () {
    expect(const IList.empty().contains(Object()), isFalse);
    expect(const IList.empty().contains(null), isFalse);
  });

  test("length", () {
    expect(const IList.empty().length, 0);
  });

  test("fist | last | single", () {
    expect(() => const IList.empty().first, throwsStateError);
    expect(() => const IList.empty().last, throwsStateError);
    expect(() => const IList.empty().single, throwsStateError);
  });

  test("reversed", () {
    const list = IList.empty();
    expect(identical(list, list.reversed), isTrue);
  });

  test("clear()", () {
    const list = IList.empty();
    expect(identical(list, list.clear()), isTrue);
  });
}
