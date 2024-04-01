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
    expect(const ISet.empty(), isA<ISetEmpty>());
    expect(const ISet.empty(), isA<ISetEmpty>());
    expect(const ISet<String>.empty(), isA<ISetEmpty<String>>());
    expect(const ISet<int>.empty(), isA<ISetEmpty<int>>());

    expect(const ISet.empty(), isA<ISet>());
    expect(const ISet.empty(), isA<ISet>());
    expect(const ISet<String>.empty(), isA<ISet<String>>());
    expect(const ISet<int>.empty(), isA<ISet<int>>());
  });

  test("Make sure the ISetEmpty can be modified and later iterated", () {
    // SAddAll
    ISet<String> set = const ISet.empty();
    set = set.addAll(["a", "b", "c"]);
    set.forEach((_) { });

    // SAdd
    set = const ISet.empty();
    set = set.add("d");
    set.forEach((_) { });
  });

  test("Make sure the internal set is Set<int>, and not Set<Never>", () {
    const s1 = ISet<int>.empty();
    expect(s1.runtimeType.toString(), 'ISetEmpty<int>');

    const s2 = ISetConst<int>({1, 2, 3});
    expect(s2.runtimeType.toString(), 'ISetConst<int>');

    final s3 = s1.addAll(s2);
    expect(s3.runtimeType.toString(), 'ISetImpl<int>');

    final result = s3.where((int i) => i == 2).toSet();
    expect(result, [2]);
  });

  test(".same() is working properly", () {
    expect(const ISet.empty().same(const ISet.empty()), isTrue);
    expect(const ISet.empty().same(const ISet.empty()), isTrue);
    expect(const ISet.empty().same(const ISetConst({})), isTrue);
    expect(const ISetConst({}).same(const ISet.empty()), isTrue);
    expect(const ISetConst({}).hashCode, const ISet.empty().hashCode);
  });

  test("equality", () {
    // equalItems
    expect(ISet({"a", "b"}).equalItems(const ISet.empty()), isFalse);
    expect(const ISetConst({"a", "b"}).equalItems(const ISet.empty()), isFalse);

    expect(ISet().equalItems(const ISet.empty()), isTrue);
    expect(const ISetConst({}).equalItems(const ISet.empty()), isTrue);
    expect(const ISet.empty().equalItems(const ISet.empty()), isTrue);


    // equalItemsAndConfig
    expect(ISet({"a", "b"}).equalItemsAndConfig(const ISet.empty()), isFalse);
    expect(const ISetConst({"a", "b"}).equalItemsAndConfig(const ISet.empty()), isFalse);

    expect(ISet().equalItemsAndConfig(const ISet.empty()), isTrue);
    expect(const ISetConst({}).equalItemsAndConfig(const ISet.empty()), isTrue);
    expect(const ISet.empty().equalItemsAndConfig(const ISet.empty()), isTrue);
  });

  test("isEmpty | isNotEmpty", () {
    expect(const ISet.empty().isEmpty, isTrue);
    expect(const ISet.empty().isNotEmpty, isFalse);
  });

  test("contains", () {
    expect(const ISet.empty().contains(Object()), isFalse);
    expect(const ISet.empty().contains(null), isFalse);
  });

  test("length", () {
    expect(const ISet.empty().length, 0);
  });

  test("fist | last | single", () {
    expect(() => const ISet.empty().first, throwsStateError);
    expect(() => const ISet.empty().last, throwsStateError);
    expect(() => const ISet.empty().single, throwsStateError);
  });

  test("clear()", () {
    const list = ISet.empty();
    expect(identical(list, list.clear()), isTrue);
  });
}
