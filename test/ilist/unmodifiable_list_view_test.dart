import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("Simple Empty Initialization", () {
    expect(UnmodifiableListFromIList([].lock).isEmpty, isTrue);
    expect(UnmodifiableListFromIList(null).isEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("[]", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) {
      expect(view[0], 1);
      expect(view[1], 2);
      expect(view[2], 3);
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("length", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) => expect(view.length, baseList.length));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("lock", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) =>
        expect(view.lock, allOf(isA<IList<int>>(), baseList)));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("isEmpty | isNotEmpty", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) {
      expect(view.isEmpty, isFalse);
      expect(view.isNotEmpty, isTrue);
    });
  });

  //////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) =>
        expect(() => view[0] = 10, throwsUnsupportedError));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("length", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) =>
        expect(() => view.length = 10, throwsUnsupportedError));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("add", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListFromIList<int> view) => expect(() => view.add(4), throwsUnsupportedError));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) =>
        expect(() => view.addAll([4, 5]), throwsUnsupportedError));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListFromIList<int> unmodifiableListView =
            UnmodifiableListFromIList(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListFromIList.fromList(baseList);
    final List<UnmodifiableListFromIList<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListFromIList<int> view) =>
        expect(() => view.remove(3), throwsUnsupportedError));
  });
}
