// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';
import "package:fast_immutable_collections/src/iset/s_add.dart";
import "package:fast_immutable_collections/src/iset/s_add_all.dart";
import "package:fast_immutable_collections/src/iset/s_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("Runtime Type", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll, isA<SAddAll<int>>());
  });

  test("unlock", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.unlock, [1, 2, 3, 4, 5]);
    expect(sAddAll.unlock, isA<Set<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.isEmpty, isFalse);
    expect(sAddAll.isNotEmpty, isTrue);
  });

  test("length, first, last", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({3, 4}), {1, 2, 5});
    expect(sAddAll.length, 5);
    expect(sAddAll.first, 3);
    expect(sAddAll.last, 5);
  });

  test("contains", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.contains(1), isTrue);
    expect(sAddAll.contains(6), isFalse);
    expect(sAddAll.contains(null), isFalse);
  });

  test("lookup", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.lookup(1), 1);
    expect(sAddAll.lookup(10), isNull);
  });

  test("containsAll", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.containsAll([2, 2, 3]), isTrue);
    expect(sAddAll.containsAll({1, 2, 3, 4}), isTrue);
    expect(sAddAll.containsAll({1, 2, 3, 4}.lock), isTrue);
    expect(sAddAll.containsAll({1, 2, 3, 4, 10}.lock), isFalse);
    expect(sAddAll.containsAll({10, 20, 30, 40}), isFalse);
  });

  test("difference", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.difference({3, 4, 10, 11}), {1, 2, 5});
    expect(sAddAll.difference({1, 2, 3, 4}), <int>{5});
  });

  test("intersection", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.intersection({1, 2, 5, 10, 11}), {1, 2, 5});
    expect(sAddAll.intersection({1}), {1});
    expect(sAddAll.intersection({3}), {3});
    expect(sAddAll.intersection({}), isEmpty);
    expect(sAddAll.intersection({10, 20, 50}), isEmpty);
  });

  test("union", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.union({1}), {1, 2, 3, 4, 5});
    expect(sAddAll.union({1, 2, 5, 10, 11}), {1, 2, 3, 4, 5, 10, 11});
  });

  test("[]", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(() => sAddAll[-100], throwsRangeError);
    expect(() => sAddAll[-1], throwsRangeError);
    expect(sAddAll[0], 1);
    expect(sAddAll[1], 2);
    expect(sAddAll[2], 3);
    expect(sAddAll[3], 4);
    expect(sAddAll[4], 5);
    expect(() => sAddAll[5], throwsRangeError);
    expect(() => sAddAll[100], throwsRangeError);
  });

  test("iterator (IteratorAddAll)", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    final Iterator<int?> iter = sAddAll.iterator;

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
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 5);
    expect(iter.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter.current, throwsStateError);
  });

  test("anyItem", () {
    final SAddAll<int> sAddAll = SAddAll(SFlat<int>.unsafe({1, 2}), {3, 4, 5});
    expect(sAddAll.anyItem, isA<int>());
  });

  test("unsafe", () {
    // 1) Regular usage
    final Set<int> set = {3, 4, 5};
    final SAddAll<int> sAddAll = SAddAll.unsafe(SFlat<int>.unsafe({1, 2}), set);

    expect(sAddAll, {1, 2, 3, 4, 5});

    set.add(10);

    expect(sAddAll, {1, 2, 3, 4, 5, 10});
  });

  test("Combining various SAddAlls and SAdds | Runtime Type", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    expect(sAddAll, isA<SAddAll<int>>());
  });

  test("Combining various SAddAlls and SAdds | unlock", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    expect(sAddAll.unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(sAddAll.unlock, isA<Set<int>>());
  });

  test("Combining various SAddAlls and SAdds | isEmpty | isNotEmpty", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    expect(sAddAll.isEmpty, isFalse);
    expect(sAddAll.isNotEmpty, isTrue);
  });

  test("Combining various SAddAlls and SAdds | length", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    expect(sAddAll.length, 8);
  });

  test("Combining various SAddAlls and SAdds | contains", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    expect(sAddAll.contains(1), isTrue);
    expect(sAddAll.contains(9), isFalse);
    expect(sAddAll.contains(null), isFalse);
  });

  test("Combining various SAddAlls and SAdds | iterator (IteratorAddAll)", () {
    final sAddAll = SAddAll(
        SAddAll(SAddAll(SAdd(SAddAll(SFlat.unsafe({1, 2}), {3, 4}), 5), {6, 7}), <int>{}), {8});
    final Iterator<int?> iter = sAddAll.iterator;

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
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 5);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 6);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 7);
    expect(iter.moveNext(), isTrue);
    expect(iter.current, 8);
    expect(iter.moveNext(), isFalse);

    // Throws StateError after last moveNext().
    expect(() => iter.current, throwsStateError);
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable set doesn't change the SAddAll
    Set<int> original = {3, 4, 5};
    SAddAll<int?> sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    original.add(5);
    original.add(6);

    expect(original, <int>{3, 4, 5, 6});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    // 1.2) Adding to the original SAddAll doesn't change it
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    final S<int?> s1 = sAddAll.add(6);
    final S<int?> s2 = sAddAll.add(5);

    expect(original, <int>{3, 4, 5});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});
    expect(s1, <int>{1, 2, 3, 4, 5, 6});
    expect(s2, <int>{1, 2, 3, 4, 5});

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside SAddAll
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    int willChange = 6;
    S<int?> s = sAddAll.add(willChange);

    willChange = 7;

    expect(original, <int>{3, 4, 5});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});
    expect(willChange, 7);
    expect(s, <int>{1, 2, 3, 4, 5, 6});

    // 2) addAll

    // 2.1) Changing the passed mutable set doesn't change the SAddAll
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    original.addAll(<int>{5, 6, 7});

    expect(original, <int>{3, 4, 5, 6, 7});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    // 2.2) Changing the passed immutable set doesn't change the original SAddAll
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    s = sAddAll.addAll({6, 7});

    expect(original, <int>{3, 4, 5});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});
    expect(s, <int>{1, 2, 3, 4, 5, 6, 7});

    // 2.3) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = {3, 4, 5};
    final SAddAll<int> sAddAll1 = SAddAll(SFlat<int>({1, 2}), original),
        sAddAll2 = SAddAll(SFlat<int>({8, 9}), original);

    expect(sAddAll1, <int>{1, 2, 3, 4, 5});
    expect(sAddAll2, <int>{8, 9, 3, 4, 5});

    s = sAddAll1.addAll(sAddAll2);
    original.add(6);

    expect(original, <int>{3, 4, 5, 6});
    expect(sAddAll1, <int>{1, 2, 3, 4, 5});
    expect(sAddAll2, <int>{8, 9, 3, 4, 5});
    expect(s, <int>{1, 2, 3, 4, 5, 8, 9});

    // 3) remove

    // 3.1) Changing the passed mutable set doesn't change SAddAll
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    original.remove(3);

    expect(original, <int>{4, 5});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    // 3.2) Removing from the original SAddAll doesn't change it
    original = {3, 4, 5};
    sAddAll = SAddAll(SFlat<int>({1, 2}), original);

    expect(sAddAll, <int>{1, 2, 3, 4, 5});

    s = sAddAll.remove(1);

    expect(original, <int>{3, 4, 5});
    expect(sAddAll, <int>{1, 2, 3, 4, 5});
    expect(s, <int>{2, 3, 4, 5});
  });
}
