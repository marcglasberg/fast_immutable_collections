import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("isDeepEquals", () {
    expect(ConfigList().isDeepEquals, isTrue);
    expect(ConfigList(isDeepEquals: false).isDeepEquals, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("==", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);
    final ConfigList configList3 = ConfigList(), configList4 = ConfigList(isDeepEquals: false);

    expect(configList1 == configList1, isTrue);
    expect(configList1 == configList2, isFalse);
    expect(configList1 == configList3, isTrue);
    expect(configList2 == configList2, isTrue);
    expect(configList2 == configList3, isFalse);
    expect(configList2 == configList4, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("copyWith", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);
    final ConfigList configList1WithTrue = configList1.copyWith(isDeepEquals: true),
        configList1WithFalse = configList1.copyWith(isDeepEquals: false),
        configList2WithTrue = configList2.copyWith(isDeepEquals: true),
        configList2WithFalse = configList2.copyWith(isDeepEquals: false);

    expect(identical(configList1, configList1WithTrue), isTrue);
    expect(configList1.isDeepEquals, configList1WithTrue.isDeepEquals);
    expect(configList1.isDeepEquals, !configList1WithFalse.isDeepEquals);

    expect(identical(configList2, configList2WithFalse), isTrue);
    expect(configList2.isDeepEquals, configList2WithFalse.isDeepEquals);
    expect(configList2.isDeepEquals, !configList2WithTrue.isDeepEquals);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("hashCode", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);
    expect(configList1.hashCode, ConfigList().hashCode);
    expect(configList2.hashCode, ConfigList(isDeepEquals: false).hashCode);
    expect(configList1.hashCode, isNot(configList2.hashCode));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("toString", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);
    expect(configList1.toString(), "ConfigList{isDeepEquals: true, cacheHashCode: true}");
    expect(configList2.toString(), "ConfigList{isDeepEquals: false, cacheHashCode: true}");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("defaultConfig", () {
    // 1) Is initially a ConfigList with isDeepEquals = true
    expect(IList.defaultConfig, const ConfigList());
    expect(IList.defaultConfig.isDeepEquals, isTrue);

    // 2) Can modify the default
    IList.defaultConfig = ConfigList(isDeepEquals: false);
    expect(IList.defaultConfig, const ConfigList(isDeepEquals: false));
  });

  //////////////////////////////////////////////////////////////////////////////
}
