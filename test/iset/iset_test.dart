import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  group('Creating immutable sets |', () {
    final ISet iSet1 = ISet(), iSet2 = ISet({});
    final iSet3 = ISet<String>({});
    final iSet4 = ISet([1]);

    test('Runtime Type', () {
      expect(iSet1, isA<ISet>());
      expect(iSet2, isA<ISet>());
      expect(iSet3, isA<ISet<String>>());
      expect(iSet4, isA<ISet<int>>());
    });

    test('Emptiness Properties', () {
      expect(iSet1.isEmpty, isTrue);
      expect(iSet2.isEmpty, isTrue);
      expect(iSet3.isEmpty, isTrue);
      expect(iSet4.isEmpty, isFalse);

      expect(iSet1.isNotEmpty, isFalse);
      expect(iSet2.isNotEmpty, isFalse);
      expect(iSet3.isNotEmpty, isFalse);
      expect(iSet4.isNotEmpty, isTrue);
    });
  });

  group('Creating immutable sets with extensiong |', () {
    test('From an empty set', () {
      final ISet iList = <int>{}.lock;

      expect(iList, isA<ISet>());
      expect(iList.isEmpty, isTrue);
      expect(iList.isNotEmpty, isFalse);
    });

    test('From a set with one `int` item', () {
      final ISet iSet = {1}.lock;

      expect(iSet, isA<ISet<int>>());
      expect(iSet.isEmpty, isFalse);
      expect(iSet.isNotEmpty, isTrue);
    });

    test('From a set with one `null` string', () {
      final String text = null;
      final ISet<String> typedList = {text}.lock;

      expect(typedList, isA<ISet<String>>());
    });

    test('From an empty set typed with `String`', () {
      final typedList = <String>{}.lock;

      expect(typedList, isA<ISet<String>>());
    });
  });

  group('Creating native mutable sets from immutable sets |', () {
    final Set<int> exampleSet = {1, 2, 3};

    test('From the default factory constructor', () {
      final ISet<int> iSet = ISet(exampleSet);

      expect(iSet.unlock, exampleSet);
      expect(identical(iSet.unlock, exampleSet), isFalse);
    });

    test('From `lock`', () {
      final ISet<int> iSet = exampleSet.lock;

      expect(iSet.unlock, exampleSet);
      expect(identical(iSet.unlock, exampleSet), isFalse);
    });
  });

  test('`flush`', () {
    final ISet<int> iSet =
        {1, 2, 3}.lock.add(4).addAll({5, 6}).add(7).addAll({}).addAll({8, 9});

    expect(iSet.isFlushed, isFalse);

    iSet.flush;

    expect(iSet.isFlushed, isTrue);
    expect(iSet.unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  group('Adding Elements', () {
    test('`add` and `addAll`', () {
      final ISet<int> iSet1 = {1, 2, 3}.lock;
      final ISet<int> iSet2 = iSet1.add(4);
      final ISet<int> iSet3 = iSet2.addAll({5, 6});

      expect(iSet1.unlock, {1, 2, 3});
      expect(iSet2.unlock, {1, 2, 3, 4});
      expect(iSet3.unlock, {1, 2, 3, 4, 5, 6});

      // Methods are chainable.
      expect(iSet1.add(10).addAll({20, 30}).unlock, {1, 2, 3, 10, 20, 30});
    });

    test('`add`', () {
      final ISet<int> iSet = ISet<int>([1]);

      iSet.add(2);

      expect(iSet.unlock, <int>{1, 2});
    });
  });

  test('`remove`', () {
    final ISet<int> iSet1 = {1, 2, 3}.lock;

    final ISet<int> iSet2 = iSet1.remove(2);
    expect(iSet2.unlock, {1, 3});

    final ISet<int> iSet3 = iSet2.remove(5);
    expect(iSet3.unlock, {1, 3});

    final ISet<int> iSet4 = iSet3.remove(1);
    expect(iSet4.unlock, {3});

    final ISet<int> iSet5 = iSet4.remove(3);
    expect(iSet5.unlock, <int>{});

    final ISet<int> iSet6 = iSet5.remove(7);
    expect(iSet6.unlock, <int>{});

    expect(identical(iSet1, iSet2), false);
  });
}
