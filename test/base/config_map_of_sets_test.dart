// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  test("isDeepEquals", () {
    expect(ConfigMapOfSets().isDeepEquals, isTrue);
    expect(ConfigMapOfSets(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("sortKeys", () {
    expect(ConfigMapOfSets().sortKeys, isFalse);
    expect(ConfigMapOfSets(sortKeys: true).sortKeys, isTrue);
  });

  test("sortValues", () {
    expect(ConfigMapOfSets().sortValues, isFalse);
    expect(ConfigMapOfSets(sortValues: true).sortValues, isTrue);
  });

  test("removeEmptySets", () {
    expect(ConfigMapOfSets().removeEmptySets, isTrue);
    expect(ConfigMapOfSets(removeEmptySets: false).removeEmptySets, isFalse);
  });

  test("cacheHashCode", () {
    expect(ConfigMapOfSets().cacheHashCode, isTrue);
    expect(ConfigMapOfSets(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("asConfigMap", () {
    expect(ConfigMapOfSets().asConfigMap, const ConfigMap());
    expect(ConfigMapOfSets(isDeepEquals: false).asConfigMap, const ConfigMap(isDeepEquals: false));
    expect(ConfigMapOfSets(sortKeys: false).asConfigMap, const ConfigMap(sort: false));
    expect(ConfigMapOfSets(sortKeys: true).asConfigMap, const ConfigMap(sort: true));
    expect(ConfigMapOfSets(sortValues: false).asConfigMap, const ConfigMap(sort: false));
    expect(ConfigMapOfSets(sortValues: true).asConfigMap, const ConfigMap(sort: false));
    expect(
        ConfigMapOfSets(sortKeys: true, sortValues: true).asConfigMap, const ConfigMap(sort: true));
    expect(ConfigMapOfSets(sortKeys: false, sortValues: false).asConfigMap,
        const ConfigMap(sort: false));
    expect(
        ConfigMapOfSets(cacheHashCode: false).asConfigMap, const ConfigMap(cacheHashCode: false));
  });

  test("asConfigSet", () {
    expect(ConfigMapOfSets().asConfigSet, const ConfigSet());
    expect(ConfigMapOfSets(isDeepEquals: false).asConfigSet, const ConfigSet(isDeepEquals: false));
    expect(ConfigMapOfSets(sortKeys: false).asConfigSet, const ConfigSet(sort: false));
    expect(ConfigMapOfSets(sortKeys: true).asConfigSet, const ConfigSet(sort: false));
    expect(ConfigMapOfSets(sortValues: false).asConfigSet, const ConfigSet(sort: false));
    expect(ConfigMapOfSets(sortValues: true).asConfigSet, const ConfigSet(sort: true));
    expect(
        ConfigMapOfSets(sortKeys: true, sortValues: true).asConfigSet, const ConfigSet(sort: true));
    expect(ConfigMapOfSets(sortKeys: false, sortValues: false).asConfigSet,
        const ConfigSet(sort: false));
    expect(
        ConfigMapOfSets(cacheHashCode: false).asConfigSet, const ConfigSet(cacheHashCode: false));
  });

  test("==", () {
    const ConfigMapOfSets configMapOfSets1 = ConfigMapOfSets(),
        configMapOfSets2 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets3 = ConfigMapOfSets(sortKeys: true),
        configMapOfSets4 = ConfigMapOfSets(sortValues: true),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    final ConfigMapOfSets configMapOfSets7 = ConfigMapOfSets(),
        configMapOfSets8 = ConfigMapOfSets(isDeepEquals: false),
        configMapOfSets9 = ConfigMapOfSets(sortKeys: true),
        configMapOfSets10 = ConfigMapOfSets(sortValues: true),
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
        configMapOfSets1WithSortKeysFalse = configMapOfSets1.copyWith(sortKeys: true),
        configMapOfSets1WithSortValuesFalse = configMapOfSets1.copyWith(sortValues: true),
        configMapOfSets1WithRemoveEmptySetsFalse =
            configMapOfSets1.copyWith(removeEmptySets: false),
        configMapOfSets1WithCacheHashCodeFalse = configMapOfSets1.copyWith(cacheHashCode: false),
        configMapOfSets1WithAllFalse = configMapOfSets1.copyWith(
            isDeepEquals: false,
            sortKeys: true,
            sortValues: true,
            removeEmptySets: false,
            cacheHashCode: false);

    expect(identical(configMapOfSets1, configMapOfSetsIdentical), isTrue);

    expect(identical(configMapOfSets1, configMapOfSets1WithDeepFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, !configMapOfSets1WithDeepFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithDeepFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithDeepFalse.sortValues);
    expect(configMapOfSets1.removeEmptySets, configMapOfSets1WithDeepFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithDeepFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithSortKeysFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortKeysFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, !configMapOfSets1WithSortKeysFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithSortKeysFalse.sortValues);
    expect(configMapOfSets1.removeEmptySets, configMapOfSets1WithSortKeysFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithSortKeysFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithSortValuesFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithSortValuesFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithSortValuesFalse.sortKeys);
    expect(configMapOfSets1.sortValues, !configMapOfSets1WithSortValuesFalse.sortValues);
    expect(configMapOfSets1.removeEmptySets, configMapOfSets1WithSortValuesFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithSortValuesFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithRemoveEmptySetsFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithRemoveEmptySetsFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithRemoveEmptySetsFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithRemoveEmptySetsFalse.sortValues);
    expect(configMapOfSets1.removeEmptySets,
        !configMapOfSets1WithRemoveEmptySetsFalse.removeEmptySets);
    expect(configMapOfSets1.cacheHashCode, configMapOfSets1WithRemoveEmptySetsFalse.cacheHashCode);

    expect(identical(configMapOfSets1, configMapOfSets1WithCacheHashCodeFalse), isFalse);
    expect(configMapOfSets1.isDeepEquals, configMapOfSets1WithCacheHashCodeFalse.isDeepEquals);
    expect(configMapOfSets1.sortKeys, configMapOfSets1WithCacheHashCodeFalse.sortKeys);
    expect(configMapOfSets1.sortValues, configMapOfSets1WithCacheHashCodeFalse.sortValues);
    expect(
        configMapOfSets1.removeEmptySets, configMapOfSets1WithCacheHashCodeFalse.removeEmptySets);
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
        configMapOfSets3 = ConfigMapOfSets(sortKeys: true),
        configMapOfSets4 = ConfigMapOfSets(sortValues: true),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    expect(configMapOfSets1.hashCode, ConfigMapOfSets().hashCode);
    expect(configMapOfSets2.hashCode, ConfigMapOfSets(isDeepEquals: false).hashCode);
    expect(configMapOfSets3.hashCode, ConfigMapOfSets(sortKeys: true).hashCode);
    expect(configMapOfSets4.hashCode, ConfigMapOfSets(sortValues: true).hashCode);
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
        configMapOfSets3 = ConfigMapOfSets(sortKeys: true),
        configMapOfSets4 = ConfigMapOfSets(sortValues: true),
        configMapOfSets5 = ConfigMapOfSets(removeEmptySets: false),
        configMapOfSets6 = ConfigMapOfSets(cacheHashCode: false);
    expect(configMapOfSets1.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: false, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets2.toString(),
        "ConfigMapOfSets{isDeepEquals: false, sortKeys: false, sortValues: false, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets3.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: true, sortValues: false, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets4.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: true, removeEmptySets: true, cacheHashCode: true}");
    expect(configMapOfSets5.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: false, removeEmptySets: false, cacheHashCode: true}");
    expect(configMapOfSets6.toString(),
        "ConfigMapOfSets{isDeepEquals: true, sortKeys: false, sortValues: false, removeEmptySets: true, cacheHashCode: false}");
  });

  test("defaultConfig", () {
    // 1) Is initially a ConfigMapOfSets with all attributes true
    expect(IMapOfSets.defaultConfig, const ConfigMapOfSets());
    expect(IMapOfSets.defaultConfig.isDeepEquals, isTrue);
    expect(IMapOfSets.defaultConfig.sortKeys, isFalse);
    expect(IMapOfSets.defaultConfig.sortValues, isFalse);
    expect(IMapOfSets.defaultConfig.removeEmptySets, isTrue);
    expect(IMapOfSets.defaultConfig.cacheHashCode, isTrue);

    // 2) Can modify the default
    IMapOfSets.defaultConfig = ConfigMapOfSets(
        isDeepEquals: false,
        sortKeys: true,
        sortValues: true,
        removeEmptySets: false,
        cacheHashCode: false);
    expect(
        IMapOfSets.defaultConfig,
        const ConfigMapOfSets(
            isDeepEquals: false,
            sortKeys: true,
            sortValues: true,
            removeEmptySets: false,
            cacheHashCode: false));
  });
}
