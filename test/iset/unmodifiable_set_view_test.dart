import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const Set<int> baseSet = {1, 2, 3};
  final ISet<int> iSet = baseSet.lock;
  final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(iSet),
      unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
  final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

  group("Non-mutable operations |", () {
    test("UnmodifiableSetView.length getter",
        () => views.forEach((UnmodifiableSetView<int> view) => expect(view.length, 3)));

    test(
        "UnmodifiableSetView.lock getter",
        () => views.forEach((UnmodifiableSetView<int> view) =>
            expect(view.lock, allOf(isA<ISet<int>>(), baseSet))));

    test(
        "Emptiness properties",
        () => views.forEach((UnmodifiableSetView<int> view) {
              expect(view.isEmpty, isFalse);
              expect(view.isNotEmpty, isTrue);
            }));

    test("UnmodifiableSetView.toSet method",
        () => views.forEach((UnmodifiableSetView<int> view) => expect(view.toSet(), baseSet)));

    test("UnmodifiableSetView.contains method", () {
      views.forEach((UnmodifiableSetView<int> view) {
        expect(view.contains(1), isTrue);
        expect(view.contains(2), isTrue);
        expect(view.contains(3), isTrue);
        expect(view.contains(4), isFalse);
      });
    });

    test("UnmodifiableSetView.lookup method", () {
      views.forEach((UnmodifiableSetView<int> view) {
        expect(view.lookup(1), 1);
        expect(view.lookup(2), 2);
        expect(view.lookup(3), 3);
        expect(view.lookup(4), null);
      });
    });

    test("UnmodifiableSetView.iterator getter", () {
      final Iterator<int> iterator = unmodifiableSetView.iterator,
          iteratorFromSet = unmodifiableSetViewFromSet.iterator;
      final List<Iterator<int>> iterators = [iterator, iteratorFromSet];

      iterators.forEach((Iterator<int> iterator) {
        int count = 0;
        final Set<int> result = {};
        while (iterator.moveNext()) {
          count++;
          result.add(iterator.current);
        }
        expect(count, baseSet.length);
        expect(result, baseSet);
      });
    });
  });

  group("Mutations are not allowed |", () {
    test(
        "UnmodifiableSetView.add method",
        () => views.forEach((UnmodifiableSetView<int> view) =>
            expect(() => view.add(4), throwsUnsupportedError)));

    test(
        "UnmodifiableSetView.remove method",
        () => views.forEach((UnmodifiableSetView<int> view) =>
            expect(() => view.remove(2), throwsUnsupportedError)));
  });
}
