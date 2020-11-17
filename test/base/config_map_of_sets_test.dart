import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  group("ConfigMapOfSets", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(sortKeys: false),
        configMapOfSets4 = ConfigMapOfSets(sortValues: false);

    test("ConfigMapOfSets.isDeepEquals getter", () {
      expect(configMapOfSets1.isDeepEquals, isTrue);
      expect(configMapOfSets2.isDeepEquals, isFalse);
    });

    test("ConfigMapOfSets.sortKeys getter", () {
      expect(configMapOfSets1.sortKeys, isTrue);
      expect(configMapOfSets3.sortKeys, isFalse);
    });

    test("ConfigMapOfSets.sortValues getter", () {
      expect(configMapOfSets1.sortValues, isTrue);
      expect(configMapOfSets4.sortValues, isFalse);
    });

    test("ConfigMapOfSets.asConfigSet getter", () {
      expect(configMapOfSets1.asConfigSet, const ConfigSet());
      expect(configMapOfSets2.asConfigSet, const ConfigSet(isDeepEquals: false));
      expect(configMapOfSets3.asConfigSet, const ConfigSet());
      expect(configMapOfSets4.asConfigSet, const ConfigSet(sort: false));
    });

    test("ConfigMapOfSets.asConfigMap getter", () {
      expect(configMapOfSets1.asConfigMap, const ConfigMap());
      expect(configMapOfSets2.asConfigMap, const ConfigMap(isDeepEquals: false));
      expect(configMapOfSets3.asConfigMap, const ConfigMap());
      expect(configMapOfSets4.asConfigMap, const ConfigMap(sortKeys: false, sortValues: false));
    });

    test("ConfigMapOfSets.== operator", () {
      final ConfigMapOfSets configMapOfSets5 = ConfigMapOfSets(),
          configMapOfSets6 = ConfigMapOfSets(isDeepEquals: false),
          configMapOfSets7 = ConfigMapOfSets(sortKeys: false),
          configMapOfSets8 = ConfigMapOfSets(sortValues: false);

      expect(configMapOfSets1 == configMapOfSets1, isTrue);
      expect(configMapOfSets1 == configMapOfSets2, isFalse);
      expect(configMapOfSets1 == configMapOfSets3, isFalse);
      expect(configMapOfSets1 == configMapOfSets4, isFalse);
      expect(configMapOfSets1 == configMapOfSets5, isTrue);
      expect(configMapOfSets1 == configMapOfSets6, isFalse);
      expect(configMapOfSets1 == configMapOfSets7, isFalse);
      expect(configMapOfSets1 == configMapOfSets8, isFalse);

      expect(configMapOfSets2 == configMapOfSets1, isFalse);
      expect(configMapOfSets2 == configMapOfSets2, isTrue);
      expect(configMapOfSets2 == configMapOfSets3, isFalse);
      expect(configMapOfSets2 == configMapOfSets4, isFalse);
      expect(configMapOfSets2 == configMapOfSets5, isFalse);
      expect(configMapOfSets2 == configMapOfSets6, isTrue);
      expect(configMapOfSets2 == configMapOfSets7, isFalse);
      expect(configMapOfSets2 == configMapOfSets8, isFalse);

      expect(configMapOfSets3 == configMapOfSets1, isFalse);
      expect(configMapOfSets3 == configMapOfSets2, isFalse);
      expect(configMapOfSets3 == configMapOfSets3, isTrue);
      expect(configMapOfSets3 == configMapOfSets4, isFalse);
      expect(configMapOfSets3 == configMapOfSets5, isFalse);
      expect(configMapOfSets3 == configMapOfSets6, isFalse);
      expect(configMapOfSets3 == configMapOfSets7, isTrue);
      expect(configMapOfSets3 == configMapOfSets8, isFalse);

      expect(configMapOfSets4 == configMapOfSets1, isFalse);
      expect(configMapOfSets4 == configMapOfSets2, isFalse);
      expect(configMapOfSets4 == configMapOfSets3, isFalse);
      expect(configMapOfSets4 == configMapOfSets4, isTrue);
      expect(configMapOfSets4 == configMapOfSets5, isFalse);
      expect(configMapOfSets4 == configMapOfSets6, isFalse);
      expect(configMapOfSets4 == configMapOfSets7, isFalse);
      expect(configMapOfSets4 == configMapOfSets8, isTrue);
    });

    test("ConfigMapOfSets.copyWith method", () {
      final ConfigMapOfSets configMapOfSetsIdentical = configMapOfSets1.copyWith(),
          configMapOfSets1WithDeepFalse = configMapOfSets1.copyWith(isDeepEquals: false),
          configMapOfSets1WithSortKeysFalse = configMapOfSets1.copyWith(sortKeys: false),
          configMapOfSets1WithSortValuesFalse = configMapOfSets1.copyWith(sortValues: false),
          configMapOfSets1WithAllFalse =
              configMapOfSets1.copyWith(isDeepEquals: false, sortKeys: false, sortValues: false);

      expect(identical(configMapOfSets1, configMapOfSetsIdentical), isTrue);

      expect(identical(configMapOfSets1, configMapOfSets1WithDeepFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithDeepFalse.isDeepEquals);
      expect(configMapOfSets1.sortKeys, configMapOfSets1WithDeepFalse.sortKeys);
      expect(configMapOfSets1.sortValues, configMapOfSets1WithDeepFalse.sortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithSortKeysFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortKeysFalse.isDeepEquals);
      expect(configMapOfSets1.sortKeys, !configMapOfSets1WithSortKeysFalse.sortKeys);
      expect(configMapOfSets1.sortValues, configMapOfSets1WithSortKeysFalse.sortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithSortValuesFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortValuesFalse.isDeepEquals);
      expect(configMapOfSets1.sortKeys, configMapOfSets1WithSortValuesFalse.sortKeys);
      expect(configMapOfSets1.sortValues, !configMapOfSets1WithSortValuesFalse.sortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithAllFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithAllFalse.isDeepEquals);
      expect(configMapOfSets1.sortKeys, !configMapOfSets1WithAllFalse.sortKeys);
      expect(configMapOfSets1.sortValues, !configMapOfSets1WithAllFalse.sortValues);
    });

    test("ConfigMapOfSets.hashCode getter", () {
      expect(configMapOfSets1.hashCode, ConfigMap().hashCode);
      expect(configMapOfSets2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
      expect(configMapOfSets3.hashCode, ConfigMap(sortKeys: false).hashCode);
      expect(configMapOfSets4.hashCode, ConfigMap(sortValues: false).hashCode);
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets2.hashCode));
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets3.hashCode));
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets4.hashCode));
      expect(configMapOfSets2.hashCode, isNot(configMapOfSets3.hashCode));
      expect(configMapOfSets2.hashCode, isNot(configMapOfSets4.hashCode));
      expect(configMapOfSets3.hashCode, isNot(configMapOfSets4.hashCode));
    });

    test("ConfigMapOfSets.toString method", () {
      expect(configMapOfSets1.toString(),
          "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: true}");
      expect(configMapOfSets2.toString(),
          "ConfigMapOfSets{isDeepEquals: false, sortKeys: true, sortValues: true}");
      expect(configMapOfSets3.toString(),
          "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: true}");
      expect(configMapOfSets4.toString(),
          "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: false}");
    });
  });

  group("defaultConfig |", () {
    test("Is initially a ConfigMapOfSets with all attributes true", () {
      expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());
      expect(IMapOfSets.defaultConfig.isDeepEquals, isTrue);
      expect(IMapOfSets.defaultConfig.sortKeys, isTrue);
      expect(IMapOfSets.defaultConfig.sortValues, isTrue);
    });

    test("Can modify the default", () {
      IMapOfSets.defaultConfig =
          ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false);
      expect(IMapOfSets.defaultConfig,
          const ConfigMapOfSets(isDeepEquals: false, sortKeys: false, sortValues: false));
    });

    test("Changing the default ConfigMapOfSets will throw an exception if lockConfig", () {
      ImmutableCollection.lockConfig();
      expect(
          () => IMapOfSets.defaultConfig = ConfigMapOfSets(isDeepEquals: false), throwsStateError);
    });
  });
}
