import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group("ConfigSet |", () {
    const ConfigSet configSet1 = ConfigSet(),
        configSet2 = ConfigSet(isDeepEquals: false),
        configSet3 = ConfigSet(autoSort: false);

    test("ConfigSet.isDeepEquals getter", () {
      expect(configSet1.isDeepEquals, isTrue);
      expect(configSet2.isDeepEquals, isFalse);
    });

    test("ConfigSet.autoSort getter", () {
      expect(configSet1.autoSort, isTrue);
      expect(configSet3.autoSort, isFalse);
    });

    test("ConfigSet.== operator", () {
      final ConfigSet configSet4 = ConfigSet(),
          configSet5 = ConfigSet(isDeepEquals: false),
          configSet6 = ConfigSet(autoSort: false);

      expect(configSet1 == configSet1, isTrue);
      expect(configSet1 == configSet2, isFalse);
      expect(configSet1 == configSet3, isFalse);
      expect(configSet1 == configSet4, isTrue);
      expect(configSet1 == configSet5, isFalse);
      expect(configSet1 == configSet6, isFalse);

      expect(configSet2 == configSet1, isFalse);
      expect(configSet2 == configSet2, isTrue);
      expect(configSet2 == configSet3, isFalse);
      expect(configSet2 == configSet4, isFalse);
      expect(configSet2 == configSet5, isTrue);
      expect(configSet2 == configSet6, isFalse);

      expect(configSet3 == configSet1, isFalse);
      expect(configSet3 == configSet2, isFalse);
      expect(configSet3 == configSet3, isTrue);
      expect(configSet3 == configSet4, isFalse);
      expect(configSet3 == configSet5, isFalse);
      expect(configSet3 == configSet6, isTrue);
    });

    test("ConfigSet.copyWith method", () {
      final ConfigSet configSetIdentical = configSet1.copyWith(),
          configSet1WithDeepFalse = configSet1.copyWith(isDeepEquals: false),
          configSet1WithAutoSortFalse = configSet1.copyWith(autoSort: false),
          configSet1WithDeepAndAutoSortFalse =
              configSet1.copyWith(isDeepEquals: false, autoSort: false);

      expect(identical(configSet1, configSetIdentical), isTrue);

      expect(identical(configSet1, configSet1WithDeepFalse), isFalse);
      expect(configSet1.isDeepEquals, !configSet1WithDeepFalse.isDeepEquals);
      expect(configSet1.autoSort, configSet1WithDeepFalse.autoSort);

      expect(identical(configSet1, configSet1WithAutoSortFalse), isFalse);
      expect(configSet1.isDeepEquals, configSet1WithAutoSortFalse.isDeepEquals);
      expect(configSet1.autoSort, !configSet1WithAutoSortFalse.autoSort);

      expect(identical(configSet1, configSet1WithDeepAndAutoSortFalse), isFalse);
      expect(configSet1.isDeepEquals, !configSet1WithDeepAndAutoSortFalse.isDeepEquals);
      expect(configSet1.autoSort, !configSet1WithDeepAndAutoSortFalse.autoSort);
    });

    test("ConfigSet.hashCode getter", () {
      expect(configSet1.hashCode, ConfigSet().hashCode);
      expect(configSet2.hashCode, ConfigSet(isDeepEquals: false).hashCode);
      expect(configSet3.hashCode, ConfigSet(autoSort: false).hashCode);
      expect(configSet1.hashCode, isNot(configSet2.hashCode));
      expect(configSet1.hashCode, isNot(configSet3.hashCode));
      expect(configSet2.hashCode, isNot(configSet3.hashCode));
    });

    test("ConfigSet.toString", () {
      expect(configSet1.toString(), 'ConfigSet{isDeepEquals: true, autoSort: true}');
      expect(configSet2.toString(), 'ConfigSet{isDeepEquals: false, autoSort: true}');
      expect(configSet3.toString(), 'ConfigSet{isDeepEquals: true, autoSort: false}');
    });

    // TODO: completar
    group("defaultConfigList |", () {
      test("", () {
        
      });
    });
  });
}
