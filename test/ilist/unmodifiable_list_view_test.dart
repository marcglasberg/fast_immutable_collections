import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  test("Simple Empty Initialization", () {
    final UnmodifiableListView unmodifiableListView1 = UnmodifiableListView([].lock);
    final UnmodifiableListView unmodifiableListView2 = UnmodifiableListView(null);

    expect(unmodifiableListView1.isEmpty, isTrue);
    expect(unmodifiableListView2.isEmpty, isTrue);
  });

  test("Non-mutable operations | UnmodifiableListView.[] operator", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListView<int> view) {
      expect(view[0], 1);
      expect(view[1], 2);
      expect(view[2], 3);
    });
  });

  test("Non-mutable operations | UnmodifiableListView.length getter", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListView<int> view) => expect(view.length, baseList.length));
  });

  test("Non-mutable operations | UnmodifiableListView.lock getter", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListView<int> view) => expect(view.lock, allOf(isA<IList<int>>(), baseList)));
  });

  test("Non-mutable operations | Emptiness properties", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListView<int> view) {
      expect(view.isEmpty, isFalse);
      expect(view.isNotEmpty, isTrue);
    });
  });

  test("Mutations are not allowed | UnmodifiableListView.[]= operator", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListView<int> view) => expect(() => view[0] = 10, throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableListView.length setter", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListView<int> view) => expect(() => view.length = 10, throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableListView.add method", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListView<int> view) => expect(() => view.add(4), throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableListView.addAll method", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach((UnmodifiableListView<int> view) =>
        expect(() => view.addAll([4, 5]), throwsUnsupportedError));
  });

  test("Mutations are not allowed | UnmodifiableListView.remove method", () {
    const List<int> baseList = [1, 2, 3];
    final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(baseList.lock),
        unmodifiableListViewFromList = UnmodifiableListView.fromList(baseList);
    final List<UnmodifiableListView<int>> views = [
      unmodifiableListView,
      unmodifiableListViewFromList,
    ];

    views.forEach(
        (UnmodifiableListView<int> view) => expect(() => view.remove(3), throwsUnsupportedError));
  });
}
