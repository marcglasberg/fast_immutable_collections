// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("Empty Initialization", () {
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(null);
    expect(unmodifiableSetView.lock, allOf(isA<ISet<int>>(), <int>{}));
  });

  test("length", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) => expect(view.length, 3));
  });

  test("lock", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach(
        (UnmodifiableSetFromISet<int> view) => expect(view.lock, allOf(isA<ISet<int>>(), baseSet)));
  });

  test("isEmpty | isNotEmpty", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) {
      expect(view.isEmpty, isFalse);
      expect(view.isNotEmpty, isTrue);
    });
  });

  test("toSet", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) => expect(view.toSet(), baseSet));
  });

  test("contains", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) {
      expect(view.contains(1), isTrue);
      expect(view.contains(2), isTrue);
      expect(view.contains(3), isTrue);
      expect(view.contains(4), isFalse);
      expect(view.contains(null), isFalse);
    });
  });

  test("lookup", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) {
      expect(view.lookup(1), 1);
      expect(view.lookup(2), 2);
      expect(view.lookup(3), 3);
      expect(view.lookup(4), null);
    });
  });

  test("iterator", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final Iterator<int?> iterator = unmodifiableSetView.iterator,
        iteratorFromSet = unmodifiableSetViewFromSet.iterator;
    final List<Iterator<int?>> iterators = [iterator, iteratorFromSet];

    iterators.forEach((Iterator<int?> iterator) {
      int count = 0;
      final Set<int?> result = {};
      while (iterator.moveNext()) {
        count++;
        result.add(iterator.current);
      }
      expect(count, baseSet.length);
      expect(result, baseSet);
    });
  });

  test("add", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach(
        (UnmodifiableSetFromISet<int> view) => expect(() => view.add(4), throwsUnsupportedError));
  });

  test("remove", () {
    const Set<int> baseSet = {1, 2, 3};
    final UnmodifiableSetFromISet<int> unmodifiableSetView = UnmodifiableSetFromISet(baseSet.lock),
        unmodifiableSetViewFromSet = UnmodifiableSetFromISet.fromSet(baseSet);
    final List<UnmodifiableSetFromISet<int>> views = [
      unmodifiableSetView,
      unmodifiableSetViewFromSet
    ];

    views.forEach((UnmodifiableSetFromISet<int> view) =>
        expect(() => view.remove(2), throwsUnsupportedError));
  });
}
