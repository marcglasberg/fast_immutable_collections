// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("getFlushed", () {
    const List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat(original);

    expect(lFlat.getFlushed, [1, 2, 3]);
    expect(identical(original, lFlat.getFlushed), isFalse);
  });

  test("Runtime Type", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat, isA<LFlat<int>>());
  });

  test("unlock", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.unlock, <int>[1, 2, 3]);
    expect(lFlat.unlock, isA<List<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.isEmpty, isFalse);
    expect(lFlat.isNotEmpty, isTrue);
  });

  test("length", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.length, 3);
  });

  test("[]", () {
    // 1) Regular usage
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat[0], 1);
    expect(lFlat[1], 2);
    expect(lFlat[2], 3);

    // 2) Range errors
    expect(() => lFlat[-1], throwsA(isA<RangeError>()));
    expect(() => lFlat[4], throwsA(isA<RangeError>()));
  });

  test("cast", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    final lFlatAsNum = lFlat.cast<num>();
    expect(lFlatAsNum, isA<Iterable<num>>());
  });

  test("iterator", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    final Iterator<int> iter = lFlat.iterator;

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
    final L<int> empty = LFlat.empty();

    expect(empty.unlock, <int>[]);
    expect(empty.isEmpty, isTrue);
  });

  test("deepListHashCode", () {
    // 1) Regular usage
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat<int>(original);
    expect(lFlat.deepListHashcode(), ListEquality().hash(original));

    // 2) Other checks
    expect(lFlat.deepListEquals(null), isFalse);
    expect(lFlat.deepListEquals(LFlat<int>([])), isFalse);
    expect(lFlat.deepListEquals(LFlat<int>(original)), isTrue);
    expect(lFlat.deepListEquals(LFlat<int>([1, 2, 3, 4])), isFalse);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable list doesn't change the LFlat
    List<int> original = [1, 2, 3];
    LFlat<int> lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.add(4);

    expect(original, [1, 2, 3, 4]);
    expect(lFlat, [1, 2, 3]);

    // 1.2) Adding to the original LFlat doesn't change it
    original = [1, 2, 3];
    lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2, 3]);

    L<int?> l = lFlat.add(4);

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4]);

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside LFlat
    original = [1, 2, 3];
    lFlat = LFlat<int>(original);

    expect(lFlat, original);

    int willChange = 4;
    l = lFlat.add(willChange);

    willChange = 5;

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(willChange, 5);
    expect(l, <int>[1, 2, 3, 4]);

    // 2) addAll

    // 2.1) Changing the passed mutable list doesn't change the LFlat
    original = [1, 2, 3];
    lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.addAll([4, 5]);

    expect(original, [1, 2, 3, 4, 5]);
    expect(lFlat, [1, 2, 3]);

    // 2.2) Changing the immutable list doesn't change the LFlat
    original = [1, 2, 3];
    lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2, 3]);

    l = lFlat.addAll([4, 5]);

    expect(original, <int>[1, 2, 3]);
    expect(lFlat, <int>[1, 2, 3]);
    expect(l, <int>[1, 2, 3, 4, 5]);

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = [1, 2];
    final LFlat<int> lFlat1 = LFlat(original), lFlat2 = LFlat(original);

    expect(lFlat1, <int>[1, 2]);
    expect(lFlat2, <int>[1, 2]);

    l = lFlat1.addAll(lFlat2);
    original.add(5);

    expect(original, <int>[1, 2, 5]);
    expect(lFlat1, <int>[1, 2]);
    expect(lFlat2, <int>[1, 2]);
    expect(l, <int>[1, 2, 1, 2]);

    // 3) remove

    // 3.1) Changing the passed mutable list doesn't change the LFlat
    original = [1, 2, 3];
    lFlat = LFlat<int>(original);

    expect(lFlat, original);

    original.remove(3);

    expect(original, [1, 2]);
    expect(lFlat, [1, 2, 3]);

    // 3.2) Removing from the original LFlat doesn't change it
    original = [1, 2];
    lFlat = LFlat(original);

    expect(lFlat, <int>[1, 2]);

    l = lFlat.remove(1);

    expect(original, <int>[1, 2]);
    expect(lFlat, <int>[1, 2]);
    expect(l, <int>[2]);
  });

  test("unsafe", () {
    final List<int> original = [1, 2, 3];
    final LFlat<int> lFlat = LFlat.unsafe(original);

    expect(lFlat, original);

    original.add(4);

    expect(original, [1, 2, 3, 4]);
    expect(lFlat, [1, 2, 3, 4]);
  });

  test("any", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.any((int v) => v == 4), isTrue);
    expect(lFlat.any((int v) => v == 100), isFalse);
  });

  test("contains", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.contains(2), isTrue);
    expect(lFlat.contains(4), isTrue);
    expect(lFlat.contains(5), isTrue);
    expect(lFlat.contains(100), isFalse);
    expect(lFlat.contains(null), isFalse);
  });

  test("elementAt", () {
    // 1) Regular element access
    LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);

    expect(lFlat.elementAt(0), 1);
    expect(lFlat.elementAt(1), 2);
    expect(lFlat.elementAt(2), 3);
    expect(lFlat.elementAt(3), 4);
    expect(lFlat.elementAt(4), 5);
    expect(lFlat.elementAt(5), 6);

    // 2) Range exceptions
    lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.elementAt(6), throwsRangeError);
    expect(() => lFlat.elementAt(-1), throwsRangeError);
  });

  test("every", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.every((int v) => v > 0), isTrue);
    expect(lFlat.every((int v) => v < 0), isFalse);
    expect(lFlat.every((int v) => v != 4), isFalse);
  });

  test("expand", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect(lFlat.expand((int v) => []), []);
  });

  test("first", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.first, 1);
  });

  test("last", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.last, 6);
  });

  test("single", () {
    // 1) State exception
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(() => lFlat.single, throwsStateError);

    // 2) Access
    expect([10].lock.single, 10);
  });

  test("firstWhere", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect(lFlat.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect(lFlat.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect(lFlat.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("fold", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.fold(100, (int p, int e) => p * (1 + e)), 504000);
  });

  test("followedBy", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.followedBy([7, 8]), [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(lFlat.followedBy([7, 8, 9]), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("forEach", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    int result = 100;
    lFlat.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("join", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.join(","), "1,2,3,4,5,6");
    expect(LFlat(<int>[]).join(","), "");
    expect(LFlat.empty().join(","), "");
  });

  test("lastWhere", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect(lFlat.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect(lFlat.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect(lFlat.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect(lFlat.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect(lFlat.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("map", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(LFlat([1, 2, 3]).map((int v) => v + 1), [2, 3, 4]);
    expect(lFlat.map((int v) => v + 1), [2, 3, 4, 5, 6, 7]);
  });

  test("reduce", () {
    // 1) Regular usage
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.reduce((int p, int e) => p * (1 + e)), 2520);
    expect(LFlat([5]).reduce((int p, int e) => p * (1 + e)), 5);

    // 2) State exception
    expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError);
  });

  test("singleWhere", () {
    // 1) Regular usage
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect(lFlat.singleWhere((int v) => v == 50, orElse: () => 100), 100);

    // 2) State exception
    expect(() => lFlat.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError);
  });

  test("skip", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.skip(1), [2, 3, 4, 5, 6]);
    expect(lFlat.skip(3), [4, 5, 6]);
    expect(lFlat.skip(5), [6]);
    expect(lFlat.skip(10), []);
  });

  test("skipWhile", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.skipWhile((int v) => v < 3), [3, 4, 5, 6]);
    expect(lFlat.skipWhile((int v) => v < 5), [5, 6]);
    expect(lFlat.skipWhile((int v) => v < 6), [6]);
    expect(lFlat.skipWhile((int v) => v < 100), []);
  });

  test("take", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.take(0), []);
    expect(lFlat.take(1), [1]);
    expect(lFlat.take(3), [1, 2, 3]);
    expect(lFlat.take(5), [1, 2, 3, 4, 5]);
    expect(lFlat.take(10), [1, 2, 3, 4, 5, 6]);
  });

  test("takeWhile", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.takeWhile((int v) => v < 3), [1, 2]);
    expect(lFlat.takeWhile((int v) => v < 5), [1, 2, 3, 4]);
    expect(lFlat.takeWhile((int v) => v < 6), [1, 2, 3, 4, 5]);
    expect(lFlat.takeWhile((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("toList", () {
    // 1) Regular usage
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);

    // 2) Unsupported exception
    expect(() => lFlat.toList(growable: false)..add(7), throwsUnsupportedError);
  });

  test("toSet", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        lFlat
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect(lFlat.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("where", () {
    final LFlat<int> lFlat = LFlat([1, 2, 3, 4, 5, 6]);
    expect(lFlat.where((int v) => v < 0), []);
    expect(lFlat.where((int v) => v < 3), [1, 2]);
    expect(lFlat.where((int v) => v < 5), [1, 2, 3, 4]);
    expect(lFlat.where((int v) => v < 100), [1, 2, 3, 4, 5, 6]);
  });

  test("whereType", () {
    expect((LFlat(<num>[1, 2, 1.5]).whereType<double>()), [1.5]);
  });
}
