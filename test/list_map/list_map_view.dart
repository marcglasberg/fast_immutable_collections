import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    final ListMapView<String, int> view = ListMapView({"b": 1, "a": 2, "c": 10});
    view["a"] = 2;
    expect(view, {}                           );
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {});

  /////////////////////////////////////////////////////////////////////////////
}
