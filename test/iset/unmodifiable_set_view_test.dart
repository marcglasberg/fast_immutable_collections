import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const Set<int> sety = {1, 2, 3};
  final ISet<int> iSet = sety.lock;
  final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(iSet),
      unmodifiableSetViewFromSet = UnmodifiableSetView.from(sety);

  group("Basic Operations |", () {
    test("UnmodifiableSetView.length getter", () {
      expect(unmodifiableSetView.length, 3);
      expect(unmodifiableSetViewFromSet.length, 3);
    });

    test("UnmodifiableSetView.lock operator", () {
      expect(unmodifiableSetView.lock, isA<ISet<int>>());
      expect(unmodifiableSetViewFromSet.lock, isA<ISet<int>>());
      expect(unmodifiableSetView.lock, {1, 2, 3});
      expect(unmodifiableSetViewFromSet.lock, {1, 2, 3});
    });

    test("Emptiness properties", () {
      expect(unmodifiableSetViewFromSet.isEmpty, isFalse);
      expect(unmodifiableSetViewFromSet.isNotEmpty, isTrue);
    });

    test("UnmodifiableSetView.toSet method", () {
      expect(unmodifiableSetView.toSet(), {1, 2, 3});
      expect(unmodifiableSetViewFromSet.toSet(), {1, 2, 3});
    });

    test("UnmodifiableSetView.contains method", () {
      expect(unmodifiableSetView.contains(1), isTrue);
      expect(unmodifiableSetView.contains(2), isTrue);
      expect(unmodifiableSetView.contains(3), isTrue);
      expect(unmodifiableSetView.contains(4), isFalse);
      expect(unmodifiableSetViewFromSet.contains(1), isTrue);
      expect(unmodifiableSetViewFromSet.contains(2), isTrue);
      expect(unmodifiableSetViewFromSet.contains(3), isTrue);
      expect(unmodifiableSetViewFromSet.contains(4), isFalse);
    });

    test("UnmodifiableSetView.lookup method", () {
      expect(unmodifiableSetView.lookup(1), 1);
      expect(unmodifiableSetView.lookup(2), 2);
      expect(unmodifiableSetView.lookup(3), 3);
      expect(unmodifiableSetView.lookup(4), null);
      expect(unmodifiableSetViewFromSet.lookup(1), 1);
      expect(unmodifiableSetViewFromSet.lookup(2), 2);
      expect(unmodifiableSetViewFromSet.lookup(3), 3);
      expect(unmodifiableSetViewFromSet.lookup(4), null);
    });

    test("UnmodifiableSetView.iterator getter", () {
      final Iterator<int> iterator = unmodifiableSetView.iterator,
          iteratorFromSet = unmodifiableSetViewFromSet.iterator;

      expect(iterator.current, isNull);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 1);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 2);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 3);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.current, isNull);
      expect(iteratorFromSet.current, isNull);
      expect(iteratorFromSet.moveNext(), isTrue);
      expect(iteratorFromSet.current, 1);
      expect(iteratorFromSet.moveNext(), isTrue);
      expect(iteratorFromSet.current, 2);
      expect(iteratorFromSet.moveNext(), isTrue);
      expect(iteratorFromSet.current, 3);
      expect(iteratorFromSet.moveNext(), isFalse);
      expect(iteratorFromSet.current, isNull);
    });
  });

  group("Mutations are not allowed |", () {
    test("UnmodifiableSetView.add method",
        () => expect(() => unmodifiableSetView.add(4), throwsUnsupportedError));

    test("UnmodifiableSetView.addAll method",
        () => expect(() => unmodifiableSetView.addAll({4, 5}), throwsUnsupportedError));

    test("UnmodifiableSetView.remove method",
        () => expect(() => unmodifiableSetView.remove(2), throwsUnsupportedError));
  });
}
