// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import 'package:fast_immutable_collections/src/ilist/ilist.dart';
import "package:fast_immutable_collections/src/ilist/l_add.dart";
import "package:fast_immutable_collections/src/ilist/l_add_all.dart";
import "package:fast_immutable_collections/src/ilist/l_flat.dart";
import "package:test/test.dart";

void main() {
  //
  test("Runtime Type", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll, isA<LAddAll<int>>());
  });

  test("unlock", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll.unlock, isA<List<int>>());
  });

  test("isEmpty | isNotEmpty", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.isEmpty, isFalse);
    expect(lAddAll.isNotEmpty, isTrue);
  });

  test("length, first, last, single", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([5, 2]), [3, 4, 1]);
    expect(lAddAll.length, 5);
    expect(lAddAll.first, 5);
    expect(lAddAll.last, 1);
    expect(() => lAddAll.single, throwsStateError);
    expect(LAddAll(LFlat<int>([]), [1]).single, 1);
  });

  test("[]", () {
    // 1) Regular usage
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll[0], 1);
    expect(lAddAll[1], 2);
    expect(lAddAll[2], 3);
    expect(lAddAll[3], 4);
    expect(lAddAll[4], 5);

    // 2) Range Errors
    expect(() => lAddAll[5], throwsA(isA<RangeError>()));
    expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
  });

  test("contains", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.contains(1), isTrue);
    expect(lAddAll.contains(6), isFalse);
    expect(lAddAll.contains(null), isFalse);
  });

  test("iter", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    expect(lAddAll.iter, allOf(isA<Iterable<int>>(), [1, 2, 3, 4, 5]));
  });

  test("iterator", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), [3, 4, 5]);
    final Iterator<int?> iter = lAddAll.iterator;

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

  test("iter", () {
    final LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 3]), [2, 4, 5]);
    expect(lAddAll, allOf(isA<Iterable<int>>(), [1, 3, 2, 4, 5]));
  });

  group("Combining various LAddAlls, LAdds, LFlats and Lists |", () {
    test("Runtime Type", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll, isA<LAddAll<int>>());
    });

    test("unlock", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.unlock, <int>[1, 2, 3, 4, 5, 6, 7, 8]);
      expect(lAddAll.unlock, isA<List<int>>());
    });

    test("isEmpty | isNotEmpty", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.isEmpty, isFalse);
      expect(lAddAll.isNotEmpty, isTrue);
    });

    test("length", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.length, 8);
    });

    test("[]", () {
      // 1) Regular usage
      final LAddAll<int> lAddAll = LAddAll(LFlat([1, 2, 3]), [4, 5, 6, 7]);

      expect(lAddAll[0], 1);
      expect(lAddAll[1], 2);
      expect(lAddAll[2], 3);
      expect(lAddAll[3], 4);
      expect(lAddAll[4], 5);
      expect(lAddAll[5], 6);
      expect(lAddAll[6], 7);

      // 2) Range errors
      expect(() => lAddAll[7], throwsA(isA<RangeError>()));
      expect(() => lAddAll[-1], throwsA(isA<RangeError>()));
    });

    test("contains", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      expect(lAddAll.contains(1), isTrue);
      expect(lAddAll.contains(8), isTrue);
      expect(lAddAll.contains(null), isFalse);
    });

    test("iterator", () {
      final lAddAll =
          LAddAll(LAddAll(LAddAll(LAdd(LAddAll(LFlat([1, 2]), [3, 4]), 5), [6, 7]), <int>[]), [8]);
      final Iterator<int?> iter = lAddAll.iterator;

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
  });

  test("Ensuring Immutability", () {
    // 1) add

    // 1.1) Changing the passed mutable list doesn't change the LAddAll
    List<int> original = [3, 4, 5];
    LAddAll<int> lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.add(6);

    expect(original, <int>[3, 4, 5, 6]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    // 1.2) Adding to the original LAddAll doesn't change it
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    L<int?> l = lAddAll.add(6);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 6]);

    // 1.3) If the item being passed is a variable, a pointer to it shouldn't exist inside LAddAll
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    int willChange = 6;
    l = lAddAll.add(willChange);

    willChange = 7;

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(willChange, 7);
    expect(l, <int>[1, 2, 3, 4, 5, 6]);

    // 2) addAll

    // 2.1) Changing the passed mutable list doesn't change the LAddAll
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.addAll(<int>[6, 7]);

    expect(original, <int>[3, 4, 5, 6, 7]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    // 2.2) Changing the passed immutable list doesn't change the original LAddAll
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    l = lAddAll.addAll([6, 7]);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 6, 7]);

    // 2.2) If the items being passed are from a variable, it shouldn't have a pointer to the
    // variable
    original = [3, 4, 5];
    final LAddAll<int> lAddAll1 = LAddAll(LFlat<int>([1, 2]), original);
    final LAddAll<int> lAddAll2 = LAddAll(LFlat<int>([8, 9]), original);

    expect(lAddAll1, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll2, <int>[8, 9, 3, 4, 5]);

    l = lAddAll1.addAll(lAddAll2);
    original.add(6);

    expect(original, <int>[3, 4, 5, 6]);
    expect(lAddAll1, <int>[1, 2, 3, 4, 5]);
    expect(lAddAll2, <int>[8, 9, 3, 4, 5]);
    expect(l, <int>[1, 2, 3, 4, 5, 8, 9, 3, 4, 5]);

    // 2.3) Changing the passed mutable list doesn't change the LAddAll
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    original.remove(3);

    expect(original, <int>[4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    // 3) remove

    // 3.1) Removing from the original LAddAll doesn't change it
    original = [3, 4, 5];
    lAddAll = LAddAll(LFlat<int>([1, 2]), original);

    expect(lAddAll, <int>[1, 2, 3, 4, 5]);

    l = lAddAll.remove(1);

    expect(original, <int>[3, 4, 5]);
    expect(lAddAll, <int>[1, 2, 3, 4, 5]);
    expect(l, <int>[2, 3, 4, 5]);
  });
}
