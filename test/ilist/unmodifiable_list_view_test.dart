import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  const List<int> baseList = [1, 2, 3];
  final IList<int> iList = baseList.lock;
  final UnmodifiableListView<int> unmodifiableListView = UnmodifiableListView(iList),
      unmodifiableListViewFromList = UnmodifiableListView.from(baseList);
  final List<UnmodifiableListView<int>> views = [
    unmodifiableListView,
    unmodifiableListViewFromList,
  ];

  group("Non mutable operations |", () {
    test(
        "UnmodifiableListView.[] operator",
        () => views.forEach((UnmodifiableListView<int> view) {
              expect(view[0], 1);
              expect(view[1], 2);
              expect(view[2], 3);
            }));

    test(
        "UnmodifiableListView.length getter",
        () => views
            .forEach((UnmodifiableListView<int> view) => expect(view.length, baseList.length)));

    test(
        "UnmodifiableListView.lock getter",
        () => views.forEach((UnmodifiableListView<int> view) =>
            expect(view.lock, allOf(isA<IList<int>>(), baseList))));

    test("Emptiness properties", () {
      views.forEach((UnmodifiableListView<int> view) {
        expect(view.isEmpty, isFalse);
        expect(view.isNotEmpty, isTrue);
      });
    });
  });

  group("Mutations are not allowed |", () {
    test(
        "UnmodifiableListView.[]= operator",
        () => views.forEach((UnmodifiableListView<int> view) =>
            expect(() => view[0] = 10, throwsUnsupportedError)));

    test(
        "UnmodifiableListView.length setter",
        () => views.forEach((UnmodifiableListView<int> view) =>
            expect(() => view.length = 10, throwsUnsupportedError)));

    test(
        "UnmodifiableListView.add method",
        () => views.forEach((UnmodifiableListView<int> view) =>
            expect(() => view.add(4), throwsUnsupportedError)));

    test(
        "UnmodifiableListView.remove method",
        () => views.forEach((UnmodifiableListView<int> view) =>
            expect(() => view.remove(3), throwsUnsupportedError)));
  });
}
