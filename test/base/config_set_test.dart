// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  test("isDeepEquals", () {
    expect(ConfigSet().isDeepEquals, isTrue);
    expect(ConfigSet(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("sort", () {
    expect(ConfigSet().sort, isFalse);
    expect(ConfigSet(sort: true).sort, isTrue);
  });

  test("cacheHashCode", () {
    expect(ConfigSet().cacheHashCode, isTrue);
    expect(ConfigSet(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("==", () {
    const ConfigSet configSet1 = ConfigSet(),
        configSet2 = ConfigSet(isDeepEquals: false),
        configSet3 = ConfigSet(sort: true),
        configSet4 = ConfigSet(cacheHashCode: false);
    final ConfigSet configSet5 = ConfigSet(),
        configSet6 = ConfigSet(isDeepEquals: false),
        configSet7 = ConfigSet(sort: true),
        configSet8 = ConfigSet(cacheHashCode: false);

    expect(configSet1 == configSet1, isTrue);
    expect(configSet1 == configSet2, isFalse);
    expect(configSet1 == configSet3, isFalse);
    expect(configSet1 == configSet4, isFalse);
    expect(configSet1 == configSet5, isTrue);
    expect(configSet1 == configSet6, isFalse);
    expect(configSet1 == configSet7, isFalse);
    expect(configSet1 == configSet8, isFalse);

    expect(configSet2 == configSet1, isFalse);
    expect(configSet2 == configSet2, isTrue);
    expect(configSet2 == configSet3, isFalse);
    expect(configSet2 == configSet4, isFalse);
    expect(configSet2 == configSet5, isFalse);
    expect(configSet2 == configSet6, isTrue);
    expect(configSet2 == configSet7, isFalse);
    expect(configSet2 == configSet8, isFalse);

    expect(configSet3 == configSet1, isFalse);
    expect(configSet3 == configSet2, isFalse);
    expect(configSet3 == configSet3, isTrue);
    expect(configSet3 == configSet4, isFalse);
    expect(configSet3 == configSet5, isFalse);
    expect(configSet3 == configSet6, isFalse);
    expect(configSet3 == configSet7, isTrue);
    expect(configSet3 == configSet8, isFalse);

    expect(configSet4 == configSet1, isFalse);
    expect(configSet4 == configSet2, isFalse);
    expect(configSet4 == configSet3, isFalse);
    expect(configSet4 == configSet4, isTrue);
    expect(configSet4 == configSet5, isFalse);
    expect(configSet4 == configSet6, isFalse);
    expect(configSet4 == configSet7, isFalse);
    expect(configSet4 == configSet8, isTrue);
  });

  test("copyWith", () {
    const ConfigSet configSet1 = ConfigSet();
    final ConfigSet configSetIdentical = configSet1.copyWith(),
        configSet1WithDeepFalse = configSet1.copyWith(isDeepEquals: false),
        configSet1WithSortFalse = configSet1.copyWith(sort: true),
        configSet1WithCacheHashCode = configSet1.copyWith(cacheHashCode: false),
        configSet1WithDeepAndSortFalse =
            configSet1.copyWith(isDeepEquals: false, sort: true, cacheHashCode: false);

    expect(identical(configSet1, configSetIdentical), isTrue);

    expect(identical(configSet1, configSet1WithDeepFalse), isFalse);
    expect(configSet1.isDeepEquals, !configSet1WithDeepFalse.isDeepEquals);
    expect(configSet1.sort, configSet1WithDeepFalse.sort);
    expect(configSet1.cacheHashCode, configSet1WithDeepFalse.cacheHashCode);

    expect(identical(configSet1, configSet1WithSortFalse), isFalse);
    expect(configSet1.isDeepEquals, configSet1WithSortFalse.isDeepEquals);
    expect(configSet1.sort, !configSet1WithSortFalse.sort);
    expect(configSet1.cacheHashCode, configSet1WithSortFalse.cacheHashCode);

    expect(identical(configSet1, configSet1WithCacheHashCode), isFalse);
    expect(configSet1.isDeepEquals, configSet1WithCacheHashCode.isDeepEquals);
    expect(configSet1.sort, configSet1WithCacheHashCode.sort);
    expect(configSet1.cacheHashCode, !configSet1WithCacheHashCode.cacheHashCode);

    expect(identical(configSet1, configSet1WithDeepAndSortFalse), isFalse);
    expect(configSet1.isDeepEquals, !configSet1WithDeepAndSortFalse.isDeepEquals);
    expect(configSet1.sort, !configSet1WithDeepAndSortFalse.sort);
    expect(configSet1.cacheHashCode, !configSet1WithDeepAndSortFalse.cacheHashCode);
  });

  test("hashCode", () {
    const ConfigSet configSet1 = ConfigSet(),
        configSet2 = ConfigSet(isDeepEquals: false),
        configSet3 = ConfigSet(sort: true),
        configSet4 = ConfigSet(cacheHashCode: false);

    expect(configSet1.hashCode, ConfigSet().hashCode);
    expect(configSet2.hashCode, ConfigSet(isDeepEquals: false).hashCode);
    expect(configSet3.hashCode, ConfigSet(sort: true).hashCode);
    expect(configSet4.hashCode, ConfigSet(cacheHashCode: false).hashCode);
    expect(configSet1.hashCode, isNot(configSet2.hashCode));
    expect(configSet1.hashCode, isNot(configSet3.hashCode));
    expect(configSet2.hashCode, isNot(configSet3.hashCode));
    expect(configSet3.hashCode, isNot(configSet4.hashCode));
  });

  test("toString", () {
    expect(
        ConfigSet().toString(), "ConfigSet{isDeepEquals: true, sort: false, cacheHashCode: true}");
    expect(ConfigSet(isDeepEquals: false).toString(),
        "ConfigSet{isDeepEquals: false, sort: false, cacheHashCode: true}");
    expect(ConfigSet(sort: true).toString(),
        "ConfigSet{isDeepEquals: true, sort: true, cacheHashCode: true}");
    expect(ConfigSet(cacheHashCode: false).toString(),
        "ConfigSet{isDeepEquals: true, sort: false, cacheHashCode: false}");
  });

  test("defaultConfig", () {
    // 1) Is initially a ConfigSet with isDeepEquals = true and sort = true
    expect(ISet.defaultConfig, const ConfigSet());
    expect(ISet.defaultConfig.isDeepEquals, isTrue);
    expect(ISet.defaultConfig.sort, isFalse);
    expect(ISet.defaultConfig.cacheHashCode, isTrue);

    // 2) Can modify the default
    ISet.defaultConfig = ConfigSet(isDeepEquals: false, sort: true, cacheHashCode: false);
    expect(
        ISet.defaultConfig, const ConfigSet(isDeepEquals: false, sort: true, cacheHashCode: false));
  });
}
