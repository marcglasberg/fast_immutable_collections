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
    expect(const IMap.empty(), isA<IMapEmpty>());
    expect(const IMap.empty(), isA<IMapEmpty>());
    expect(const IMap<String, String>.empty(), isA<IMapEmpty<String, String>>());
    expect(const IMap<int, String>.empty(), isA<IMap<int, String>>());

    expect(const IMap.empty(), isA<IMap>());
    expect(const IMap.empty(), isA<IMap>());
    expect(const IMap<String, String>.empty(), isA<IMap<String, String>>());
    expect(const IMap<int, String>.empty(), isA<IMap<int, String>>());
  });

  test("Make sure the IMapEmpty can be modified and later iterated", () {
    // MAddAll
    IMap<String, int> map = const IMap.empty();
    map = map.addEntries([const MapEntry("a", 1), const MapEntry("b", 2), const MapEntry("c", 3)]);
    map.forEach((_, __) {});

    // MAdd
    map = const IMap.empty();
    map = map.add("d", 4);
    map.forEach((_, __) {});

    // MReplace
    map = const IMap.empty();
    map = map.add("d", 42);
    map.forEach((_, __) {});
  });

  test("Make sure the internal map is Map<int, String>, and not Map<Never>", () {
    const m1 = IMap<String, int>.empty();
    expect(m1.runtimeType.toString(), 'IMapEmpty<String, int>');

    const m2 = IMapConst<String, int>({'a': 1, 'b': 2, 'c': 3});
    expect(m2.runtimeType.toString(), 'IMapConst<String, int>');

    final m3 = m1.addAll(m2);
    expect(m3.runtimeType.toString(), 'IMapImpl<String, int>');

    final result = m3.where((String key, int value) => value == 2);
    expect(result, {'b': 2}.lock);
  });

  test(".same() is working properly", () {
    expect(const IMap.empty().same(const IMap.empty()), isTrue);
    expect(const IMap.empty().same(const IMap.empty()), isTrue);
    expect(const IMap.empty().same(const IMapConst({})), isTrue);
    expect(const IMapConst({}).same(const IMap.empty()), isTrue);
    expect(const IMapConst({}).hashCode, const IMap.empty().hashCode);
  });

  test("equality", () {
    // equalItems
    expect(IMap({1: "a", 2: "b"}).equalItems(const IMap.empty().entries), isFalse);
    expect(const IMapConst({1: "a", 2: "b"}).equalItems(const IMap.empty().entries), isFalse);

    expect(IMap().equalItems(const IMap.empty().entries), isTrue);
    expect(const IMapConst({}).equalItems(const IMap.empty().entries), isTrue);
    expect(const IMap.empty().equalItems(const IMap.empty().entries), isTrue);

    // equalItemsAndConfig
    expect(IMap({1: "a", 2: "b"}).equalItemsAndConfig(const IMap.empty()), isFalse);
    expect(const IMapConst({1: "a", 2: "b"}).equalItemsAndConfig(const IMap.empty()), isFalse);

    expect(IMap().equalItemsAndConfig(const IMap.empty()), isTrue);
    expect(const IMapConst({}).equalItemsAndConfig(const IMap.empty()), isTrue);
    expect(const IMap.empty().equalItemsAndConfig(const IMap.empty()), isTrue);
  });

  test("isEmpty | isNotEmpty", () {
    expect(const IMap.empty().isEmpty, isTrue);
    expect(const IMap.empty().isNotEmpty, isFalse);
  });

  test("contains | -Key | -Value | -Entry", () {
    expect(const IMap.empty().contains(Object(), Object()), isFalse);
    expect(const IMap.empty().contains(null, null), isFalse);

    expect(const IMap.empty().containsKey(Object()), isFalse);
    expect(const IMap.empty().containsKey(null), isFalse);

    expect(const IMap.empty().containsValue(Object()), isFalse);
    expect(const IMap.empty().containsValue(null), isFalse);

    expect(const IMap.empty().containsEntry(const MapEntry(Object(), Object())), isFalse);
    expect(const IMap.empty().containsEntry(const MapEntry(null, null)), isFalse);
  });

  test("length", () {
    expect(const IMap.empty().length, 0);
  });

  test("clear()", () {
    const list = IMap.empty();
    expect(identical(list, list.clear()), isTrue);
  });
}
