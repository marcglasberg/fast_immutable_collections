import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("isDeepEquals", () {
    expect(ConfigMapOfSets().isDeepEquals, isTrue);
    expect(ConfigMapOfSets(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("sortKeys", () {
    expect(ConfigMapOfSets().sortKeys, isTrue);
    expect(ConfigMapOfSets(sortKeys: false).sortKeys, isFalse);
  });

  test("sortValues", () {
    expect(ConfigMapOfSets().sortValues, isTrue);
    expect(ConfigMapOfSets(sortValues: false).sortValues, isFalse);
  });

  test("removeEmptySets", () {
    expect(ConfigMapOfSets().removeEmptySets, isTrue);
    expect(ConfigMapOfSets(removeEmptySets: false).removeEmptySets, isFalse);
  });

  test("cacheHashCode", () {
    expect(ConfigMapOfSets().cacheHashCode, isTrue);
    expect(ConfigMapOfSets(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("asConfigSet", () {
    expect(ConfigMapOfSets().asConfigSet, const ConfigSet());
    expect(ConfigMapOfSets(isDeepEquals: false).asConfigSet, const ConfigSet(isDeepEquals: false));
    expect(ConfigMapOfSets(sortKeys: false).asConfigSet, const ConfigSet());
    expect(ConfigMapOfSets(sortValues: false).asConfigSet, const ConfigSet(sort: false));
    expect(
        ConfigMapOfSets(cacheHashCode: false).asConfigSet, const ConfigSet(cacheHashCode: false));
  });

  test("asConfigMap", () {
    expect(ConfigMapOfSets().asConfigMap, const ConfigMap());
    expect(ConfigMapOfSets(isDeepEquals: false).asConfigMap, const ConfigMap(isDeepEquals: false));
    expect(ConfigMapOfSets(sortKeys: false).asConfigMap, const ConfigMap());
    expect(ConfigMapOfSets(sortValues: false).asConfigMap,
        const ConfigMap(sortKeys: false, sortValues: false));
    expect(
        ConfigMapOfSets(cacheHashCode: false).asConfigMap, const ConfigMap(cacheHashCode: false));
  });

  test("==", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(sortKeys: false),
        configMapOfSets4 = ConfigMapOfSets(sortValues: false),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    final ConfigMapOfSets configMapOfSets7 = ConfigMapOfSets(),
        configMapOfSets8 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets9 = ConfigMapOfSets(sortKeys: false),
        configMapOfSets10 = ConfigMapOfSets(sortValues: false),
        configMapOfSets11 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets12 = ConfigMapOfSets(cacheHashCode: false);

    expect(configMapOfSets1 == configMapOfSets1, isTrue);
    expect(configMapOfSets1 == configMapOfSets2, isFalse);
    expect(configMapOfSets1 == configMapOfSets3, isFalse);
    expect(configMapOfSets1 == configMapOfSets4, isFalse);
    expect(configMapOfSets1 == configMapOfSets5, isFalse);
    expect(configMapOfSets1 == configMapOfSets6, isFalse);
    expect(configMapOfSets1 == configMapOfSets7, isTrue);
    expect(configMapOfSets1 == configMapOfSets8, isFalse);
    expect(configMapOfSets1 == configMapOfSets9, isFalse);
    expect(configMapOfSets1 == configMapOfSets10, isFalse);
    expect(configMapOfSets1 == configMapOfSets11, isFalse);
    expect(configMapOfSets1 == configMapOfSets12, isFalse);

    expect(configMapOfSets2 == configMapOfSets1, isFalse);
    expect(configMapOfSets2 == configMapOfSets2, isTrue);
    expect(configMapOfSets2 == configMapOfSets3, isFalse);
    expect(configMapOfSets2 == configMapOfSets4, isFalse);
    expect(configMapOfSets2 == configMapOfSets5, isFalse);
    expect(configMapOfSets2 == configMapOfSets6, isFalse);
    expect(configMapOfSets2 == configMapOfSets7, isFalse);
    expect(configMapOfSets2 == configMapOfSets8, isTrue);
    expect(configMapOfSets2 == configMapOfSets9, isFalse);
    expect(configMapOfSets2 == configMapOfSets10, isFalse);
    expect(configMapOfSets2 == configMapOfSets11, isFalse);
    expect(configMapOfSets2 == configMapOfSets12, isFalse);

    expect(configMapOfSets3 == configMapOfSets1, isFalse);
    expect(configMapOfSets3 == configMapOfSets2, isFalse);
    expect(configMapOfSets3 == configMapOfSets3, isTrue);
    expect(configMapOfSets3 == configMapOfSets4, isFalse);
    expect(configMapOfSets3 == configMapOfSets5, isFalse);
    expect(configMapOfSets3 == configMapOfSets6, isFalse);
    expect(configMapOfSets3 == configMapOfSets7, isFalse);
    expect(configMapOfSets3 == configMapOfSets8, isFalse);
    expect(configMapOfSets3 == configMapOfSets9, isTrue);
    expect(configMapOfSets3 == configMapOfSets10, isFalse);
    expect(configMapOfSets3 == configMapOfSets11, isFalse);
    expect(configMapOfSets3 == configMapOfSets12, isFalse);

    expect(configMapOfSets4 == configMapOfSets1, isFalse);
    expect(configMapOfSets4 == configMapOfSets2, isFalse);
    expect(configMapOfSets4 == configMapOfSets3, isFalse);
    expect(configMapOfSets4 == configMapOfSets4, isTrue);
    expect(configMapOfSets4 == configMapOfSets5, isFalse);
    expect(configMapOfSets4 == configMapOfSets6, isFalse);
    expect(configMapOfSets4 == configMapOfSets7, isFalse);
    expect(configMapOfSets4 == configMapOfSets8, isFalse);
    expect(configMapOfSets4 == configMapOfSets9, isFalse);
    expect(configMapOfSets4 == configMapOfSets10, isTrue);
    expect(configMapOfSets4 == configMapOfSets11, isFalse);
    expect(configMapOfSets4 == configMapOfSets12, isFalse);

    expect(configMapOfSets5 == configMapOfSets1, isFalse);
    expect(configMapOfSets5 == configMapOfSets2, isFalse);
    expect(configMapOfSets5 == configMapOfSets3, isFalse);
    expect(configMapOfSets5 == configMapOfSets4, isFalse);
    expect(configMapOfSets5 == configMapOfSets5, isTrue);
    expect(configMapOfSets5 == configMapOfSets6, isFalse);
    expect(configMapOfSets5 == configMapOfSets7, isFalse);
    expect(configMapOfSets5 == configMapOfSets8, isFalse);
    expect(configMapOfSets5 == configMapOfSets9, isFalse);
    expect(configMapOfSets5 == configMapOfSets10, isFalse);
    expect(configMapOfSets5 == configMapOfSets11, isTrue);
    expect(configMapOfSets5 == configMapOfSets12, isFalse);

    expect(configMapOfSets6 == configMapOfSets1, isFalse);
    expect(configMapOfSets6 == configMapOfSets2, isFalse);
    expect(configMapOfSets6 == configMapOfSets3, isFalse);
    expect(configMapOfSets6 == configMapOfSets4, isFalse);
    expect(configMapOfSets6 == configMapOfSets5, isFalse);
    expect(configMapOfSets6 == configMapOfSets6, isTrue);
    expect(configMapOfSets6 == configMapOfSets7, isFalse);
    expect(configMapOfSets6 == configMapOfSets8, isFalse);
    expect(configMapOfSets6 == configMapOfSets9, isFalse);
    expect(configMapOfSets6 == configMapOfSets10, isFalse);
    expect(configMapOfSets6 == configMapOfSets11, isFalse);
    expect(configMapOfSets6 == configMapOfSets12, isTrue);
  });

  test("copyWith", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets();
    final ConfigMapOfSets configMapOfSetsIdentical = configMapOfSets1.copyWith(),
        configMapOfSets1WithDeepFalse = configMapOfSets1.copyWith(isDeepEquals: false),
        configMapOfSets1WithSortKeysFalse = configMapOfSets1.copyWith(sortKeys: false),
        configMapOfSets1WithSortValuesFalse = configMapOfSets1.copyWith(sortValues: false),
        configMapOfSets1WithRemoveEmptySetsFalse =
            configMapOfSets1.copyWith(removeEmptySets: false),
        configMapOfSets1WithCacheHashCodeFalse = configMapOfSets1.copyWith(cacheHashCode: false),
        configMapOfSets1WithAllFalse = configMapOfSets1.copyWith(
            isDeepEquals: false,
            sortKeys: false,
            sortValues: false,
            removeEmptySets: false,
            cacheHashCode: false);

    expect(identical(configMapOfSets1, configMapOfSetsIdentical), isTrue);

    expect(identical(configMapOfSets1, configMapOfSets1WithDeepFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithDeepFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithDeepFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithDeepFalse.sortValues);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithDeepFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithDeepFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithSortKeysFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortKeysFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, !configMapOfSets1WithSortKeysFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithSortKeysFalse.sortValues);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithSortKeysFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithSortKeysFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithSortValuesFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortValuesFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithSortValuesFalse.sortKeys);
    expect(configMapOfSets1.sortValues, !configMapOfSets1WithSortValuesFalse.sortValues);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithSortValuesFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithSortValuesFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithRemoveEmptySetsFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithRemoveEmptySetsFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithRemoveEmptySetsFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithRemoveEmptySetsFalse.sortValues);
    expect(configMapOfSets1.sortValues, !configMapOfSets1WithRemoveEmptySetsFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithRemoveEmptySetsFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithCacheHashCodeFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithCacheHashCodeFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithCacheHashCodeFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithCacheHashCodeFalse.sortValues);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithCacheHashCodeFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, !configMapOfSets1WithCacheHashCodeFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithAllFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithAllFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, !configMapOfSets1WithAllFalse.sortKeys);
    expect(configMapOfSets1.sortValues, !configMapOfSets1WithAllFalse.sortValues);
    expect(configMapOfSets1.removeEmptySets, !configMapOfSets1WithAllFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, !configMapOfSets1WithAllFalse.cacheHashCode);
  });

  test("hashCode", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(sortKeys: false),
        configMapOfSets4 = ConfigMapOfSets(sortValues: false),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    expect(configMapOfSets1.hashCode, ConfigMapOfSets().hashCode);
    expect(configMapOfSets2.hashCode, ConfigMapOfSets(isDeepEquals: false).hashCode);
    expect(configMapOfSets3.hashCode, ConfigMapOfSets(sortKeys: false).hashCode);
    expect(configMapOfSets4.hashCode, ConfigMapOfSets(sortValues: false).hashCode);
    expect(configMapOfSets5.hashCode, ConfigMapOfSets(removeEmptySets: false).hashCode);
    expect(configMapOfSets6.hashCode, ConfigMapOfSets(cacheHashCode: false).hashCode);
    expect(configMapOfSets1.hashCode, isNot(configMapOfSets2.hashCode));
    expect(configMapOfSets1.hashCode, isNot(configMapOfSets3.hashCode));
    expect(configMapOfSets1.hashCode, isNot(configMapOfSets4.hashCode));
    expect(configMapOfSets2.hashCode, isNot(configMapOfSets3.hashCode));
    expect(configMapOfSets2.hashCode, isNot(configMapOfSets4.hashCode));
    expect(configMapOfSets3.hashCode, isNot(configMapOfSets4.hashCode));
    expect(configMapOfSets3.hashCode, isNot(configMapOfSets5.hashCode));
    expect(configMapOfSets3.hashCode, isNot(configMapOfSets6.hashCode));
    expect(configMapOfSets4.hashCode, isNot(configMapOfSets5.hashCode));
    expect(configMapOfSets4.hashCode, isNot(configMapOfSets6.hashCode));
    expect(configMapOfSets5.hashCode, isNot(configMapOfSets6.hashCode));
  });

  test("toString", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(sortKeys: false),
        configMapOfSets4 = ConfigMapOfSets(sortValues: false),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    expect(configMapOfSets1.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: true, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets2.toString(),
        "ConfigMapOfSets{isDeepEquals: false, sortKeys: true, sortValues: true, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets3.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: true, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets4.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: false, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets5.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: true, removeEmptySets: false, cacheHashCode: true}");
    expect(configMapOfSets6.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: true, removeEmptySets: true, cacheHashCode: false}");
  });

  test("defaultConfig", () {
    // 1) Is initially a ConfigMapOfSets with all attributes true
    expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());
    expect(IMapOfSets.defaultConfig.isDeepEquals, isTrue);
    expect(IMapOfSets.defaultConfig.sortKeys, isTrue);
    expect(IMapOfSets.defaultConfig.sortValues, isTrue);
    expect(IMapOfSets.defaultConfig.removeEmptySets, isTrue);
    expect(IMapOfSets.defaultConfig.cacheHashCode, isTrue);

    // 2) Can modify the default
    IMapOfSets.defaultConfig = ConfigMapOfSets(
        isDeepEquals: false,
        sortKeys: false,
        sortValues: false,
        removeEmptySets: false,
        cacheHashCode: false);
    expect(
        IMapOfSets.defaultConfig,
        const ConfigMapOfSets(
            isDeepEquals: false,
            sortKeys: false,
            sortValues: false,
            removeEmptySets: false,
            cacheHashCode: false));
  });
}
