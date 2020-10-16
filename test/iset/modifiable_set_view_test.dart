import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const Set<int> baseSet = {1, 2, 3};
  final ISet<int> iSet = baseSet.lock;

  group("Non mutable operations |", () {
    final ModifiableSetView<int> modifiableSetView = ModifiableSetView(iSet);

    test("ModifiableSetView.length getter", () => expect(modifiableSetView.length, baseSet.length));

    test("ModifiableSetView.lock getter",
        () => expect(modifiableSetView.lock, allOf(isA<ISet<int>>(), baseSet)));

    test("Emptiness Properties", () {
      expect(modifiableSetView.isEmpty, isFalse);
      expect(modifiableSetView.isNotEmpty, isTrue);
    });

    test("ModifiableSetView.contains method", () {
      expect(modifiableSetView.contains(1), isTrue);
      expect(modifiableSetView.contains(2), isTrue);
      expect(modifiableSetView.contains(3), isTrue);
      expect(modifiableSetView.contains(4), isFalse);
    });

    test("ModifiableSetView.iterator getter", () {
      final Iterator<int> iterator = modifiableSetView.iterator;

      int count = 0;
      final Set<int> result = {};
      while (iterator.moveNext()) {
        count++;
        result.add(iterator.current);
      }
      expect(count, baseSet.length);
      expect(result, baseSet);
    });

    test("ModifiableSetView.toSet method", () => expect(modifiableSetView.toSet(), baseSet));

    test("ModifiableSetView.lookup method", () {
      expect(modifiableSetView.lookup(1), 1);
      expect(modifiableSetView.lookup(2), 2);
      expect(modifiableSetView.lookup(3), 3);
      expect(modifiableSetView.lookup(4), null);
    });
  });

  group("Mutations are allowed |", () {
    ModifiableSetView<int> modifiableSetView;

    setUp(() => modifiableSetView = ModifiableSetView(iSet));

    test("ModifiableSetView.add method", () {
      expect(modifiableSetView.add(3), isFalse);
      expect(modifiableSetView.add(4), isTrue);
      expect(modifiableSetView.length, 4);
      expect(modifiableSetView.contains(4), isTrue);
    });

    test("ModifiableSetView.remove method", () {
      expect(modifiableSetView.remove(4), isFalse);
      expect(modifiableSetView.remove(3), isTrue);
      expect(modifiableSetView.length, 2);
      expect(modifiableSetView.contains(3), isFalse);
    });
  });
}
