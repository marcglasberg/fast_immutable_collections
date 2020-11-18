import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Non-mutable operations | UnmodifiableSetView.length getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach((UnmodifiableSetView<int> view) => expect(view.length, 3));
  });

  test("Non-mutable operations | UnmodifiableSetView.lock getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach(
        (UnmodifiableSetView<int> view) => expect(view.lock, allOf(isA<ISet<int>>(), baseSet)));
  });

  test("Non-mutable operations | isEmpty | isNotEmpty", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach((UnmodifiableSetView<int> view) {
      expect(view.isEmpty, isFalse);
      expect(view.isNotEmpty, isTrue);
    });
  });

  test("Non-mutable operations | UnmodifiableSetView.toSet()", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach((UnmodifiableSetView<int> view) => expect(view.toSet(), baseSet));
  });

  test("Non-mutable operations | UnmodifiableSetView.contains method", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach((UnmodifiableSetView<int> view) {
      expect(view.contains(1), isTrue);
      expect(view.contains(2), isTrue);
      expect(view.contains(3), isTrue);
      expect(view.contains(4), isFalse);
    });
  });

  test("Non-mutable operations | UnmodifiableSetView.lookup()", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach((UnmodifiableSetView<int> view) {
      expect(view.lookup(1), 1);
      expect(view.lookup(2), 2);
      expect(view.lookup(3), 3);
      expect(view.lookup(4), null);
    });
  });

  test("Non-mutable operations | UnmodifiableSetView.iterator getter", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];
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

  test("UnmodifiableSetView.add()", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach(
        (UnmodifiableSetView<int> view) => expect(() => view.add(4), throwsUnsupportedError));
  });

  test("UnmodifiableSetView.remove()", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetView<int> unmodifiableSetView = UnmodifiableSetView(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetView.fromSet(baseSet);
    final List<UnmodifiableSetView<int>> views = [unmodifiableSetView, unmodifiableSetViewFromSet];

    views.forEach(
        (UnmodifiableSetView<int> view) => expect(() => view.remove(2), throwsUnsupportedError));
  });
}
