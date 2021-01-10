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
    // 1) Regular usage
    var set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]);
    expect(set, [1, 10, 50, -2, 8, 20]);
    expect(set.length, 6);

    set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20], sort: true);
    expect(set, [-2, 1, 8, 10, 20, 50]);
    expect(set.length, 6);

    set = ListSet.of([1, 10, 50, -2, 8, 10, -2, 20],
        sort: true, compare: (int a, int b) => -a.compareTo(b));
    expect(set, [50, 20, 10, 8, 1, -2]);
    expect(set.length, 6);

    // 2) Nulls and other edge cases
    set = ListSet.of(null);
    expect(set, []);
    expect(set.length, 0);

    set = ListSet.of([]);
    expect(set, []);
    expect(set.length, 0);

    set = ListSet.of([2, 1, 3], sort: null);
    expect(set, [2, 1, 3]);
    expect(set.length, 3);

    set = ListSet.of([2, 1, 3], compare: null);
    expect(set, [2, 1, 3]);
    expect(set.length, 3);
  }, skip: true);

  /////////////////////////////////////////////////////////////////////////////

  test("add", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).add(100), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("add", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).addAll([100, 1000]),
        throwsUnsupportedError);
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).addAll({100, 1000}),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("clear", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).clear(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("remove", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).remove(10), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeWhere", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeWhere((int value) => value > 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("retainsAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).retainAll([10, 50, 100]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("retainWhere", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).retainWhere((int value) => value > 10),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("[]=", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20])[3] = 1000, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("fillRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).fillRange(1, 3, 1000),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("first setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).first = 1000, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("insert", () {
    expect(
        () => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insert(3, 1000), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("insertAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insertAll(3, [1000, 100]),
        throwsUnsupportedError);
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).insertAll(3, {1000, 100}),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("last setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).last = 1000, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("length setter", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).length = 1000, throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAt", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeAt(10), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeLast", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeLast(), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeRange", () {
    expect(
        () => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).removeRange(1, 5), throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("replaceRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).replaceRange(1, 5, [100, 1000]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("setAll", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).setAll(5, [100, 1000]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("setRange", () {
    expect(() => ListSet.of([1, 10, 50, -2, 8, 10, -2, 20]).setRange(1, 5, [100, 1000]),
        throwsUnsupportedError);
  });

  /////////////////////////////////////////////////////////////////////////////
}
