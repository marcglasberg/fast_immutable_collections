// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: collection_methods_unrelated_type
import "dart:convert";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("ListSet.fromJson", () {
    final ListSet<int> listSet = ListSet.fromJson([3, 1, 2], (e) => e as int);
    expect(listSet, isA<ListSet<int>>());
    expect(listSet, [3, 1, 2]);
    expect(listSet.length, 3);
    expect(listSet[0], 3);

    // Duplicates are removed, keeping the first occurrence.
    final ListSet<int> dedup = ListSet.fromJson([3, 1, 3, 2, 1], (e) => e as int);
    expect(dedup, [3, 1, 2]);

    // Converting the items.
    final ListSet<String> strings = ListSet.fromJson([1, 2], (e) => "v$e");
    expect(strings, ["v1", "v2"]);

    // Empty.
    expect(ListSet<int>.fromJson([], (e) => e as int), isEmpty);

    // From a decoded JSON string.
    final ListSet<String> decoded = ListSet.fromJson(jsonDecode('["a","b","a"]'), (e) => e as String);
    expect(decoded, ["a", "b"]);

    // Not an Iterable.
    expect(() => ListSet<int>.fromJson(1, (e) => e as int), throwsA(isA<TypeError>()));
  });

  test("ListSet.toJson", () {
    final ListSet<int> listSet = ListSet.of([3, 1, 2]);
    final Object json = listSet.toJson((e) => e);
    expect(json, isA<List>());
    expect(json, [3, 1, 2]);

    expect(listSet.toJson((e) => "v$e"), ["v3", "v1", "v2"]);
    expect(ListSet<int>.empty().toJson((e) => e), []);

    // Round-trip.
    final Object roundTrip = ListSet<int>.fromJson(listSet.toJson((e) => e), (e) => e as int);
    expect(roundTrip, [3, 1, 2]);
    expect(jsonEncode(listSet.toJson((e) => e)), "[3,1,2]");

    // Keeps the sorted order.
    final ListSet<int> sorted = ListSet.of([3, 1, 2], sort: true);
    expect(sorted.toJson((e) => e), [1, 2, 3]);
  });

  test("ListSetView.fromJson", () {
    final ListSetView<int> view = ListSetView.fromJson([3, 1, 2, 1], (e) => e as int);
    expect(view, isA<ListSetView<int>>());
    expect(view, [3, 1, 2]);
    expect(view.length, 3);
    expect(view.contains(2), isTrue);

    final ListSetView<String> strings = ListSetView.fromJson([1, 2], (e) => "v$e");
    expect(strings, ["v1", "v2"]);

    expect(ListSetView<int>.fromJson([], (e) => e as int), isEmpty);
    expect(() => ListSetView<int>.fromJson("x", (e) => e as int), throwsA(isA<TypeError>()));
  });

  test("ListSetView.toJson", () {
    final ListSetView<int> view = ListSetView({3, 1, 2});
    final Object json = view.toJson((e) => e);
    expect(json, isA<List>());
    expect(json, [3, 1, 2]);
    expect(view.toJson((e) => "v$e"), ["v3", "v1", "v2"]);
    expect(ListSetView<int>({}).toJson((e) => e), []);

    // Round-trip.
    expect(ListSetView<int>.fromJson(view.toJson((e) => e), (e) => e as int), [3, 1, 2]);
  });

  test("ListSetView.followedBy", () {
    final ListSetView<int> view = ListSetView({1, 2, 3});
    expect(view.followedBy([4, 5]), [1, 2, 3, 4, 5]);
    // Doesn't remove duplicates (it's an Iterable, not a set).
    expect(view.followedBy([3, 1]), [1, 2, 3, 3, 1]);
    expect(view.followedBy([]), [1, 2, 3]);
    expect(ListSetView<int>({}).followedBy([1]), [1]);
    expect(ListSetView<int>({}).followedBy([]), isEmpty);

    // Is lazy, and reflects changes to the viewed set.
    final Set<int> set = {1};
    final Iterable<int> followed = ListSetView(set).followedBy([9]);
    set.add(2);
    expect(followed, [1, 2, 9]);
  });

  test("ListSetView.contains", () {
    final ListSetView<int?> view = ListSetView({1, null});
    expect(view.contains(1), isTrue);
    expect(view.contains(null), isTrue);
    expect(view.contains(2), isFalse);
    expect(ListSetView<int>({}).contains(1), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ListSet.unsafeView | Returns the same instance if already a ListSet", () {
    final ListSet<int> listSet = ListSet.of([1, 2]);
    expect(identical(ListSet.unsafeView(listSet), listSet), isTrue);

    final ListSetView<int> view = ListSetView({1, 2});
    expect(identical(ListSet.unsafeView(view), view), isTrue);
  });

  test("ListSet.unsafeView | Creates a ListSetView for a regular set, without copying it", () {
    final Set<int> set = {1, 2};
    final ListSet<int> view = ListSet.unsafeView(set);
    expect(view, isA<ListSetView<int>>());
    expect(view, [1, 2]);
    set.add(3);
    expect(view, [1, 2, 3]);
    expect(view.length, 3);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("ListSet.followedBy", () {
    final ListSet<int> listSet = ListSet.of([2, 1]);
    expect(listSet.followedBy([3, 2]), [2, 1, 3, 2]);
    expect(listSet.followedBy([]), [2, 1]);
    expect(ListSet<int>.empty().followedBy([1]), [1]);
  });

  test("ListSet.any / every", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3]);
    expect(listSet.any((e) => e == 2), isTrue);
    expect(listSet.any((e) => e > 3), isFalse);
    expect(listSet.every((e) => e > 0), isTrue);
    expect(listSet.every((e) => e > 1), isFalse);
    expect(ListSet<int>.empty().any((e) => true), isFalse);
    expect(ListSet<int>.empty().every((e) => false), isTrue);
  });

  test("ListSet.cast", () {
    final ListSet<int> listSet = ListSet.of([3, 1, 2], sort: true);
    final ListSet<num> casted = listSet.cast<num>();
    expect(casted, isA<ListSet<num>>());
    expect(casted, [1, 2, 3]);
    expect(casted.contains(2), isTrue);
    expect(casted[0], 1);

    final ListSet<Object> listSetObj = ListSet.of(<Object>[1, "a"]);
    final ListSet<int> castedWrong = listSetObj.cast<int>();
    expect(castedWrong[0], 1);
    expect(() => castedWrong[1], throwsA(isA<TypeError>()));
  });

  test("ListSet.expand", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3]);
    expect(listSet.expand((e) => [e, e * 10]), [1, 10, 2, 20, 3, 30]);
    expect(listSet.expand((e) => <int>[]), isEmpty);
  });

  test("ListSet.first / last / single", () {
    final ListSet<int> listSet = ListSet.of([3, 1, 2]);
    expect(listSet.first, 3);
    expect(listSet.last, 2);
    expect(() => listSet.single, throwsStateError);

    expect(ListSet.of([7]).first, 7);
    expect(ListSet.of([7]).last, 7);
    expect(ListSet.of([7]).single, 7);

    expect(() => ListSet<int>.empty().first, throwsStateError);
    expect(() => ListSet<int>.empty().last, throwsStateError);
    expect(() => ListSet<int>.empty().single, throwsStateError);
  });

  test("ListSet.firstWhere / lastWhere / singleWhere", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4]);
    expect(listSet.firstWhere((e) => e.isEven), 2);
    expect(listSet.lastWhere((e) => e.isEven), 4);
    expect(listSet.singleWhere((e) => e == 3), 3);

    expect(listSet.firstWhere((e) => e > 10, orElse: () => -1), -1);
    expect(listSet.lastWhere((e) => e > 10, orElse: () => -2), -2);
    expect(listSet.singleWhere((e) => e > 10, orElse: () => -3), -3);

    expect(() => listSet.firstWhere((e) => e > 10), throwsStateError);
    expect(() => listSet.lastWhere((e) => e > 10), throwsStateError);
    expect(() => listSet.singleWhere((e) => e > 10), throwsStateError);
    expect(() => listSet.singleWhere((e) => e.isEven), throwsStateError);
  });

  test("ListSet.fold / reduce", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3]);
    expect(listSet.fold<int>(10, (sum, e) => sum + e), 16);
    expect(listSet.fold<String>("", (s, e) => "$s$e"), "123");
    expect(ListSet<int>.empty().fold<int>(10, (sum, e) => sum + e), 10);
    expect(listSet.reduce((a, b) => a * b), 6);
    expect(() => ListSet<int>.empty().reduce((a, b) => a + b), throwsStateError);
  });

  test("ListSet.forEach", () {
    final ListSet<int> listSet = ListSet.of([3, 1, 2, 3]);
    final List<int> result = [];
    listSet.forEach(result.add);
    expect(result, [3, 1, 2]);

    final List<int> empty = [];
    ListSet<int>.empty().forEach(empty.add);
    expect(empty, isEmpty);
  });

  test("ListSet.skip / skipWhile / take / takeWhile", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4, 1]);
    expect(listSet.skip(0), [1, 2, 3, 4]);
    expect(listSet.skip(2), [3, 4]);
    expect(listSet.skip(10), isEmpty);
    expect(listSet.skipWhile((e) => e < 3), [3, 4]);
    expect(listSet.skipWhile((e) => true), isEmpty);
    expect(listSet.take(0), isEmpty);
    expect(listSet.take(2), [1, 2]);
    expect(listSet.take(10), [1, 2, 3, 4]);
    expect(listSet.takeWhile((e) => e < 3), [1, 2]);
    expect(listSet.takeWhile((e) => false), isEmpty);
  });

  test("ListSet.where / whereType", () {
    final ListSet<int> listSet = ListSet.of([1, 2, 3, 4]);
    expect(listSet.where((e) => e.isOdd), [1, 3]);
    expect(listSet.where((e) => e > 10), isEmpty);

    final ListSet<Object?> mixed = ListSet.of(<Object?>[1, "a", null, 2.5, "b"]);
    expect(mixed.whereType<String>(), ["a", "b"]);
    expect(mixed.whereType<num>(), [1, 2.5]);
    // ignore: prefer_void_to_null
    expect(mixed.whereType<Null>(), [null]);
    expect(mixed.whereType<bool>(), isEmpty);
  });

  test("ListSet.map / join / toSet / lookup", () {
    final ListSet<int> listSet = ListSet.of([3, 1, 2]);
    expect(listSet.map((e) => e * 2), [6, 2, 4]);
    expect(listSet.join(), "312");
    expect(listSet.join(", "), "3, 1, 2");
    expect(ListSet<int>.empty().join(","), "");

    final Set<int> set = listSet.toSet();
    expect(set, {1, 2, 3});
    expect(set.toList(), [3, 1, 2]); // Keeps the order.
    set.add(4); // It's a new mutable set.
    expect(listSet.length, 3);

    expect(listSet.lookup(1), 1);
    expect(listSet.lookup(4), isNull);
  });

  test("ListSet.iterator | Gives a better error message before moveNext", () {
    final ListSet<int> listSet = ListSet.of([1, 2]);
    final Iterator<int> iterator = listSet.iterator;
    expect(() => iterator.current, throwsStateError);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 1);
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, 2);
    expect(iterator.moveNext(), isFalse);
    expect(() => iterator.current, throwsStateError);
  });

  test("ListSet.isEmpty / isNotEmpty", () {
    expect(ListSet<int>.empty().isEmpty, isTrue);
    expect(ListSet<int>.empty().isNotEmpty, isFalse);
    expect(ListSet.of([1]).isEmpty, isFalse);
    expect(ListSet.of([1]).isNotEmpty, isTrue);
    expect(ListSet.of(<int>[]).isEmpty, isTrue);
  });

  test("ListSet.contains / containsAll | With nulls", () {
    final ListSet<int?> listSet = ListSet.of([1, null]);
    expect(listSet.contains(null), isTrue);
    expect(listSet.contains(2), isFalse);
    expect(listSet.containsAll([1, null]), isTrue);
    expect(listSet.containsAll([1, 2]), isFalse);
    expect(listSet.containsAll(<int?>[]), isTrue);
  });

  test("ListSet.of | Sort with a compare function", () {
    final ListSet<String> listSet =
        ListSet.of(["bb", "a", "ccc", "a"], sort: true, compare: (a, b) => b.compareTo(a));
    expect(listSet, ["ccc", "bb", "a"]);
  });
}
