// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("ordering", () {
    //
    // 1) Regular usage
    var set = ListSetView({1, 10, 50, -2, 8, 20});
    expect(set, [1, 10, 50, -2, 8, 20]);
    expect(set.length, 6);

    // 2) Edge cases
    set = ListSetView({});
    expect(set, []);
    expect(set.length, 0);

    set = ListSetView({2, 1, 3});
    expect(set, [2, 1, 3]);
    expect(set.length, 3);

    set = ListSetView({2, 1, 3});
    expect(set, [2, 1, 3]);
    expect(set.length, 3);
  });

  test("add", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).add(100), throwsUnsupportedError);
  });

  test("addAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).addAll([100, 1000]), throwsUnsupportedError);
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).addAll({100, 1000}), throwsUnsupportedError);
  });

  test("any", () {
    final ListSet<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.any((int v) => v == 4), isTrue);
    expect(listSetView.any((int v) => v == 100), isFalse);
  });

  test("containsAll", () {
    final ListSetView<int> listSetView = ListSetView({4, 2, 3, 1});
    expect(listSetView.containsAll([2, 2, 3]), isTrue);
    expect(listSetView.containsAll({1, 2, 3, 4}), isTrue);
    expect(listSetView.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(listSetView.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final ListSetView<int> listSet = ListSetView({4, 2, 3, 1});
    expect(listSet.difference({1, 2, 5}), {3, 4});
    expect(listSet.difference({1, 2, 3, 4}), <int>{});
  });

  test("elementAt", () {
    final ListSetView<int> listSet = ListSetView({4, 2, 3, 1});
    expect(listSet.elementAt(0), 4);
    expect(listSet.elementAt(1), 2);
    expect(listSet.elementAt(2), 3);
    expect(listSet.elementAt(3), 1);
  });

  test("every", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3});
    expect(listSetView.every((int v) => v > 0), isTrue);
    expect(listSetView.every((int v) => v < 0), isFalse);
    expect(listSetView.every((int v) => v != 4), isTrue);
  });

  test("expand", () {
    final ListSetView<int> iset = ListSetView({1, 2, 3, 4, 5, 6});
    expect(
        iset.expand((int v) => {v, v}),
        // ignore: equal_elements_in_set
        {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6});
    expect(iset.expand((int v) => <int>{}), <int>{});
  });

  test("cast", () {
    expect(ListSetView({1, 10, 50, -2, 8, 20}).cast<num>(), {1, 10, 50, -2, 8, 20});
  });

  test("clear", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).clear(), throwsUnsupportedError);
  });

  test("remove", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).remove(10), throwsUnsupportedError);
  });

  test("removeAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAll({10}), throwsUnsupportedError);
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAll([10]), throwsUnsupportedError);
  });

  test("removeWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeWhere((int value) => value == 10),
        throwsUnsupportedError);
  });

  test("retainAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).retainAll([10, 50]), throwsUnsupportedError);
  });

  test("retainWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).retainWhere((int value) => value == 10),
        throwsUnsupportedError);
  });

  test("single", () {
    // 1) Regular usage
    expect(ListSetView({10}).single, 10);

    // 2) Exception when more than 1 item
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(() => listSetView.single, throwsStateError);
  });

  test("singleWhere", () {
    // 1) Regular usage
    ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});

    expect(listSetView.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(listSetView.singleWhere((int v) => v == 50, orElse: () => 100), 100);

    // 2) Exception
    listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(() => listSetView.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("skip", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.skip(1), {2, 3, 4, 5, 6});
    expect(listSetView.skip(3), {4, 5, 6});
    expect(listSetView.skip(5), {6});
    expect(listSetView.skip(10), <int>{});
  });

  test("skipWhile", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.skipWhile((int v) => v < 3), {3, 4, 5, 6});
    expect(listSetView.skipWhile((int v) => v < 5), {5, 6});
    expect(listSetView.skipWhile((int v) => v < 6), {6});
    expect(listSetView.skipWhile((int v) => v < 100), <int>{});
  });

  test("take", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.take(0), <int>{});
    expect(listSetView.take(1), {1});
    expect(listSetView.take(3), {1, 2, 3});
    expect(listSetView.take(5), {1, 2, 3, 4, 5});
    expect(listSetView.take(10), {1, 2, 3, 4, 5, 6});
  });

  test("toList", () {
    final ListSetView<int> listSetView = ListSetView({1, 10, 11, 4, 5, 6});
    expect(listSetView.toList()..add(7), [1, 10, 11, 4, 5, 6, 7]);
    expect(listSetView, [1, 10, 11, 4, 5, 6]);
  });

  test("toSet", () {
    final ListSetView<int> listSetView = ListSetView({1, 10, 11, 4, 5, 6});
    expect(listSetView.toSet()..add(7), [1, 10, 11, 4, 5, 6, 7]);
    expect(listSetView, [1, 10, 11, 4, 5, 6]);
  });

  test("takeWhile", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.takeWhile((int v) => v < 3), {1, 2});
    expect(listSetView.takeWhile((int v) => v < 5), {1, 2, 3, 4});
    expect(listSetView.takeWhile((int v) => v < 6), {1, 2, 3, 4, 5});
    expect(listSetView.takeWhile((int v) => v < 100), {1, 2, 3, 4, 5, 6});
  });

  test("union", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4});
    expect(listSetView.union({1}), {1, 2, 3, 4});
    expect(listSetView.union({1, 2, 5}), {1, 2, 3, 4, 5});
  });

  test("where", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.where((int v) => v < 0), <int>{});
    expect(listSetView.where((int v) => v < 3), {1, 2});
    expect(listSetView.where((int v) => v < 5), {1, 2, 3, 4});
    expect(listSetView.where((int v) => v < 100), {1, 2, 3, 4, 5, 6});
  });

  test("whereType", () {
    expect((ListSetView(<num>{1, 2, 1.5}).whereType<double>()), {1.5});
  });

  test("+", () {
    // 1) Simple example
    expect(ListSetView({1, 2, 3}) + [1, 2, 4], {1, 2, 3, 4});

    // 2) Regular Usage
    expect(ListSetView(<int>{}) + [1, 2], {1, 2});
    expect(ListSetView(<int?>{null}) + [1, 2], {null, 1, 2});
    expect(ListSetView(<int>{1}) + [2, 3], {1, 2, 3});
    expect(ListSetView(<int?>{null, 1, 3}) + [10, 11], {null, 1, 3, 10, 11});
    expect(ListSetView({1, 2, 3, 4}) + [5, 6], {1, 2, 3, 4, 5, 6});

    // 3) Adding nulls
    expect(ListSetView(<int?>{null}) + [null], {null});
    expect(ListSetView(<int?>{null, 1, 3}) + [null], {null, 1, 3});

    // 4) Adding null and an item
    expect(ListSetView(<int?>{null}) + [null, 1], {null, 1});
    expect(ListSetView(<int?>{null, 1, 3}) + [null, 1], {null, 1, 3});
  });

  test("[]", () {
    final ListSetView<String> listSetView = ListSetView({"a", "b", "c"});
    expect(listSetView[0], "a");
    expect(listSetView[1], "b");
    expect(listSetView[2], "c");
    expect(() => listSetView[3], throwsA(isA<RangeError>()));
    expect(() => listSetView[100], throwsA(isA<RangeError>()));
    expect(() => listSetView[-1], throwsA(isA<RangeError>()));
    expect(() => listSetView[-100], throwsA(isA<RangeError>()));
  });

  test("[]=", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
    // TODO: This is not yet supported, but will be in the future.
    //    view[1] = 100;
    //    expect(view[1], 100);
    expect(() => view[1] = 100, throwsUnsupportedError);
  });

  test("asMap", () {
    expect(ListSetView({"hel", "lo", "there"}).asMap(), isA<Map<int, String>>());
    expect(ListSetView({"hel", "lo", "there"}).asMap(), {0: "hel", 1: "lo", 2: "there"});
  });

  test("getRange", () {
    final ListSetView<String> colors = ListSetView({"red", "green", "blue", "orange", "pink"});
    final Iterable<String> range = colors.getRange(1, 4);
    expect(range, ["green", "blue", "orange"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"]);
  });

  test("retainWhere", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).fillRange(1, 3, 100), throwsUnsupportedError);
  });

  test("first setter", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    //    view.first = 100;
    //    expect(view.first, 100);
    expect(() => view.first = 100, throwsUnsupportedError);
  });

  test("firstWhere", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 10, 6});
    expect(listSetView.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(listSetView.firstWhere((int v) => v > 4, orElse: () => 100), 10);
    expect(listSetView.firstWhere((int v) => v > 100, orElse: () => 100), 100);
  });

  test("lastWhere", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(listSetView.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(listSetView.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(listSetView.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(listSetView.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(listSetView.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("fold", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("forEach", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    int result = 100;
    listSetView.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("intersection", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4});
    expect(listSetView.intersection({1, 2, 5}), {1, 2});
    expect(listSetView.intersection({10, 20, 50}), <int>{});
  });

  test("isEmpty | isNotEmpty", () {
    expect(ListSetView({}).isEmpty, isTrue);
    expect(ListSetView<String>({}).isEmpty, isTrue);
    expect(ListSetView({1}).isEmpty, isFalse);
    expect(ListSetView({1, 2, 3}).isEmpty, isFalse);
    expect(<int>{}.lock.isEmpty, isTrue);

    expect(ListSetView({}).isNotEmpty, isFalse);
    expect(ListSetView<String>({}).isNotEmpty, isFalse);
    expect(ListSetView({1, 2, 3}).isNotEmpty, isTrue);
    expect(<int>{}.lock.isNotEmpty, isFalse);
  });

  test("join", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.join(","), "1,2,3,4,5,6");
    expect(<int>{}.lock.join(","), "");
  });

  test("lookup", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4});
    expect(listSetView.lookup(1), 1);
    expect(listSetView.lookup(10), isNull);
  });

  test("map", () {
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect({1, 2, 3}.lock.map((int v) => v + 1), {2, 3, 4});
    expect(listSetView.map((int v) => v + 1), {2, 3, 4, 5, 6, 7});
  });

  test("reduce", () {
    // 1) Regular usage
    final ListSetView<int> listSetView = ListSetView({1, 2, 3, 4, 5, 6});
    expect(listSetView.reduce((int p, int e) => p * (1 + e)), 2520);
    expect({5}.lock.reduce((int p, int e) => p * (1 + e)), 5);

    // 2) Exception
    expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  test("first, last", () {
    final ListSetView<int> view = ListSetView({10, 1, 50, -2, 8, 20});

    expect(view.first, 10);
    expect(view.last, 20);
  });

  test("first setter", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    //    view.first = 100;
    //    expect(view.first, 100);
    expect(() => view.last = 100, throwsUnsupportedError);
  });

  test("indexOf", () {
    var listSetView = ListSetView({"do", "re", "mi"});

    // 1) Regular usage
    expect(listSetView.indexOf("re"), 1);
    expect(listSetView.indexOf("re", 2), -1);
    expect(listSetView.indexOf("fa"), -1);

    // 2) Argument error
    expect(listSetView.indexOf("re", -1), 1);
    expect(listSetView.indexOf("re", 4), -1);
  });

  test("indexWhere", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    // expect(view.indexWhere((int value) => value == 10), 1);
    expect(() => view.indexWhere((int value) => value == 10), throwsUnsupportedError);
  });

  test("insert", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).insert(1, 100), throwsUnsupportedError);
  });

  test("insertAll", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).insertAll(1, [100, 1000]),
        throwsUnsupportedError);
  });

  test("last", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    //    view.last = 100;
    //    expect(view.last, 100);
    expect(() => view.last = 100, throwsUnsupportedError);
  });

  test("lastIndexOf", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    //    expect(view.lastIndexOf(-2), 3);
    expect(() => view.lastIndexOf(-2), throwsUnsupportedError);
  });

  test("lastIndexWhere", () {
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});

    // TODO: This is not yet supported, but will be in the future.
    //    expect(view.lastIndexWhere((int value) => value == -2), 3);
    expect(() => view.lastIndexWhere((int value) => value == -2), throwsUnsupportedError);
  });

  test("length setter", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).length = 10, throwsUnsupportedError);
  });

  test("removeAt", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeAt(1), throwsUnsupportedError);
  });

  test("removeLast", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeLast(), throwsUnsupportedError);
  });

  test("removeRange", () {
    expect(() => ListSetView({1, 10, 50, -2, 8, 20}).removeRange(1, 3), throwsUnsupportedError);
  });

  test("replaceRange", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.replaceRange(1, 3, [100, 1000]);
//    expect(view, [1, 100, 1000, -2, 8, 20]);
    expect(() => view.replaceRange(1, 3, [100, 1000]), throwsUnsupportedError);
  });

  test("reversed", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.reversed, allOf(isA<Iterable<int>>(), [20, 8, -2, 50, 10, 1]));
    expect(() => view.reversed, throwsUnsupportedError);
  });

  test("reversedView", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.reversedView, allOf(isA<ListSetView<int>>(), [20, 8, -2, 50, 10, 1]));
    expect(() => view.reversedView, throwsUnsupportedError);
  });

  test("setAll", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.setAll(1, [100, 1000]);
//    expect(view, [1, 100, 1000, 10, 50, -2, 8, 20]);
    expect(() => view.setAll(1, [100, 1000]), throwsUnsupportedError);
  });

  test("setRange", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.setRange(1, 5, [100, 1000]);
//    expect(view, [1, 100, 1000, -2, 8, 20]);
    expect(() => view.setRange(1, 5, [100, 1000]), throwsUnsupportedError);
  });

  test("shuffle", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.shuffle(Random(0));
//    expect(view, [1, 10, 50, -2, 8, 20]);
    expect(() => view.shuffle(Random(0)), throwsUnsupportedError);
  });

  test("sort", () {
    // TODO: Complete specification
    ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.sort();
//    expect(view, [-2, 1, 8, 10, 20, 50]);
    expect(() => view.sort(), throwsUnsupportedError);

    view = ListSetView({1, 10, 50, -2, 8, 20});
//    view.sort((int a, int b) => -a.compareTo(b));
//    expect(view, [50, 20, 10, 8, 1, -2]);
    expect(() => view.sort(), throwsUnsupportedError);
  });

  test("sublist", () {
    // TODO: Complete specification
    final ListSetView<int> view = ListSetView({1, 10, 50, -2, 8, 20});
//    expect(view.sublist(1, 3), allOf(isA<List<int>>(), [10, 50]));
    expect(() => view.sublist(1, 3), throwsUnsupportedError);
  });
}
