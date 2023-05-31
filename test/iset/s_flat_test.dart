// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("getFlushed", () {
    expect(SFlat({1, 2, 3}).getFlushed(ISet.defaultConfig), allOf(isA<Set<int>>(), {1, 2, 3}));
  });

  test("Runtime Type", () {
    expect(SFlat([1, 2, 3, 3]), isA<SFlat<int>>());
  });

  test("unlock", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.unlock, isA<Set<int>>());
    expect(sFlat.unlock, <int>{1, 2, 3});
  });

  test("isEmpty | isNotEmpty", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.isEmpty, isFalse);
    expect(sFlat.isNotEmpty, isTrue);
  });

  test("length", () {
    expect(SFlat([1, 2, 3, 3]).length, 3);
  });

  test("cast", () {
    final sFlatAsNum = SFlat([1, 2, 3, 3]).cast<num>();
    expect(sFlatAsNum, isA<Iterable<num>>());
  });

  test("iterator", () {
    final Iterator<int?> iter = SFlat([1, 2, 3, 3]).iterator;

    // Throws StateError before first moveNext().
    expect(() => iter.current, throwsStateError);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, 1);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 2);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 3);
    expect(iter.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter.current, throwsStateError);
  });

  test("empty", () {
    final S<int?> empty = SFlat.empty();

    expect(empty.unlock, <int>{});
    expect(empty.isEmpty, isTrue);
    expect(empty.isNotEmpty, isFalse);
  });

  test("deepSetHashCode", () {
    expect(SFlat([1, 2, 3, 3]).deepSetHashcode(), SetEquality().hash({1, 2, 3}));
  });

  test("deepSetEquals", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    expect(sFlat.deepSetEquals(null), isFalse);
    expect(sFlat.deepSetEquals(SFlat<int>({})), isFalse);
    expect(sFlat.deepSetEquals(SFlat<int>({1, 2, 3})), isTrue);
    expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 3])), isTrue);
    expect(sFlat.deepSetEquals(SFlat<int>([1, 2, 3, 4])), isFalse);
  });

  test("deepSetEqualsToIterable", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 3]);
    final Iterable<int> iterable1 = [3, 2, 1];
    final Iterable<int> iterable2 = [1, 2];

    expect(sFlat.deepSetEqualsToIterable(null), isFalse);
    expect(sFlat.deepSetEqualsToIterable(iterable1), isTrue);
    expect(sFlat.deepSetEqualsToIterable(iterable2), isFalse);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable set doesn't change the SFlat
    Set<int> original = {1, 2, 3};
    SFlat<int> sFlat = SFlat<int>(original);

    expect(sFlat, original);

    original.add(3);
    original.add(4);

    expect(original, <int>{1, 2, 3, 4});
    expect(sFlat, <int>{1, 2, 3});

    // 1.2) Adding to the original SFlat doesn't change it
    original = {1, 2, 3};
    sFlat = SFlat<int>(original);

    expect(sFlat, <int>{1, 2, 3});

    final S<int?> s1 = sFlat.add(4);
    final S<int?> s2 = sFlat.add(3);

    expect(original, <int>{1, 2, 3});
    expect(sFlat, <int>{1, 2, 3});
    expect(s1, <int>{1, 2, 3, 4});
    expect(s2, <int>{1, 2, 3});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside SFlat
    original = {1, 2, 3};
    sFlat = SFlat(original);

    expect(sFlat, original);

    int willChange = 4;
    S<int?> s = sFlat.add(willChange);

    willChange = 5;

    expect(original, <int>{1, 2, 3});
    expect(sFlat, <int>{1, 2, 3});
    expect(willChange, 5);
    expect(s, <int>{1, 2, 3, 4});

    // 2) addAll

    // 2.1) Changing the passed mutable set doesn't change the SFlat
    original = {1, 2, 3};
    sFlat = SFlat(original);

    expect(sFlat, original);

    original.addAll([3, 4, 5]);

    expect(original, <int>{1, 2, 3, 4, 5});
    expect(sFlat, <int>{1, 2, 3});

    // 2.2) Changing the immutable set doesn't change the SFlat
    original = {1, 2, 3};
    sFlat = SFlat(original);

    expect(sFlat, <int>{1, 2, 3});

    s = sFlat.addAll([3, 4, 5]);

    expect(original, <int>{1, 2, 3});
    expect(sFlat, <int>{1, 2, 3});
    expect(s, <int>{1, 2, 3, 4, 5});

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {1, 2};
    final SFlat<int> sFlat1 = SFlat(original), sFlat2 = SFlat(original);

    expect(sFlat1, <int>{1, 2});
    expect(sFlat2, <int>{1, 2});

    s = sFlat1.addAll(sFlat2);
    original.add(5);

    expect(original, <int>{1, 2, 5});
    expect(sFlat1, <int>{1, 2});
    expect(sFlat2, <int>{1, 2});
    expect(s, <int>{1, 2});

    // 3) remove

    // 3.1) Changing the passed mutable set doesn't change the SFlat
    original = {1, 2, 3};
    sFlat = SFlat(original);

    expect(sFlat, original);

    original.remove(3);

    expect(original, <int>{1, 2});
    expect(sFlat, <int>{1, 2, 3});

    // 3.2) Removing from the original SFlat doesn't change it
    original = {1, 2};
    sFlat = SFlat(original);

    expect(sFlat, <int>{1, 2});

    s = sFlat.remove(1);

    expect(original, <int>{1, 2});
    expect(sFlat, <int>{1, 2});
    expect(s, <int>{2});

    // 4) Other stuff

    // 4.1) Initialization through the unsafe constructor
    original = {1, 2, 3};
    sFlat = SFlat.unsafe(original);

    expect(sFlat, original);

    original.add(4);

    expect(original, {1, 2, 3, 4});
    expect(sFlat, {1, 2, 3, 4});
  });

  test("any", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.any((int? v) => v == 4), isTrue);
    expect(sFlat.any((int? v) => v == 100), isFalse);
  });

  test("contains", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.contains(2), isTrue);
    expect(sFlat.contains(4), isTrue);
    expect(sFlat.contains(5), isTrue);
    expect(sFlat.contains(100), isFalse);
    expect(sFlat.contains(null), isFalse);
  });

  test("containsAll", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.containsAll([2, 2, 3]), isTrue);
    expect(sFlat.containsAll({1, 2, 3, 4}), isTrue);
    expect(sFlat.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(sFlat.containsAll({1, 2, 3, 4, 10}.lock), isFalse);
    expect(sFlat.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.difference({1, 2, 5}), {3, 4, 6});
    expect(sFlat.difference({1, 2, 3, 4, 5, 6}), <int>{});
  });

  test("intersection", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.intersection({1, 2, 5}), {1, 2, 5});
    expect(sFlat.intersection({10, 20, 50}), <int>{});
  });

  test("union", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.union({1}), {1, 2, 3, 4, 5, 6});
    expect(sFlat.union({1, 2, 10}), {1, 2, 3, 4, 5, 6, 10});
  });

  test("every", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.every((int? v) => v! > 0), isTrue);
    expect(sFlat.every((int? v) => v! < 0), isFalse);
    expect(sFlat.every((int? v) => v != 4), isFalse);
  });

  test("expand", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.expand((int? v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect(sFlat.expand((int? v) => []), []);
  });

  test("first", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.first, 1);
  });

  test("last", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.last, 6);
  });

  test("single method", () {
    // 1) State exception
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.single, throwsStateError);

    // 2) Access
    expect([10].lock.single, 10);
  });

  test("firstWhere", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.firstWhere((int? v) => v! > 1, orElse: () => 100), 2);
    expect(sFlat.firstWhere((int? v) => v! > 4, orElse: () => 100), 5);
    expect(sFlat.firstWhere((int? v) => v! > 5, orElse: () => 100), 6);
    expect(sFlat.firstWhere((int? v) => v! > 6, orElse: () => 100), 100);
  });

  test("fold", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.fold(100, (int p, int? e) => p * (1 + e!)), 504000);
  });

  test("followedBy", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("followedBy", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(sFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("forEach", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    int result = 100;
    sFlat.forEach((int? v) => result *= 1 + v!);
    expect(result, 504000);
  });

  test("join", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.join(","), "1,2,3,4,5,6");
    expect(SFlat(<int>[]).join(","), "");
    expect(SFlat.empty().join(","), "");
  });

  test("lastWhere", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.lastWhere((int? v) => v! < 2, orElse: () => 100), 1);
    expect(sFlat.lastWhere((int? v) => v! < 5, orElse: () => 100), 4);
    expect(sFlat.lastWhere((int? v) => v! < 6, orElse: () => 100), 5);
    expect(sFlat.lastWhere((int? v) => v! < 7, orElse: () => 100), 6);
    expect(sFlat.lastWhere((int? v) => v! < 50, orElse: () => 100), 6);
    expect(sFlat.lastWhere((int? v) => v! < 1, orElse: () => 100), 100);
  });

  test("map", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(SFlat([1, 2, 3]).map((int? v) => v! + 1), [2, 3, 4]);
    expect(sFlat.map((int? v) => v! + 1), [2, 3, 4, 5, 6, 7]);
  });

  test("reduce", () {
    // 1) Regular usage
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.reduce((int? p, int? e) => p! * (1 + e!)), 2520);
    expect(SFlat([5]).reduce((int? p, int? e) => p! * (1 + e!)), 5);

    // 2) State exception
    expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  test("singleWhere", () {
    // 1) Regular usage
    SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.singleWhere((int? v) => v == 4, orElse: () => 100), 4);
    expect(sFlat.singleWhere((int? v) => v == 50, orElse: () => 100), 100);

    // 2) State exception
    sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.singleWhere((int? v) => v! < 4, orElse: () => 100), throwsStateError);
  });

  test("skip", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.skip(1), [2, 3, 4, 5, 6]);
    expect(sFlat.skip(3), [4, 5, 6]);
    expect(sFlat.skip(5), [6]);
    expect(sFlat.skip(10), []);
  });

  test("skipWhile", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.skipWhile((int? v) => v! < 3), [3, 4, 5, 6]);
    expect(sFlat.skipWhile((int? v) => v! < 5), [5, 6]);
    expect(sFlat.skipWhile((int? v) => v! < 6), [6]);
    expect(sFlat.skipWhile((int? v) => v! < 100), []);
  });

  test("take", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.take(0), []);
    expect(sFlat.take(1), [1]);
    expect(sFlat.take(3), [1, 2, 3]);
    expect(sFlat.take(5), [1, 2, 3, 4, 5]);
    expect(sFlat.take(10), [1, 2, 3, 4, 5, 6]);
  });

  test("takeWhile", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.takeWhile((int? v) => v! < 3), [1, 2]);
    expect(sFlat.takeWhile((int? v) => v! < 5), [1, 2, 3, 4]);
    expect(sFlat.takeWhile((int? v) => v! < 6), [1, 2, 3, 4, 5]);
    expect(sFlat.takeWhile((int? v) => v! < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("toList", () {
    // 1) Regular usage
    SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);

    // 2) Unsupported exception
    sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(() => sFlat.toList(growable: false)..add(7), throwsUnsupportedError);
  });

  test("toSet", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        sFlat
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect(sFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("where", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.where((int? v) => v! < 0), []);
    expect(sFlat.where((int? v) => v! < 3), [1, 2]);
    expect(sFlat.where((int? v) => v! < 5), [1, 2, 3, 4]);
    expect(sFlat.where((int? v) => v! < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("whereType", () {
    expect((SFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]);
  });

  test("anyItem", () {
    final SFlat<int> sFlat = SFlat([1, 2, 3, 4, 5, 6, 5, 6]);
    expect(sFlat.anyItem, isA<int>());
  });
}
