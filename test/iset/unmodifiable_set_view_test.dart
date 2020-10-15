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
