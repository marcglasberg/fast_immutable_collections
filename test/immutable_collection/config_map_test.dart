import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  // TODO: completar
  group("ConfigMap |", () {
    const ConfigMap configMap1 = ConfigMap(),
        configMap2 = ConfigMap(isDeepEquals: false),
        configMap3 = ConfigMap(autoSortKeys: false),
        configMap4 = ConfigMap(autoSortValues: false);

    test("ConfiMap.isDeepEquals getter", () {
      expect(configMap1.isDeepEquals, isTrue);
      expect(configMap2.isDeepEquals, isFalse);
    });

    test("ConfigMap.autoSortKeys getter", () {
      expect(configMap1.autoSortKeys, isTrue);
      expect(configMap3.autoSortKeys, isFalse);
    });

    test("ConfigMap.autoSortValues getter", () {
      expect(configMap1.autoSortValues, isTrue);
      expect(configMap4.autoSortValues, isFalse);
    });

    test("ConfigMap.== operator", () {
      final ConfigMap configMap5 = ConfigMap(),
          configMap6 = ConfigMap(isDeepEquals: false),
          configMap7 = ConfigMap(autoSortKeys: false),
          configMap8 = ConfigMap(autoSortValues: false);

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
          configMap1WithAutoSortKeysFalse = configMap1.copyWith(autoSortKeys: false),
          configMap1WithAutoSortValuesFalse = configMap1.copyWith(autoSortValues: false),
          configMap1WithAllFalse =
              configMap1.copyWith(isDeepEquals: false, autoSortKeys: false, autoSortValues: false);

      expect(identical(configMap1, configMapIdentical), isTrue);

      expect(identical(configMap1, configMap1WithDeepFalse), isFalse);
      expect(configMap1.isDeepEquals, !configMap1WithDeepFalse.isDeepEquals);
      expect(configMap1.autoSortKeys, configMap1WithDeepFalse.autoSortKeys);
      expect(configMap1.autoSortValues, configMap1WithDeepFalse.autoSortValues);

      expect(identical(configMap1, configMap1WithAutoSortKeysFalse), isFalse);
      expect(configMap1.isDeepEquals, configMap1WithAutoSortKeysFalse.isDeepEquals);
      expect(configMap1.autoSortKeys, !configMap1WithAutoSortKeysFalse.autoSortKeys);
      expect(configMap1.autoSortValues, configMap1WithAutoSortKeysFalse.autoSortValues);

      expect(identical(configMap1, configMap1WithAutoSortValuesFalse), isFalse);
      expect(configMap1.isDeepEquals, configMap1WithAutoSortValuesFalse.isDeepEquals);
      expect(configMap1.autoSortKeys, configMap1WithAutoSortValuesFalse.autoSortKeys);
      expect(configMap1.autoSortValues, !configMap1WithAutoSortValuesFalse.autoSortValues);

      expect(identical(configMap1, configMap1WithAllFalse), isFalse);
      expect(configMap1.isDeepEquals, !configMap1WithAllFalse.isDeepEquals);
      expect(configMap1.autoSortKeys, !configMap1WithAllFalse.autoSortKeys);
      expect(configMap1.autoSortValues, !configMap1WithAllFalse.autoSortValues);
    });

    test("ConfigMap.hashCode getter", () {
      expect(configMap1.hashCode, ConfigMap().hashCode);
      expect(configMap2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
      expect(configMap3.hashCode, ConfigMap(autoSortKeys: false).hashCode);
      expect(configMap4.hashCode, ConfigMap(autoSortValues: false).hashCode);
      expect(configMap1.hashCode, isNot(configMap2.hashCode));
      expect(configMap1.hashCode, isNot(configMap3.hashCode));
      expect(configMap1.hashCode, isNot(configMap4.hashCode));
      expect(configMap2.hashCode, isNot(configMap3.hashCode));
      expect(configMap2.hashCode, isNot(configMap4.hashCode));
      expect(configMap3.hashCode, isNot(configMap4.hashCode));
    });

    test("ConfigMap.toString method", () {
      expect(configMap1.toString(),
          'ConfigMap{isDeepEquals: true, autoSortKeys: true, autoSortValues: true}');
      expect(configMap2.toString(),
          'ConfigMap{isDeepEquals: false, autoSortKeys: true, autoSortValues: true}');
      expect(configMap3.toString(),
          'ConfigMap{isDeepEquals: true, autoSortKeys: false, autoSortValues: true}');
      expect(configMap4.toString(),
          'ConfigMap{isDeepEquals: true, autoSortKeys: true, autoSortValues: false}');
    });
  });

  group("defaultConfigMap |", () {
    test("Is initially a ConfigMap with all attributes true", () {
      expect(defaultConfigMap, const ConfigMap());
      expect(defaultConfigMap.isDeepEquals, isTrue);
      expect(defaultConfigMap.autoSortKeys, isTrue);
      expect(defaultConfigMap.autoSortValues, isTrue);
    });

    test("Can modify the default", () {
      defaultConfigMap = ConfigMap(isDeepEquals: false, autoSortKeys: false, autoSortValues: false);
      expect(defaultConfigMap,
          const ConfigMap(isDeepEquals: false, autoSortKeys: false, autoSortValues: false));
    });

    test("Changing the default ConfigMap will throw an exception if lockConfig", () {
      lockConfig();
      expect(() => defaultConfigMap = ConfigMap(isDeepEquals: false), throwsStateError);
    });
  });
}
