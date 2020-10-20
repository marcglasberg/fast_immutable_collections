import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group("ConfigMapOfSets", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(autoSortKeys: false),
        configMapOfSets4 = ConfigMapOfSets(autoSortValues: false);

    test("ConfigMapOfSets.isDeepEquals getter", () {
      expect(configMapOfSets1.isDeepEquals, isTrue);
      expect(configMapOfSets2.isDeepEquals, isFalse);
    });

    test("ConfigMapOfSets.autoSortKeys getter", () {
      expect(configMapOfSets1.autoSortKeys, isTrue);
      expect(configMapOfSets3.autoSortKeys, isFalse);
    });

    test("ConfigMapOfSets.autoSortValues getter", () {
      expect(configMapOfSets1.autoSortValues, isTrue);
      expect(configMapOfSets4.autoSortValues, isFalse);
    });

    test("ConfigMapOfSets.== operator", () {
      final ConfigMapOfSets configMapOfSets5 = ConfigMapOfSets(),
          configMapOfSets6 = ConfigMapOfSets(isDeepEquals: false),
          configMapOfSets7 = ConfigMapOfSets(autoSortKeys: false),
          configMapOfSets8 = ConfigMapOfSets(autoSortValues: false);

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
          configMapOfSets1WithAutoSortKeysFalse = configMapOfSets1.copyWith(autoSortKeys: false),
          configMapOfSets1WithAutoSortValuesFalse =
              configMapOfSets1.copyWith(autoSortValues: false),
          configMapOfSets1WithAllFalse = configMapOfSets1.copyWith(
              isDeepEquals: false, autoSortKeys: false, autoSortValues: false);

      expect(identical(configMapOfSets1, configMapOfSetsIdentical), isTrue);

      expect(identical(configMapOfSets1, configMapOfSets1WithDeepFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithDeepFalse.isDeepEquals);
      expect(configMapOfSets1.autoSortKeys, configMapOfSets1WithDeepFalse.autoSortKeys);
      expect(configMapOfSets1.autoSortValues, configMapOfSets1WithDeepFalse.autoSortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithAutoSortKeysFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithAutoSortKeysFalse.isDeepEquals);
      expect(configMapOfSets1.autoSortKeys, !configMapOfSets1WithAutoSortKeysFalse.autoSortKeys);
      expect(configMapOfSets1.autoSortValues, configMapOfSets1WithAutoSortKeysFalse.autoSortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithAutoSortValuesFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithAutoSortValuesFalse.isDeepEquals);
      expect(configMapOfSets1.autoSortKeys, configMapOfSets1WithAutoSortValuesFalse.autoSortKeys);
      expect(
          configMapOfSets1.autoSortValues, !configMapOfSets1WithAutoSortValuesFalse.autoSortValues);

      expect(identical(configMapOfSets1, configMapOfSets1WithAllFalse), isFalse);
      expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithAllFalse.isDeepEquals);
      expect(configMapOfSets1.autoSortKeys, !configMapOfSets1WithAllFalse.autoSortKeys);
      expect(configMapOfSets1.autoSortValues, !configMapOfSets1WithAllFalse.autoSortValues);
    });

    test("ConfigMapOfSets.hashCode getter", () {
      expect(configMapOfSets1.hashCode, ConfigMap().hashCode);
      expect(configMapOfSets2.hashCode, ConfigMap(isDeepEquals: false).hashCode);
      expect(configMapOfSets3.hashCode, ConfigMap(autoSortKeys: false).hashCode);
      expect(configMapOfSets4.hashCode, ConfigMap(autoSortValues: false).hashCode);
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets2.hashCode));
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets3.hashCode));
      expect(configMapOfSets1.hashCode, isNot(configMapOfSets4.hashCode));
      expect(configMapOfSets2.hashCode, isNot(configMapOfSets3.hashCode));
      expect(configMapOfSets2.hashCode, isNot(configMapOfSets4.hashCode));
      expect(configMapOfSets3.hashCode, isNot(configMapOfSets4.hashCode));
    });

    test("ConfigMapOfSets.toString method", () {
      expect(configMapOfSets1.toString(),
          'ConfigMapOfSets{isDeepEquals: true, autoSortKeys: true, autoSortValues: true}');
      expect(configMapOfSets2.toString(),
          'ConfigMapOfSets{isDeepEquals: false, autoSortKeys: true, autoSortValues: true}');
      expect(configMapOfSets3.toString(),
          'ConfigMapOfSets{isDeepEquals: true, autoSortKeys: false, autoSortValues: true}');
      expect(configMapOfSets4.toString(),
          'ConfigMapOfSets{isDeepEquals: true, autoSortKeys: true, autoSortValues: false}');
    });
  });

  group("defaultConfigMapOfSets |", () {
    test("Is initially a ConfigMapOfSets with all attributes true", () {
      expect(defaultConfigMapOfSets, const ConfigMapOfSets());
      expect(defaultConfigMapOfSets.isDeepEquals, isTrue);
      expect(defaultConfigMapOfSets.autoSortKeys, isTrue);
      expect(defaultConfigMapOfSets.autoSortValues, isTrue);
    });

    test("Can modify the default", () {
      defaultConfigMapOfSets =
          ConfigMapOfSets(isDeepEquals: false, autoSortKeys: false, autoSortValues: false);
      expect(defaultConfigMapOfSets,
          const ConfigMapOfSets(isDeepEquals: false, autoSortKeys: false, autoSortValues: false));
    });

    test("Changing the default ConfigMapOfSets will throw an exception if lockConfig", () {
      lockConfig();
      expect(() => defaultConfigMapOfSets = ConfigMapOfSets(isDeepEquals: false), throwsStateError);
    });
  });
}
