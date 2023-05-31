// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  test("isDeepEquals", () {
    expect(ConfigMap().isDeepEquals, isTrue);
    expect(ConfigMap(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("sort", () {
    expect(ConfigMap().sort, isFalse);
    expect(ConfigMap(sort: false).sort, isFalse);
    expect(ConfigMap(sort: true).sort, isTrue);
  });

  test("cacheHashCode", () {
    expect(ConfigMap().cacheHashCode, isTrue);
    expect(ConfigMap(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("==", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(sort: true),
        configMap4 = ConfigMap(cacheHashCode: false);
    final ConfigMap configMap5 = ConfigMap(),
        configMap6 = ConfigMap(isDeepEquals: false),
        configMap7 = ConfigMap(sort: true),
        configMap8 = ConfigMap(cacheHashCode: false);

    expect(configMap1 == configMap1, isTrue);
    expect(configMap1 == configMap2, isFalse);
    expect(configMap1 == configMap3, isFalse);
    expect(configMap1 == configMap4, isFalse);
    expect(configMap1 == configMap5, isTrue);
    expect(configMap1 == configMap6, isFalse);
    expect(configMap1 == configMap7, isFalse);
    expect(configMap1 == configMap8, isFalse);

    expect(configMap2 == configMap1, isFalse);
    expect(configMap2 == configMap2, isTrue);
    expect(configMap2 == configMap3, isFalse);
    expect(configMap2 == configMap4, isFalse);
    expect(configMap2 == configMap5, isFalse);
    expect(configMap2 == configMap6, isTrue);
    expect(configMap2 == configMap7, isFalse);
    expect(configMap2 == configMap8, isFalse);

    expect(configMap3 == configMap1, isFalse);
    expect(configMap3 == configMap2, isFalse);
    expect(configMap3 == configMap3, isTrue);
    expect(configMap3 == configMap4, isFalse);
    expect(configMap3 == configMap5, isFalse);
    expect(configMap3 == configMap6, isFalse);
    expect(configMap3 == configMap7, isTrue);
    expect(configMap3 == configMap8, isFalse);

    expect(configMap4 == configMap1, isFalse);
    expect(configMap4 == configMap2, isFalse);
    expect(configMap4 == configMap3, isFalse);
    expect(configMap4 == configMap4, isTrue);
    expect(configMap4 == configMap5, isFalse);
    expect(configMap4 == configMap6, isFalse);
    expect(configMap4 == configMap7, isFalse);
    expect(configMap4 == configMap8, isTrue);
  });

  test("copyWith", () {
    const ConfigMap configMap1 = ConfigMap();
    final ConfigMap configMapIdentical = configMap1.copyWith(),
        configMap1WithDeepFalse = configMap1.copyWith(isDeepEquals: false),
        configMap1WithSortFalse = configMap1.copyWith(sort: true),
        configMap1WithCacheHashCodeFalse = configMap1.copyWith(cacheHashCode: false),
        configMap1WithAllFalse =
            configMap1.copyWith(isDeepEquals: false, sort: false, cacheHashCode: false);

    expect(identical(configMap1, configMapIdentical), isTrue);

    expect(identical(configMap1, configMap1WithDeepFalse), isFalse);
    expect(configMap1.isDeepEquals, !configMap1WithDeepFalse.isDeepEquals);
    expect(configMap1.sort, configMap1WithDeepFalse.sort);
    expect(configMap1.cacheHashCode, configMap1WithDeepFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithSortFalse), isFalse);
    expect(configMap1.isDeepEquals, configMap1WithSortFalse.isDeepEquals);
    expect(configMap1.sort, !configMap1WithSortFalse.sort);
    expect(configMap1.cacheHashCode, configMap1WithSortFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithCacheHashCodeFalse), isFalse);
    expect(configMap1.isDeepEquals, configMap1WithCacheHashCodeFalse.isDeepEquals);
    expect(configMap1.sort, configMap1WithCacheHashCodeFalse.sort);
    expect(configMap1.cacheHashCode, !configMap1WithCacheHashCodeFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithAllFalse), isFalse);
    expect(configMap1.isDeepEquals, !configMap1WithAllFalse.isDeepEquals);
    expect(configMap1.sort, configMap1WithAllFalse.sort);
    expect(configMap1.cacheHashCode, !configMap1WithAllFalse.cacheHashCode);
  });

  test("hashCode", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(sort: true),
        configMap4 = ConfigMap(cacheHashCode: false);

    expect(configMap1.hashCode, ConfigMap().hashCode);
    expect(configMap2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
    expect(configMap3.hashCode, ConfigMap(sort: true).hashCode);
    expect(configMap4.hashCode, ConfigMap(cacheHashCode: false).hashCode);
    expect(configMap1.hashCode, isNot(configMap2.hashCode));
    expect(configMap1.hashCode, isNot(configMap3.hashCode));
    expect(configMap1.hashCode, isNot(configMap4.hashCode));
    expect(configMap2.hashCode, isNot(configMap3.hashCode));
    expect(configMap2.hashCode, isNot(configMap4.hashCode));
    expect(configMap3.hashCode, isNot(configMap4.hashCode));
  });

  test("toString", () {
    expect(
        ConfigMap().toString(), "ConfigMap{isDeepEquals: true, sort: false, cacheHashCode: true}");
    expect(ConfigMap(isDeepEquals: false).toString(),
        "ConfigMap{isDeepEquals: false, sort: false, cacheHashCode: true}");
    expect(ConfigMap(sort: true).toString(),
        "ConfigMap{isDeepEquals: true, sort: true, cacheHashCode: true}");
    expect(ConfigMap(cacheHashCode: false).toString(),
        "ConfigMap{isDeepEquals: true, sort: false, cacheHashCode: false}");
  });

  test("defaultConfig", () {
    // 1) Is initially a ConfigMap with all attributes true
    expect(IMap.defaultConfig, const ConfigMap());
    expect(IMap.defaultConfig.isDeepEquals, isTrue);
    expect(IMap.defaultConfig.sort, isFalse);
    expect(IMap.defaultConfig.cacheHashCode, isTrue);

    // 2) Can modify the default
    IMap.defaultConfig = ConfigMap(isDeepEquals: false, sort: true, cacheHashCode: false);
    expect(
        IMap.defaultConfig, const ConfigMap(isDeepEquals: false, sort: true, cacheHashCode: false));
  });
}
