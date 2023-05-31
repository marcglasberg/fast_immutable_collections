// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
// ignore_for_file: unnecessary_type_check
import "dart:math";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

void main() {
  //
  test("Some NNBD strangeness", () {
    var a = [1, 2];
    List<int?> b = a;
    var c = [null, 3];

    // type 'List<int?>' is not a subtype of type 'Iterable<int>' of 'iterable'
    expect(() => b.addAll(c), throwsA(anything));
  });

  test("reversedView runtime type", () {
    expect([].reversed is Iterable, isTrue);
    expect([].reversed is List, isFalse);
    expect([].reversedView is List, isTrue);
    expect([1].reversedView is List<int>, isTrue);
  });

  test("reversedView | single, first, last, length", () {
    // 1) single

    expect(() => [].reversedView.single, throwsStateError);
    expect(() => [1, 2].reversedView.single, throwsStateError);
    expect([1].reversedView.single, 1);

    // 2) first | last

    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.first, 4);

    expect(reversed.last, 0);

    expect(() => [].reversedView.first, throwsStateError);
    expect(() => [].reversedView.last, throwsStateError);

    // 3) length

    expect(reversed.length, 6);

    // 4) length, first and  last setters

    reversed.first = 100;
    expect(reversed.first, 100);

    reversed.last = 500;
    expect(reversed.last, 500);
  });

  test("reversedView | set length", () {
    var list = [0, 1, 2, 3, 4, 5, 6];
    var reversed = list.reversedView;

    reversed.length = 4;
    expect(reversed, [6, 5, 4, 3]);
    expect(list, [3, 4, 5, 6]);
  });

  test("reversedView.indexWhere", () {
    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.indexWhere((i) => i == 0), 5);
    expect(reversed.indexWhere((i) => i == 1), 4);
    expect(reversed.indexWhere((i) => i == 2), 3);
    expect(reversed.indexWhere((i) => i == 3), 1);
    expect(reversed.indexWhere((i) => i == 4), 0);
    expect(reversed.indexWhere((i) => i == 5), -1);
    expect(reversed.indexWhere((i) => i == 4, 1), -1);
  });

  test("reversedView.lastIndexWhere", () {
    var list = [0, 1, 2, 3, 3, 4];
    var reversed = list.reversedView;

    expect(reversed.lastIndexWhere((i) => i == 0), 5);
    expect(reversed.lastIndexWhere((i) => i == 1), 4);
    expect(reversed.lastIndexWhere((i) => i == 2), 3);
    expect(reversed.lastIndexWhere((i) => i == 3), 2);
    expect(reversed.lastIndexWhere((i) => i == 4), 0);
    expect(reversed.lastIndexWhere((i) => i == 5), -1);

    expect(reversed.lastIndexWhere((i) => i == 0, 1), -1);
  });

  test("Some NNBD strangeness", () {
    var a = [1, 2];
    List<int?> b = a;
    var c = [null, 3];

    // type 'List<int?>' is not a subtype of type 'Iterable<int>' of 'iterable'
    expect(() => b.addAll(c), throwsA(anything));
  });

  test("reversedView.+", () {
    List<int> list1 = [1, 2, 3].reversedView;
    expect(list1 + [4, 5, 6], [3, 2, 1, 4, 5, 6]);
    expect(list1 + [4], [3, 2, 1, 4]);

    List<int?> list2 = <int?>[1, 2, 3].reversedView;
    expect(list2 + [4, 5, 6], [3, 2, 1, 4, 5, 6]);
    expect(list2 + [4], [3, 2, 1, 4]);
    expect(list2 + [null], [3, 2, 1, null]);
  });

  test("reversedView.[]", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;

    expect(reversed[0], 4);
    expect(reversed[1], 3);
    expect(reversed[2], 2);
    expect(reversed[3], 1);
    expect(reversed[4], 0);
    expect(() => reversed[5], throwsRangeError);
  });

  test("reversedView.[]=", () {
    List<int> list = [1, 2, 3].reversedView;

    expect(() => list[-100] = 10, throwsRangeError);
    expect(() => list[-1] = 10, throwsRangeError);
    expect(() => list[100] = 10, throwsRangeError);
    expect(() => list[3] = 10, throwsRangeError);

    list[0] = 10;
    expect(list, [10, 2, 1]);
    list[1] = 10;
    expect(list, [10, 10, 1]);
    list[2] = 10;
    expect(list, [10, 10, 10]);
  });

  test("reversedView.add", () {
    List<int?> reversed = <int?>[1, 2, 3].reversedView;

    reversed.add(1);
    expect(reversed, [3, 2, 1, 1]);

    reversed.add(null);
    expect(reversed, [3, 2, 1, 1, null]);

    reversed = <int?>[null].reversedView;
    reversed.add(1);
    expect(reversed, <int?>[null, 1]);

    reversed = [null, 1, null, 2].reversedView;
    reversed.add(10);
    expect(reversed, <int?>[2, null, 1, null, 10]);
  });

  test("reversedView.addAll", () {
    List<int?> reversed = <int?>[1, 2, 3].reversedView;

    reversed.addAll([1, 2]);
    expect(reversed, [3, 2, 1, 1, 2]);

    reversed.addAll([1, null]);
    expect(reversed, [3, 2, 1, 1, 2, 1, null]);

    reversed = <int?>[null].reversedView;
    reversed.addAll([1, 2]);
    expect(reversed, <int?>[null, 1, 2]);

    reversed = [null, 1, null, 2].reversedView;
    reversed.addAll([10, 11]);
    expect(reversed, <int?>[2, null, 1, null, 10, 11]);
  });

  test("reversedView.elementAt", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;

    expect(reversed.elementAt(0), 4);
    expect(reversed.elementAt(1), 3);
    expect(reversed.elementAt(2), 2);
    expect(reversed.elementAt(3), 1);
    expect(reversed.elementAt(4), 0);
    expect(() => reversed.elementAt(5), throwsRangeError);
  });

  test("reversedView.any", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;

    expect(reversed.any((i) => i == 2), isTrue);
    expect(reversed.any((i) => i == 5), isFalse);
  });

  test("reversedView.asMap", () {
    expect([1, 2, 3].reversedView.asMap(), {0: 3, 1: 2, 2: 1});
  });

  test("reversedView.cast", () {
    const TypeMatcher<TypeError> isTypeError = TypeMatcher<TypeError>();
    final Matcher throwsTypeError = throwsA(isTypeError);

    final List<int> reversed = [1, 2, 3].reversedView;
    expect(reversed.cast<num>(), allOf(isA<List<num>>(), <num>[3, 2, 1]));
    expect(() => reversed.cast<String>(), throwsTypeError);
  });

  test("reversedView.clear", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;
    expect(reversed, [4, 3, 2, 1, 0]);
    expect(reversed.isEmpty, isFalse);
    reversed.clear();
    expect(reversed, []);
    expect(reversed.isEmpty, isTrue);
  });

  test("reversedView.contains", () {
    final List<int> reversed = [0, 1, 2, 3, 4].reversedView;

    expect(reversed.contains(0), isTrue);
    expect(reversed.contains(1), isTrue);
    expect(reversed.contains(2), isTrue);
    expect(reversed.contains(3), isTrue);
    expect(reversed.contains(4), isTrue);
    expect(reversed.contains(5), isFalse);
    expect(reversed.contains(null), isFalse);
  });

  test("reversedView.every", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.every((int v) => v > 0), isTrue);
    expect(reversed.every((int v) => v < 0), isFalse);
    expect(reversed.every((int v) => v != 4), isFalse);
  });

  test("reversedView.expand", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.expand((int v) => [v, v]),
        allOf(isA<Iterable<int>>(), [6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1]));
    expect(reversed.expand((int v) => <int>[]), allOf(isA<Iterable<int>>(), <int>[]));
  });

  test("reversedView.fillRange", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;
    reversed.fillRange(2, 5, -1);
    expect(reversed, [9, 8, -1, -1, -1, 4, 3, 2, 1]);
  });

  test("reversedView.firstWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.firstWhere((int v) => v <= 1, orElse: () => 100), 1);
    expect(reversed.firstWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(reversed.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(reversed.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("reversedView.fold", () {
    expect([1, 2, 3, 4, 5, 6].reversedView.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("reversedView.followedBy", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.followedBy([7, 8]), [6, 5, 4, 3, 2, 1, 7, 8]);
    expect(reversed.followedBy(<int>[].lock.add(7).addAll([8, 9])), [6, 5, 4, 3, 2, 1, 7, 8, 9]);
  });

  test("reversedView.forEach", () {
    int result = 100;
    [1, 2, 3, 4, 5, 6].reversedView.forEach(((int v) => result *= 1 + v));
    expect(result, 504000);
  });

  test("reversedView.getRange", () {
    final List<String> colors = ["red", "green", "blue", "orange", "pink"].reversedView;
    expect(colors, ["pink", "orange", "blue", "green", "red"]);
    expect(colors.getRange(1, 4), ["orange", "blue", "green"]);

    expect(() => colors.getRange(1, 400), throwsRangeError);
    expect(() => colors.getRange(4, 1), throwsRangeError);
  });

  test("reversedView.indexOf", () {
    //
    var list = ["do", "re", "mi", "re"];
    var reversed = list.reversedView;

    // 1) Regular usage
    expect(reversed.indexOf("fa"), -1);
    expect(reversed.indexOf("do"), 3);
    expect(reversed.indexOf("re"), 0);
    expect(reversed.indexOf("re", 1), 2);

    // 2) Wrong start
    expect(list.indexOf("do", -1), 0);
    expect(reversed.indexOf("re", -1), 0);
    expect(list.indexOf("do", -10), 0);
    expect(reversed.indexOf("re", -10), 0);
    expect(list.indexOf("do", 100), -1);
    expect(reversed.indexOf("re", 100), -1);
  });

  test("reversedView.lastIndexOf", () {
    var list = ["re", "mi", "re", "do"];
    var reversed = list.reversedView;

    // 1) Regular usage
    expect(reversed.lastIndexOf("fa"), -1);
    expect(reversed.lastIndexOf("do"), 0);
    expect(reversed.lastIndexOf("re"), 3);
    expect(reversed.lastIndexOf("re", 0), -1);
    expect(reversed.lastIndexOf("re", 1), 1);
    expect(reversed.lastIndexOf("re", 2), 1);
    expect(reversed.lastIndexOf("re", 3), 3);

    // 2) Wrong start
    expect(reversed.lastIndexOf("fa", 10), -1);
    expect(reversed.lastIndexOf("fa", -10), -1);
    expect(reversed.lastIndexOf("do", 10), 0);
    expect(reversed.lastIndexOf("do", -10), -1);
  });

  test("reversedView.insert", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insert(2, "fa");

    expect(reversed, ["re", "mi", "fa", "re", "do"]);
  });

  test("reversedView.insertAll", () {
    List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insertAll(2, ["fa"]);
    expect(reversed, ["re", "mi", "fa", "re", "do"]);

    reversed = ["do", "re", "mi", "re"].reversedView;
    reversed.insertAll(2, ["fa", "sol"]);
    expect(reversed, ["re", "mi", "fa", "sol", "re", "do"]);
  });

  test("reversedView || isEmpty | isNotEmpty", () {
    expect([].reversedView, isEmpty);
    expect([1].reversedView, isNotEmpty);
  });

  test("reversedView.iterator", () {
    const List<int> list = [0, 1, 2, 3, 4];
    final List<int> reversed = list.reversedView;
    var iter = reversed.iterator;

    // Throws before first moveNext().
    expect(() => iter.current, throwsA(anything));

    expect(iter.moveNext(), isTrue);
    expect(iter.current, reversed[0]);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, reversed[1]);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, reversed[2]);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, reversed[3]);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, reversed[4]);

    expect(iter.moveNext(), isFalse);

    // Throws after last moveNext().
    expect(() => iter.current, throwsA(anything));
  });

  test("reversedView.join", () {
    expect([1, 2, 3, 4, 5, 6].reversedView.join(","), "6,5,4,3,2,1");
    expect([].reversedView.join(","), "");
  });

  test("reversedView.lastWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v < 5, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(reversed.lastWhere((int v) => v >= 5, orElse: () => 100), 5);
    expect(reversed.lastWhere((int v) => v < 50, orElse: () => 100), 1);
    expect(reversed.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("reversedView.map", () {
    expect([1, 2, 3].reversedView.map((int v) => v + 1), [4, 3, 2]);
    expect([1, 2, 3, 4, 5, 6].reversedView.map((int v) => v + 1), [7, 6, 5, 4, 3, 2]);
  });

  test("reversedView.reduce", () {
    // 1) Regular usage
    expect([1, 2, 3, 4, 5, 6].reversedView.reduce((int p, int e) => p * (1 + e)), 4320);
    expect([5].reversedView.reduce((int p, int e) => p * (1 + e)), 5);

    // 2) State Exception
    expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  test("reversedView.remove", () {
    List<int> reversed = [1, 2, 3].reversedView;

    expect(reversed.remove(2), isTrue);
    expect(reversed, [3, 1]);

    expect(reversed.remove(3), isTrue);
    expect(reversed, [1]);

    expect(reversed.remove(10), isFalse);
    expect(reversed, [1]);

    expect(reversed.remove(1), isTrue);
    expect(reversed, []);

    expect(reversed.remove(10), isFalse);
    expect(reversed, []);
  });

  test("reversedView.removeAt", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    expect(reversed.removeAt(1), "mi");
    expect(reversed, ["re", "re", "do"]);
  });

  test("reversedView.removeLast", () {
    final List<String> reversed = ["do", "re", "mi", "re"].reversedView;
    expect(reversed.removeLast(), "do");
    expect(reversed, ["re", "mi", "re"]);
  });

  test("reversedView.removeRange", () {
    final List<String> reversed = ["do", "re", "mi", "fa", "sol", "la"].reversedView;
    reversed.removeRange(1, 3);
    expect(reversed, ["la", "mi", "re", "do"]);
  });

  test("reversedView.removeWhere", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    reversed.removeWhere((String item) => item.length == 3);
    expect(reversed, ["four", "three"]);
  });

  test("reversedView.replaceRange", () {
    final List<String> reversed = ["a", "b", "c", "d", "e", "f"].reversedView;
    reversed.replaceRange(1, 4, ["1", "2"]);
    expect(reversed, ["f", "1", "2", "b", "a"]);
  });

  test("reversedView.retainWhere", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    reversed.retainWhere((String item) => item.length == 3);
    expect(reversed, ["two", "one"]);
  });

  test("reversedView.reversed", () {
    final List<String> reversed = ["one", "two", "three", "four"].reversedView;
    expect(reversed.reversed, ["one", "two", "three", "four"]);
  });

  test("reversedView.setAll", () {
    List<int> reversed = [1, 2, 3, 4, 5].reversedView;
    reversed.setAll(0, [-10, -100]);
    expect(reversed, [-10, -100, 3, 2, 1]);

    reversed = [1, 2, 3, 4, 5].reversedView;
    reversed.setAll(1, [-10, -100]);
    expect(reversed, [5, -10, -100, 2, 1]);
  });

  test("reversedView.setRange", () {
    List<String> reversed = ["1", "2", "3", "4"].reversedView;
    reversed.setRange(1, 3, ["10", "11", "12"]);
    expect(reversed, ["4", "10", "11", "1"]);

    reversed = ["1", "2", "3", "4"].reversedView;
    reversed.setRange(1, 3, ["10", "11", "12"], 1);
    expect(reversed, ["4", "11", "12", "1"]);
  });

  test("reversedView.shuffle", () {
    List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    reversed.shuffle(Random(0));
    expect(reversed, [4, 2, 7, 8, 6, 9, 3, 5, 1]);

    reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    reversed.shuffle(Random(1));
    expect(reversed, [7, 4, 2, 8, 1, 9, 3, 6, 5]);
  });

  test("reversedView.singleWhere", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6, 7, 8, 9].reversedView;

    // 1) Regular usage
    expect(reversed.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(reversed.singleWhere((int v) => v == 50, orElse: () => 100), 100);

    // 2) State Exception
    expect(() => reversed.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("reversedView.skip", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;

    expect(reversed.skip(1), [5, 4, 3, 2, 1]);
    expect(reversed.skip(3), [3, 2, 1]);
    expect(reversed.skip(5), [1]);
    expect(reversed.skip(10), <int>[]);
    expect(() => reversed.skip(-1), throwsRangeError);
  });

  test("reversedView.skipWhile", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.skipWhile((int v) => v > 3), [3, 2, 1]);
    expect(reversed.skipWhile((int v) => v >= 5), [4, 3, 2, 1]);
    expect(reversed.skipWhile((int v) => v < 6), [6, 5, 4, 3, 2, 1]);
    expect(reversed.skipWhile((int v) => v < 100), []);
  });

  test("reversedView.sort", () {
    List<int> list = [1, 5, 3, 2, 4, 6];
    List<int> reversed = list.reversedView;

    reversed.sort();
    expect(list, [6, 5, 4, 3, 2, 1]);
    expect(reversed, [1, 2, 3, 4, 5, 6]);

    list.sort();
    expect(list, [1, 2, 3, 4, 5, 6]);
    expect(reversed, [6, 5, 4, 3, 2, 1]);

    // ---

    list = [1, 5, 3, 4, 6];
    reversed = list.reversedView;

    reversed.sort((int a, int b) => a.compareTo(b));
    expect(list, [6, 5, 4, 3, 1]);
    expect(reversed, [1, 3, 4, 5, 6]);

    list.sort((int a, int b) => a.compareTo(b));
    expect(list, [1, 3, 4, 5, 6]);
    expect(reversed, [6, 5, 4, 3, 1]);
  });

  test("reversedView.sublist", () {
    final List<String> colors = ["red", "green", "blue", "orange", "pink"].reversedView;
    expect(colors.sublist(1, 3), ["orange", "blue"]);
    expect(colors.sublist(1), ["orange", "blue", "green", "red"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"].reversed);
  });

  test("reversedView.take", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.take(0), []);
    expect(reversed.take(1), [6]);
    expect(reversed.take(3), [6, 5, 4]);
    expect(reversed.take(5), [6, 5, 4, 3, 2]);
    expect(reversed.take(10), [6, 5, 4, 3, 2, 1]);
    expect(() => reversed.take(-1), throwsRangeError);
    expect(() => reversed.take(-100), throwsRangeError);
  });

  test("reversedView.takeWhile", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.takeWhile((int v) => v < 3), []);
    expect(reversed.takeWhile((int v) => v >= 5), [6, 5]);
    expect(reversed.takeWhile((int v) => v > 1), [6, 5, 4, 3, 2]);
    expect(reversed.takeWhile((int v) => v < 100), [6, 5, 4, 3, 2, 1]);
  });

  test("reversedView.toList", () {
    List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.toList(), [6, 5, 4, 3, 2, 1]);

    reversed.add(7);
    expect(reversed.toList(), [6, 5, 4, 3, 2, 1, 7]);

    List<int> fixedList = reversed.toList(growable: false);
    expect(() => fixedList.add(8), throwsUnsupportedError);
    expect(fixedList.toList(), [6, 5, 4, 3, 2, 1, 7]);
  });

  test("reversedView.toSet", () {
    final List<int> reversed = [1, 2, 2, 3, 4, 4, 5, 6].reversedView;
    expect(reversed.toSet(), allOf(isA<Set<int>>(), {1, 2, 3, 4, 5, 6}));
  });

  test("reversedView.where", () {
    final List<int> reversed = [1, 2, 3, 4, 5, 6].reversedView;
    expect(reversed.where((int v) => v < 0), []);
    expect(reversed.where((int v) => v < 3), [2, 1]);
    expect(reversed.where((int v) => v < 5), [4, 3, 2, 1]);
    expect(reversed.where((int v) => v < 100), [6, 5, 4, 3, 2, 1]);
  });

  test("reversedView.whereType", () {
    expect(<num>[1, 2, 1.5].reversedView.whereType<double>(), [1.5]);
  });
}
