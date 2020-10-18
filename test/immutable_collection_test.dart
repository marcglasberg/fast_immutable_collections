import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group("sameCollection function |", () {
    // TODO: Marcelo, apesar de que a documentação esclarece isso, eu tenho certeza que quem ler
    // esse nome (`sameCollection`) vai certamente pensar que ela checa se ambos os objetos são
    // `IList`, `ISet`, etc. Ainda acho que algo como `sameCollectionInternals` seria mais claro.
    test("If both are null, then true", () => expect(sameCollection(null, null), isTrue));

    test("If one of them is not null, then false", () {
      expect(sameCollection(IList(), null), isFalse);
      expect(sameCollection(null, IList()), isFalse);
    });

    test("If none of them is null, then use .same()", () {
      final IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]);
      final IList<int> iList3 = iList1.remove(3);

      expect(sameCollection(iList1, iList2), isFalse);
      expect(sameCollection(iList1, iList3), isTrue);
    });
  });

  group("disallowUnsafeConstructors |", () {
    test("Is initially false", () => expect(disallowUnsafeConstructors, isFalse));

    test("Changing the default to true", () {
      expect(disallowUnsafeConstructors, isFalse);
      disallowUnsafeConstructors = true;
      expect(disallowUnsafeConstructors, isTrue);
    });

    test("Changing the lockConfig makes disallowUnsafeConstructors throw an exception", () {
      lockConfig();
      expect(() => disallowUnsafeConstructors = true, throwsStateError);
    });
  });

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
      expect(configList1.toString(), 'ConfigList{isDeepEquals: true}');
      expect(configList2.toString(), 'ConfigList{isDeepEquals: false}');
    });
  });

  // TODO: completar
  group("ConfigSet", () {});

  // TODO: completar
  group("ConfigMap", () {});
}
