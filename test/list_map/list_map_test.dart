import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10})["a"] = 100, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).addAll({"a": 3, "d": 10}),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll", () {
    // TODO: Complete specification
    expect(
        () =>
            ListMap.of({"b": 1, "a": 2, "c": 10}).addEntries([MapEntry("a", 3), MapEntry("d", 10)]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).clear(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("putIfAbsent", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).putIfAbsent("d", () => 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).remove("d"), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeWhere", () {
    expect(
        () => ListMap.of({"b": 1, "a": 2, "c": 10})
            .removeWhere((String key, int value) => key == "a"),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("update", () {
    // TODO: Complete specification
    expect(() => ListMap.of({"b": 1, "a": 2, "c": 10}).update("d", (int value) => 2 * value),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("updateAll", () {
    // TODO: Complete specification
    expect(
        () => ListMap.of({"b": 1, "a": 2, "c": 10}).updateAll((String key, int value) => 2 * value),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////
}
