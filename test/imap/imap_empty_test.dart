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
    expect(const IMapEmpty(), isA<IMapEmpty>());
    expect(const IMapEmpty(), isA<IMapEmpty>());
    expect(const IMapEmpty<String, String>(), isA<IMapEmpty<String, String>>());
    expect(const IMapEmpty<int, String>(), isA<IMapEmpty<int, String>>());

    expect(const IMapEmpty(), isA<IMap>());
    expect(const IMapEmpty(), isA<IMap>());
    expect(const IMapEmpty<String, String>(), isA<IMap<String, String>>());
    expect(const IMapEmpty<int, String>(), isA<IMap<int, String>>());
  });

  test("Make sure the IMapEmpty can be modified and later iterated", () {
    // MAddAll
    IMap<String, int> map = const IMap.empty();
    map = map.addEntries([
      const MapEntry("a", 1),
      const MapEntry("b", 2),
      const MapEntry("c", 3)
    ]);
    map.forEach((_, __) { });

    // MAdd
    map = const IMap.empty();
    map = map.add("d", 4);
    map.forEach((_, __) { });

    // MReplace
    map = const IMap.empty();
    map = map.add("d", 42);
    map.forEach((_, __) { });
  });

  test("Make sure the internal map is Map<int, String>, and not Map<Never>", () {
    const m1 = IMapEmpty<String, int>();
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
  });

  test("equality", () {
    // equalItems
    expect(IMap({1: "a", 2: "b"}).equalItems(const IMap.empty().entries), isFalse);
    expect(const IMapConst({1: "a", 2: "b"}).equalItems(const IMap.empty().entries), isFalse);

    expect(IMap().equalItems(const IMap.empty().entries), isTrue);
    expect(const IMapConst({}).equalItems(const IMap.empty().entries), isTrue);
    expect(const IMap.empty().equalItems(const IMap.empty().entries), isTrue);
    expect(const IMap.empty().equalItems(const IMapEmpty().entries), isTrue);


    // equalItemsAndConfig
    expect(IMap({1: "a", 2: "b"}).equalItemsAndConfig(const IMap.empty()), isFalse);
    expect(const IMapConst({1: "a", 2: "b"}).equalItemsAndConfig(const IMap.empty()), isFalse);

    expect(IMap().equalItemsAndConfig(const IMap.empty()), isTrue);
    expect(const IMapConst({}).equalItemsAndConfig(const IMap.empty()), isTrue);
    expect(const IMap.empty().equalItemsAndConfig(const IMap.empty()), isTrue);
    expect(const IMap.empty().equalItemsAndConfig(const IMapEmpty()), isTrue);
  });
}
