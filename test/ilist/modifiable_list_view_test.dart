import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group("Non-mutable operations |", () {
    final IList<int> iList = [1, 2, 3].lock;
    final ModifiableListView<int> modifiableListView = ModifiableListView(iList);

    test("ModifiableListView.[] operator", () {
      expect(modifiableListView[0], 1);
      expect(modifiableListView[1], 2);
      expect(modifiableListView[2], 3);
    });

    test("ModifiableListView.length getter", () => expect(modifiableListView.length, 3));

    test("ModifiableListView.lock getter", () {
      expect(modifiableListView.lock, isA<IList<int>>());
      expect(modifiableListView.lock, [1, 2, 3]);
    });

    test("Emptiness properties", () {
      expect(modifiableListView.isEmpty, isFalse);
      expect(modifiableListView.isNotEmpty, isTrue);
    });
  });

  group("Mutations are allowed |", () {
    final IList<int> iList = [1, 2, 3].lock;

    ModifiableListView<int> modifiableListView;

    setUp(() => modifiableListView = ModifiableListView(iList));

    test("ModifiableListView.[]= operator", () {
      modifiableListView[2] = 4;
      expect(modifiableListView.length, 3);
      expect(modifiableListView[2], 4);
    });

    test("ModifiableListView.length setter", () {
      modifiableListView.length = 2;
      expect(modifiableListView.length, 2);

      modifiableListView.length = 4;
      expect(modifiableListView.length, 4);
    });

    test("ModifiableListView.add method", () {
      // TODO: Marcelo, o `add` do `ListMixin` acho que utiliza o operador []= para fazer a adição.
      // Além disso, na documentação do `ListMixin, é mencionado que aumentar o tamanho da lista
      // forçadamente é ineficiente e que seria uma primeira otimização para quem quisesse melhorar
      // a performance do Mixin.
      modifiableListView.add(4);
      expect(modifiableListView.length, 4);
      expect(modifiableListView.last, 4);
    });

    test("ModifiableListView.addAll method", () {
      modifiableListView.addAll([4, 5]);
      expect(modifiableListView.length, 5);
      expect(modifiableListView[3], 4);
      expect(modifiableListView[4], 5);
    });

    test("ModifiableListView.remove method", () {
      modifiableListView.remove(2);
      expect(modifiableListView.length, 2);
      expect(modifiableListView[0], 1);
      expect(modifiableListView[1], 3);
    });
  });
}
