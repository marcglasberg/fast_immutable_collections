import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  group("ConfigList |", () {
    const ConfigList configList1 = ConfigList(), configList2 = ConfigList(isDeepEquals: false);

    test("ConfigList.isDeepEquals getter", () {
      expect(configList1.isDeepEquals, isTrue);
      expect(configList2.isDeepEquals, isFalse);
    });

    test("ConfigList.== operator", () {
      final ConfigList configList3 = ConfigList(), configList4 = ConfigList(isDeepEquals: false);

      expect(configList1 == configList1, isTrue);
      expect(configList1 == configList2, isFalse);
      expect(configList1 == configList3, isTrue);
      expect(configList2 == configList2, isTrue);
      expect(configList2 == configList3, isFalse);
      expect(configList2 == configList4, isTrue);
    });

    test("ConfigList.copyWith method", () {
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

    test("ConfigList.hashCode getter", () {
      expect(configList1.hashCode, ConfigList().hashCode);
      expect(configList2.hashCode, ConfigList(isDeepEquals: false).hashCode);
      expect(configList1.hashCode, isNot(configList2.hashCode));
    });

    test("ConfigList.toString method", () {
      expect(configList1.toString(), "ConfigList{isDeepEquals: true}");
      expect(configList2.toString(), "ConfigList{isDeepEquals: false}");
    });

    group("defaultConfigList |", () {
      test("Is initially a ConfigList with isDeepEquals = true", () {
        expect(defaultConfigList, const ConfigList());
        expect(defaultConfigList.isDeepEquals, isTrue);
      });

      test("Can modify the default", () {
        defaultConfigList = ConfigList(isDeepEquals: false);
        expect(defaultConfigList, const ConfigList(isDeepEquals: false));
      });

      test("Changing the default ConfigList will throw an exception if lockConfig", () {
        lockConfig();
        expect(() => defaultConfigList = ConfigList(isDeepEquals: false), throwsStateError);
      });
    });
  });
}
