import "dart:math";

import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
//    view["a"] = 2;
//    expect(view, {}                           );
    expect(() => view["a"] = 2, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.addAll({"a": 3, "d": 10}), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.addEntries([MapEntry("a", 3), MapEntry("d", 10)]), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.clear(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("putIfAbsent", () {
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.putIfAbsent("a", () => 10), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.remove("a"), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeWhere", () {
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.removeWhere((String key, int value) => key == "a"), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("update", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.update("a", (int value) => 2 * value), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("updateAll", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.updateAll((String key, int value) => 2 * value), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("shuffle", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.shuffle(Random(0)), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sort", () {
    // TODO: Specify
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    expect(() => view.sort(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////
}
