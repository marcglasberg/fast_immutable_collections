import "package:test/test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("empty", () {
    var set = ListSet.empty();
    expect(set.isEmpty, isTrue);
    expect(set.isNotEmpty, isFalse);
    expect(set.length, 0);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("From iterable", () {
    var set = ListSet.from([1, 10, 50, -2, 8, 10, -2, 20]);
    expect(set, [1, 10, 50, -2, 8, 20]);
    expect(set.length, 6);
  });

  /////////////////////////////////////////////////////////////////////////////
}
