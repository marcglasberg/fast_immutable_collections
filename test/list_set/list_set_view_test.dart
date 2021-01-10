import "dart:math";

import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("add", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).add(100), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).addAll([100, 1000]), throwsUnsupportedError);
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).addAll({100, 1000}), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("cast", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).cast<num>(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).clear(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).remove(10), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAll({10}), throwsUnsupportedError);
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAll([10]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeWhere((int value) => value == 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("retainAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).retainAll([10, 50]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("retainWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).retainWhere((int value) => value == 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view[1] = 100;
//    expect(view[1], 100);
    expect(() => view[1] = 100, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("retainWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).fillRange(1, 3, 100), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("first", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.first = 100;
//    expect(view.first, 100);
    expect(() => view.first = 100, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("indexWhere", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.indexWhere((int value) => value == 10), 1);
    expect(() => view.indexWhere((int value) => value == 10), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("insert", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).insert(1, 100), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("insertAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).insertAll(1, [100, 1000]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("last", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.last = 100;
//    expect(view.last, 100);
    expect(() => view.last = 100, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("lastIndexOf", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.lastIndexOf(-2), 3);
    expect(() => view.lastIndexOf(-2), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("lastIndexWhere", () {
    // This is not yet supported, but will be in the future.
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.lastIndexWhere((int value) => value == -2), 3);
    expect(() => view.lastIndexWhere((int value) => value == -2), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("length setter", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).length = 10, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAt", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAt(1), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeLast", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeLast(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeRange", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeRange(1, 3), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("replaceRange", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.replaceRange(1, 3, [100, 1000]);
//    expect(view, [1, 100, 1000, -2, 8, 20]);
    expect(() => view.replaceRange(1, 3, [100, 1000]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversed", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.reversed, allOf(isA<Iterable<int>>(), [20, 8, -2, 50, 10, 1]));
    expect(() => view.reversed, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("reversedView", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.reversedView, allOf(isA<ListSetView<int>>(), [20, 8, -2, 50, 10, 1]));
    expect(() => view.reversedView, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("setAll", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.setAll(1, [100, 1000]);
//    expect(view, [1, 100, 1000, 10, 50, -2, 8, 20]);
    expect(() => view.setAll(1, [100, 1000]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("setRange", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.setRange(1, 5, [100, 1000]);
//    expect(view, [1, 100, 1000, -2, 8, 20]);
    expect(() => view.setRange(1, 5, [100, 1000]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("shuffle", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.shuffle(Random(0));
//    expect(view, [1, 10, 50, -2, 8, 20]);
    expect(() => view.shuffle(Random(0)), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sort", () {
    ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.sort();
//    expect(view, [-2, 1, 8, 10, 20, 50]);
    expect(() => view.sort(), throwsUnsupportedError);

    view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.sort((int a, int b) => -a.compareTo(b));
//    expect(view, [50, 20, 10, 8, 1, -2]);
    expect(() => view.sort(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sublist", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.sublist(1, 3), allOf(isA<List<int>>(), [10, 50]));
    expect(() => view.sublist(1, 3), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////
}
