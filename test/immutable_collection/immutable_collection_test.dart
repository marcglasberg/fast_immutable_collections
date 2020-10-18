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
}
