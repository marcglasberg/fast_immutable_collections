import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  group("ConfigMap |", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(sortKeys: false),
        configMap4 = ConfigMap(sortValues: false);

    test("ConfiMap.isDeepEquals getter", () {
      expect(configMap1.isDeepEquals, isTrue);
      expect(configMap2.isDeepEquals, isFalse);
    });

    test("ConfigMap.sortKeys getter", () {
      expect(configMap1.sortKeys, isTrue);
      expect(configMap3.sortKeys, isFalse);
    });

    test("ConfigMap.sortValues getter", () {
      expect(configMap1.sortValues, isTrue);
      expect(configMap4.sortValues, isFalse);
    });

    test("ConfigMap.== operator", () {
      final ConfigMap configMap5 = ConfigMap(),
          configMap6 = ConfigMap(isDeepEquals: false),
          configMap7 = ConfigMap(sortKeys: false),
          configMap8 = ConfigMap(sortValues: false);

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

    test("ConfigMap.copyWith method", () {
      final ConfigMap configMapIdentical = configMap1.copyWith(),
          configMap1WithDeepFalse = configMap1.copyWith(isDeepEquals: false),
          configMap1WithSortKeysFalse = configMap1.copyWith(sortKeys: false),
          configMap1WithSortValuesFalse = configMap1.copyWith(sortValues: false),
          configMap1WithAllFalse =
              configMap1.copyWith(isDeepEquals: false, sortKeys: false, sortValues: false);

      expect(identical(configMap1, configMapIdentical), isTrue);

      expect(identical(configMap1, configMap1WithDeepFalse), isFalse);
      expect(configMap1.isDeepEquals, !configMap1WithDeepFalse.isDeepEquals);
      expect(configMap1.sortKeys, configMap1WithDeepFalse.sortKeys);
      expect(configMap1.sortValues, configMap1WithDeepFalse.sortValues);

      expect(identical(configMap1, configMap1WithSortKeysFalse), isFalse);
      expect(configMap1.isDeepEquals, configMap1WithSortKeysFalse.isDeepEquals);
      expect(configMap1.sortKeys, !configMap1WithSortKeysFalse.sortKeys);
      expect(configMap1.sortValues, configMap1WithSortKeysFalse.sortValues);

      expect(identical(configMap1, configMap1WithSortValuesFalse), isFalse);
      expect(configMap1.isDeepEquals, configMap1WithSortValuesFalse.isDeepEquals);
      expect(configMap1.sortKeys, configMap1WithSortValuesFalse.sortKeys);
      expect(configMap1.sortValues, !configMap1WithSortValuesFalse.sortValues);

      expect(identical(configMap1, configMap1WithAllFalse), isFalse);
      expect(configMap1.isDeepEquals, !configMap1WithAllFalse.isDeepEquals);
      expect(configMap1.sortKeys, !configMap1WithAllFalse.sortKeys);
      expect(configMap1.sortValues, !configMap1WithAllFalse.sortValues);
    });

    test("ConfigMap.hashCode getter", () {
      expect(configMap1.hashCode, ConfigMap().hashCode);
      expect(configMap2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
      expect(configMap3.hashCode, ConfigMap(sortKeys: false).hashCode);
      expect(configMap4.hashCode, ConfigMap(sortValues: false).hashCode);
      expect(configMap1.hashCode, isNot(configMap2.hashCode));
      expect(configMap1.hashCode, isNot(configMap3.hashCode));
      expect(configMap1.hashCode, isNot(configMap4.hashCode));
      expect(configMap2.hashCode, isNot(configMap3.hashCode));
      expect(configMap2.hashCode, isNot(configMap4.hashCode));
      expect(configMap3.hashCode, isNot(configMap4.hashCode));
    });

    test("ConfigMap.toString method", () {
      expect(configMap1.toString(),
          "ConfigMap{isDeepEquals: true, sortKeys: true, sortValues: true}");
      expect(configMap2.toString(),
          "ConfigMap{isDeepEquals: false, sortKeys: true, sortValues: true}");
      expect(configMap3.toString(),
          "ConfigMap{isDeepEquals: true, sortKeys: false, sortValues: true}");
      expect(configMap4.toString(),
          "ConfigMap{isDeepEquals: true, sortKeys: true, sortValues: false}");
    });
  });

  group("defaultConfig |", () {
    test("Is initially a ConfigMap with all attributes true", () {
      expect(IMap.defaultConfig, const ConfigMap());
      expect(IMap.defaultConfig.isDeepEquals, isTrue);
      expect(IMap.defaultConfig.sortKeys, isTrue);
      expect(IMap.defaultConfig.sortValues, isTrue);
    });

    test("Can modify the default", () {
      IMap.defaultConfig = ConfigMap(isDeepEquals: false, sortKeys: false, sortValues: false);
      expect(IMap.defaultConfig,
          const ConfigMap(isDeepEquals: false, sortKeys: false, sortValues: false));
    });

    test("Changing the default ConfigMap will throw an exception if lockConfig", () {
      ImmutableCollection.lockConfig();
      expect(() => IMap.defaultConfig = ConfigMap(isDeepEquals: false), throwsStateError);
    });
  });
}
