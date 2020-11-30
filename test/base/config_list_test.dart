import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("ConfigList.isDeepEquals getter", () {
    expect(ConfigList().isDeepEquals, isTrue);
    expect(ConfigList(isDeepEquals: false).isDeepEquals, isFalse);
  });

  test("ConfigList.cacheHashCode getter", () {
    expect(ConfigList().cacheHashCode, isTrue);
    expect(ConfigList(cacheHashCode: false).cacheHashCode, isFalse);
  });

  test("ConfigList.== operator", () {
    const ConfigList configList1 = ConfigList(),
        configList2 = ConfigList(isDeepEquals: false),
        configList3 = ConfigList(cacheHashCode: false);
    final ConfigList configList4 = ConfigList(),
        configList5 = ConfigList(isDeepEquals: false),
        configList6 = ConfigList(cacheHashCode: false);

    expect(configList1 == configList1, isTrue);
    expect(configList1 == configList2, isFalse);
    expect(configList1 == configList3, isFalse);
    expect(configList1 == configList4, isTrue);
    expect(configList1 == configList5, isFalse);
    expect(configList1 == configList6, isFalse);

    expect(configList2 == configList1, isFalse);
    expect(configList2 == configList2, isTrue);
    expect(configList2 == configList3, isFalse);
    expect(configList2 == configList4, isFalse);
    expect(configList2 == configList5, isTrue);
    expect(configList2 == configList6, isFalse);
  });

  test("ConfigList.copyWith()", () {
    const ConfigList configList1 = ConfigList(),
        configList2 = ConfigList(isDeepEquals: false),
        configList3 = ConfigList(cacheHashCode: false);
    final ConfigList configList1WithTrue = configList1.copyWith(isDeepEquals: true),
        configList1WithFalse = configList1.copyWith(isDeepEquals: false),
        configList2WithTrue = configList2.copyWith(isDeepEquals: true),
        configList2WithFalse = configList2.copyWith(isDeepEquals: false),
        configList3WithTrue = configList3.copyWith(cacheHashCode: true),
        configList3WithFalse = configList3.copyWith(cacheHashCode: false);

    expect(identical(configList1, configList1WithTrue), isTrue);
    expect(configList1.isDeepEquals, configList1WithTrue.isDeepEquals);
    expect(configList1.isDeepEquals, !configList1WithFalse.isDeepEquals);

    expect(identical(configList2, configList2WithFalse), isTrue);
    expect(configList2.isDeepEquals, configList2WithFalse.isDeepEquals);
    expect(configList2.isDeepEquals, !configList2WithTrue.isDeepEquals);

    expect(identical(configList3, configList3WithFalse), isTrue);
    expect(configList3.cacheHashCode, configList3WithFalse.cacheHashCode);
    expect(configList3.cacheHashCode, !configList3WithTrue.cacheHashCode);
  });

  test("ConfigList.hashCode getter", () {
    const ConfigList configList1 = ConfigList(),
        configList2 = ConfigList(isDeepEquals: false),
        configList3 = ConfigList(cacheHashCode: false);
    expect(configList1.hashCode, ConfigList().hashCode);
    expect(configList2.hashCode, ConfigList(isDeepEquals: false).hashCode);
    expect(configList3.hashCode, ConfigList(cacheHashCode: false).hashCode);
    expect(configList1.hashCode, isNot(configList2.hashCode));
    expect(configList1.hashCode, isNot(configList3.hashCode));
  });

  test("ConfigList.toString()", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);
    expect(configList1.toString(), "ConfigList{isDeepEquals: true, cacheHashCode: true}");
    expect(configList2.toString(), "ConfigList{isDeepEquals: false, cacheHashCode: true}");
  });

  test("defaultConfig | Is initially a ConfigList with isDeepEquals = true", () {
    expect(IList.defaultConfig, const ConfigList());
    expect(IList.defaultConfig.isDeepEquals, isTrue);
    expect(IList.defaultConfig.cacheHashCode, isTrue);
  });

  test("defaultConfig | Can modify the default", () {
    IList.defaultConfig = ConfigList(isDeepEquals: false, cacheHashCode: false);
    expect(IList.defaultConfig, const ConfigList(isDeepEquals: false, cacheHashCode: false));
  });

  test("defaultConfig | Changing the default ConfigList will throw an exception if lockConfig", () {
    ImmutableCollection.lockConfig();
    expect(() => IList.defaultConfig = ConfigList(isDeepEquals: false, cacheHashCode: false),
        throwsStateError);
  });
}
