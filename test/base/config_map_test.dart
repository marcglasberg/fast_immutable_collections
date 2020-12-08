import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("ConfiMap.isDeepEquals getter", () {
    expect(ConfigMap().isDeepEquals, isTrue);
    expect(ConfigMap(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("ConfigMap.sortKeys getter", () {
    expect(ConfigMap().sortKeys, isTrue);
    expect(ConfigMap(sortKeys: false).sortKeys, isFalse);
  });

  test("ConfigMap.sortValues getter", () {
    expect(ConfigMap().sortValues, isTrue);
    expect(ConfigMap(sortValues: false).sortValues, isFalse);
  });

  test("ConfigMap.cacheHashCode getter", () {
    expect(ConfigMap().cacheHashCode, isTrue);
    expect(ConfigMap(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("ConfigMap.== operator", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(sortKeys: false),
        configMap4 = ConfigMap(sortValues: false),
        configMap5 = ConfigMap(cacheHashCode: false);
    final ConfigMap configMap6 = ConfigMap(),
        configMap7 = ConfigMap(isDeepEquals: false),
        configMap8 = ConfigMap(sortKeys: false),
        configMap9 = ConfigMap(sortValues: false),
        configMap10 = ConfigMap(cacheHashCode: false);

    expect(configMap1 == configMap1, isTrue);
    expect(configMap1 == configMap2, isFalse);
    expect(configMap1 == configMap3, isFalse);
    expect(configMap1 == configMap4, isFalse);
    expect(configMap1 == configMap5, isFalse);
    expect(configMap1 == configMap6, isTrue);
    expect(configMap1 == configMap7, isFalse);
    expect(configMap1 == configMap8, isFalse);
    expect(configMap1 == configMap9, isFalse);
    expect(configMap1 == configMap10, isFalse);

    expect(configMap2 == configMap1, isFalse);
    expect(configMap2 == configMap2, isTrue);
    expect(configMap2 == configMap3, isFalse);
    expect(configMap2 == configMap4, isFalse);
    expect(configMap2 == configMap5, isFalse);
    expect(configMap2 == configMap6, isFalse);
    expect(configMap2 == configMap7, isTrue);
    expect(configMap2 == configMap8, isFalse);
    expect(configMap2 == configMap9, isFalse);
    expect(configMap2 == configMap10, isFalse);

    expect(configMap3 == configMap1, isFalse);
    expect(configMap3 == configMap2, isFalse);
    expect(configMap3 == configMap3, isTrue);
    expect(configMap3 == configMap4, isFalse);
    expect(configMap3 == configMap5, isFalse);
    expect(configMap3 == configMap6, isFalse);
    expect(configMap3 == configMap7, isFalse);
    expect(configMap3 == configMap8, isTrue);
    expect(configMap3 == configMap9, isFalse);
    expect(configMap3 == configMap10, isFalse);

    expect(configMap4 == configMap1, isFalse);
    expect(configMap4 == configMap2, isFalse);
    expect(configMap4 == configMap3, isFalse);
    expect(configMap4 == configMap4, isTrue);
    expect(configMap4 == configMap5, isFalse);
    expect(configMap4 == configMap6, isFalse);
    expect(configMap4 == configMap7, isFalse);
    expect(configMap4 == configMap8, isFalse);
    expect(configMap4 == configMap9, isTrue);
    expect(configMap4 == configMap10, isFalse);

    expect(configMap5 == configMap1, isFalse);
    expect(configMap5 == configMap2, isFalse);
    expect(configMap5 == configMap3, isFalse);
    expect(configMap5 == configMap4, isFalse);
    expect(configMap5 == configMap5, isTrue);
    expect(configMap5 == configMap6, isFalse);
    expect(configMap5 == configMap7, isFalse);
    expect(configMap5 == configMap8, isFalse);
    expect(configMap5 == configMap9, isFalse);
    expect(configMap5 == configMap10, isTrue);
  });

  test("ConfigMap.copyWith()", () {
    const ConfigMap configMap1 = ConfigMap();
    final ConfigMap configMapIdentical = configMap1.copyWith(),
        configMap1WithDeepFalse = configMap1.copyWith(isDeepEquals: false),
        configMap1WithSortKeysFalse = configMap1.copyWith(sortKeys: false),
        configMap1WithSortValuesFalse = configMap1.copyWith(sortValues: false),
        configMap1WithCacheHashCodeFalse = configMap1.copyWith(cacheHashCode: false),
        configMap1WithAllFalse = configMap1.copyWith(
            isDeepEquals: false, sortKeys: false, sortValues: false, cacheHashCode: false);

    expect(identical(configMap1, configMapIdentical), isTrue);

    expect(identical(configMap1, configMap1WithDeepFalse), isFalse);
    expect(configMap1.isDeepEquals, !configMap1WithDeepFalse.isDeepEquals);
    expect(configMap1.sortKeys, configMap1WithDeepFalse.sortKeys);
    expect(configMap1.sortValues, configMap1WithDeepFalse.sortValues);
    expect(configMap1.cacheHashCode, configMap1WithDeepFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithSortKeysFalse), isFalse);
    expect(configMap1.isDeepEquals, configMap1WithSortKeysFalse.isDeepEquals);
    expect(configMap1.sortKeys, !configMap1WithSortKeysFalse.sortKeys);
    expect(configMap1.sortValues, configMap1WithSortKeysFalse.sortValues);
    expect(configMap1.cacheHashCode, configMap1WithSortKeysFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithSortValuesFalse), isFalse);
    expect(configMap1.isDeepEquals, configMap1WithSortValuesFalse.isDeepEquals);
    expect(configMap1.sortKeys, configMap1WithSortValuesFalse.sortKeys);
    expect(configMap1.sortValues, !configMap1WithSortValuesFalse.sortValues);
    expect(configMap1.cacheHashCode, configMap1WithSortValuesFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithCacheHashCodeFalse), isFalse);
    expect(configMap1.isDeepEquals, configMap1WithCacheHashCodeFalse.isDeepEquals);
    expect(configMap1.sortKeys, configMap1WithCacheHashCodeFalse.sortKeys);
    expect(configMap1.sortValues, configMap1WithCacheHashCodeFalse.sortValues);
    expect(configMap1.cacheHashCode, !configMap1WithCacheHashCodeFalse.cacheHashCode);

    expect(identical(configMap1, configMap1WithAllFalse), isFalse);
    expect(configMap1.isDeepEquals, !configMap1WithAllFalse.isDeepEquals);
    expect(configMap1.sortKeys, !configMap1WithAllFalse.sortKeys);
    expect(configMap1.sortValues, !configMap1WithAllFalse.sortValues);
    expect(configMap1.sortValues, !configMap1WithAllFalse.cacheHashCode);
  });

  test("ConfigMap.hashCode getter", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(sortKeys: false),
        configMap4 = ConfigMap(sortValues: false),
        configMap5 = ConfigMap(cacheHashCode: false);

    expect(configMap1.hashCode, ConfigMap().hashCode);
    expect(configMap2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
    expect(configMap3.hashCode, ConfigMap(sortKeys: false).hashCode);
    expect(configMap4.hashCode, ConfigMap(sortValues: false).hashCode);
    expect(configMap5.hashCode, ConfigMap(cacheHashCode: false).hashCode);
    expect(configMap1.hashCode, isNot(configMap2.hashCode));
    expect(configMap1.hashCode, isNot(configMap3.hashCode));
    expect(configMap1.hashCode, isNot(configMap4.hashCode));
    expect(configMap1.hashCode, isNot(configMap5.hashCode));
    expect(configMap2.hashCode, isNot(configMap3.hashCode));
    expect(configMap2.hashCode, isNot(configMap4.hashCode));
    expect(configMap2.hashCode, isNot(configMap5.hashCode));
    expect(configMap3.hashCode, isNot(configMap4.hashCode));
    expect(configMap3.hashCode, isNot(configMap5.hashCode));
    expect(configMap4.hashCode, isNot(configMap5.hashCode));
  });

  test("ConfigMap.toString()", () {
    expect(ConfigMap().toString(),
        "ConfigMap{isDeepEquals: true, sortKeys: true, sortValues: true, cacheHashCode: true}");
    expect(ConfigMap(isDeepEquals: false).toString(),
        "ConfigMap{isDeepEquals: false, sortKeys: true, sortValues: true, cacheHashCode: true}");
    expect(ConfigMap(sortKeys: false).toString(),
        "ConfigMap{isDeepEquals: true, sortKeys: false, sortValues: true, cacheHashCode: true}");
    expect(ConfigMap(sortValues: false).toString(),
        "ConfigMap{isDeepEquals: true, sortKeys: true, sortValues: false, cacheHashCode: true}");
    expect(ConfigMap(cacheHashCode: false).toString(),
        "ConfigMap{isDeepEquals: true, sortKeys: true, sortValues: true, cacheHashCode: false}");
  });

  test("defaultConfig | Is initially a ConfigMap with all attributes true", () {
    expect(IMap.defaultConfig, const ConfigMap());
    expect(IMap.defaultConfig.isDeepEquals, isTrue);
    expect(IMap.defaultConfig.sortKeys, isTrue);
    expect(IMap.defaultConfig.sortValues, isTrue);
    expect(IMap.defaultConfig.cacheHashCode, isTrue);
  });

  test("defaultConfig | Can modify the default", () {
    IMap.defaultConfig =
        ConfigMap(isDeepEquals: false, sortKeys: false, sortValues: false, cacheHashCode: false);
    expect(
        IMap.defaultConfig,
        const ConfigMap(
            isDeepEquals: false, sortKeys: false, sortValues: false, cacheHashCode: false));
  });

  test("defaultConfig | Changing the default ConfigMap will throw an exception if lockConfig", () {
    ImmutableCollection.lockConfig();
    expect(() => IMap.defaultConfig = ConfigMap(isDeepEquals: false), throwsStateError);
  }, skip: true);
}
