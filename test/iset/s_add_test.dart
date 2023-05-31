// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("Runtime Type", () {
    final SAdd<int> sAdd = SAdd<int>(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd, isA<SAdd<int>>());
  });

  test("unlock", () {
    final SAdd<int> sAdd = SAdd<int>(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.unlock, <int>[1, 2, 3, 4]);
    expect(sAdd.unlock, isA<Set<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.isEmpty, isFalse);
    expect(sAdd.isNotEmpty, isTrue);
  });

  test("length", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.length, 4);
  });

  test("contains", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.contains(1), isTrue);
    expect(sAdd.contains(5), isFalse);
    expect(sAdd.contains(null), isFalse);
  });

  test("lookup", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.lookup(1), 1);
    expect(sAdd.lookup(10), isNull);
  });

  test("containsAll", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.containsAll([2, 2, 3]), isTrue);
    expect(sAdd.containsAll({1, 2, 3, 4}), isTrue);
    expect(sAdd.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(sAdd.containsAll({1, 2, 3, 4, 10}.lock), isFalse);
    expect(sAdd.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.difference({1, 2, 5}), {3, 4});
    expect(sAdd.difference({4}), {1, 2, 3});
    expect(sAdd.difference({2, 4}), {1, 3});
    expect(sAdd.difference({1, 2, 3, 4}), <int>{});
  });

  test("intersection", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.intersection({1, 2, 4, 5, 10}), {1, 2, 4});
    expect(sAdd.intersection({10, 20, 50}), <int>{});
  });

  test("union", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(sAdd.union({1}), {1, 2, 3, 4});
    expect(sAdd.union({1, 2, 5}), {1, 2, 3, 4, 5});
  });

  test("iterator (IteratorSAdd)", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    final Iterator<int?> iter = sAdd.iterator;

    // Throws StateError before first moveNext().
    expect(() => iter.current, throwsStateError);

    expect(iter.moveNext(), isTrue);
    expect(iter.current, 1);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 2);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 3);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 4);
    expect(iter.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter.current, throwsStateError);
  });

  test("[]", () {
    final SAdd<int> sAdd = SAdd(SFlat<int>.unsafe({1, 2, 3}), 4);
    expect(() => sAdd[-100], throwsRangeError);
    expect(() => sAdd[-1], throwsRangeError);
    expect(sAdd[0], 1);
    expect(sAdd[1], 2);
    expect(sAdd[2], 3);
    expect(sAdd[3], 4);
    expect(() => sAdd[4], throwsRangeError);
    expect(() => sAdd[100], throwsRangeError);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable set doesn't change the LAdd
    Set<int> original = {1, 2};
    SFlat<int> sFlat = SFlat(original);
    SAdd<int?> sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    original.add(2);
    original.add(3);

    expect(original, <int>{1, 2, 3});
    expect(sAdd, <int>{1, 2, 3});

    // 1.2) Adding to the original SAdd doesn't change it
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    final S<int?> s1 = sAdd.add(4);
    final S<int?> s2 = sAdd.add(3);

    expect(original, <int>{1, 2});
    expect(sAdd, <int>{1, 2, 3});
    expect(s1, <int>{1, 2, 3, 4});
    expect(s2, <int>{1, 2, 3});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside SAdd
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    int willChange = 4;
    S<int?> s = sAdd.add(willChange);

    willChange = 5;

    expect(original, <int>{1, 2});
    expect(sAdd, <int>{1, 2, 3});
    expect(willChange, 5);
    expect(s, <int>{1, 2, 3, 4});

    // 2) addAll

    // 2.1) Changing the passed mutable set doesn't change the SAdd
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    original.addAll(<int>{3, 4});

    expect(original, <int>{1, 2, 3, 4});
    expect(sAdd, <int>{1, 2, 3});

    // 2.2) Changing the passed immutable set doesn't change the original SAdd
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    s = sAdd.addAll({3, 4, 5});

    expect(original, <int>{1, 2});
    expect(sAdd, <int>{1, 2, 3});
    expect(s, <int>{1, 2, 3, 4, 5});

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {1, 2};
    sFlat = SFlat(original);
    final SAdd<int> sAdd1 = SAdd(sFlat, 3), sAdd2 = SAdd(sFlat, 4);

    expect(sAdd1, <int>{1, 2, 3});
    expect(sAdd2, <int>{1, 2, 4});

    s = sAdd1.addAll(sAdd2);
    original.add(5);

    expect(original, <int>{1, 2, 5});
    expect(sAdd1, <int>{1, 2, 3});
    expect(sAdd2, <int>{1, 2, 4});
    expect(s, <int>{1, 2, 3, 4});

    // 3) remove

    // 3.1) Changing the passed mutable set doesn't change the SAdd
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    original.remove(2);

    expect(original, <int>{1});
    expect(sAdd, <int>{1, 2, 3});

    // 3.2) Removing from the original SAdd doesn't change it
    original = {1, 2};
    sFlat = SFlat(original);
    sAdd = SAdd(sFlat, 3);

    expect(sAdd, <int>{1, 2, 3});

    s = sAdd.remove(1);

    expect(original, <int>{1, 2});
    expect(sAdd, <int>{1, 2, 3});
    expect(s, <int>{2, 3});
  });
}
