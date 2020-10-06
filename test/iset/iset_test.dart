import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable sets |", () {
    final ISet iSet1 = ISet(), iSet2 = ISet({});
    final iSet3 = ISet<String>({});
    final iSet4 = ISet([1]);

    test("Runtime Type", () {
      expect(iSet1, isA<ISet>());
      expect(iSet2, isA<ISet>());
      expect(iSet3, isA<ISet<String>>());
      expect(iSet4, isA<ISet<int>>());
    });

    test("Emptiness Properties", () {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable sets with extension |", () {
    test("From an empty set", () {
      final ISet iList = <int>{}.lock;

      expect(iList, isA<ISet>());
      expect(iList.isEmpty, isTrue);
      expect(iList.isNotEmpty, isFalse);
    });

    test("From a set with one int item", () {
      final ISet iSet = {1}.lock;

      expect(iSet, isA<ISet<int>>());
      expect(iSet.isEmpty, isFalse);
      expect(iSet.isNotEmpty, isTrue);
    });

    test("From a set with one null string", () {
      final String text = null;
      final ISet<String> typedList = {text}.lock;

      expect(typedList, isA<ISet<String>>());
    });

    test("From an empty set typed with String", () {
      final typedList = <String>{}.lock;

      expect(typedList, isA<ISet<String>>());
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating native mutable sets from immutable sets |", () {
    final Set<int> exampleSet = {1, 2, 3};

    test("From the default factory constructor", () {
      final ISet<int> iSet = ISet(exampleSet);

      expect(iSet.unlock, exampleSet);
      expect(identical(iSet.unlock, exampleSet), isFalse);
    });

    test("From lock", () {
      final ISet<int> iSet = exampleSet.lock;

      expect(iSet.unlock, exampleSet);
      expect(identical(iSet.unlock, exampleSet), isFalse);
    });
  });

  test("ISet.flush", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6}).add(7).addAll({}).addAll({8, 9});

    expect(iSet.isFlushed, isFalse);

    iSet.flush;

    expect(iSet.isFlushed, isTrue);
    expect(iSet.unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Adding Elements", () {
    final ISet<int> baseSet = ISet<int>([1]);

    test("ISet.add", () {
      ISet<int> iSet = baseSet.add(2);

      expect(iSet.unlock, <int>{1, 2});
    });

    test("ISet.add with a repeated element", () {
      ISet<int> iSet = baseSet.add(1);

      expect(iSet.unlock, <int>{1});
    });

    test("ISet.add and ISet.addAll", () {
      final ISet<int> iSet1 = {1, 2, 3}.lock;
      final ISet<int> iSet2 = iSet1.add(4);
      final ISet<int> iSet3 = iSet2.addAll({5, 6});

      expect(iSet1.unlock, {1, 2, 3});
      expect(iSet2.unlock, {1, 2, 3, 4});
      expect(iSet3.unlock, {1, 2, 3, 4, 5, 6});

      // Methods are chainable.
      expect(iSet1.add(10).addAll({20, 30}).unlock, {1, 2, 3, 10, 20, 30});
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("Adding repeated elements |", () {
      final ISet<int> baseSet = ISet<int>({1, 2, 3});

      test("adding a repeated element", () {
        final ISet<int> iSet = baseSet.add(1);

        expect(iSet.length, 3);
        expect(iSet.unlock, {1, 2, 3});
      });

      test("adding multiple repeated elements", () {
        final ISet<int> iSet = baseSet.addAll({1, 2});

        expect(iSet.length, 3);
        expect(iSet.unlock, {1, 2, 3});
      });

      test("adding some repeated elements and another, new one", () {
        final ISet<int> iSet = baseSet.addAll({1, 2, 5, 7});

        expect(iSet.length, 5);
        expect(iSet.unlock, {1, 2, 3, 5, 7});
      });

      test("adding some repeated elements and new ones", () {
        final ISet<int> iSet = baseSet.addAll({1, 2, 5, 7, 11, 13});

        expect(iSet.length, 7);
        expect(iSet.unlock, {1, 2, 3, 5, 7, 11, 13});
      });
    });
  });

  test("ISet.remove", () {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("ISet methods from Iterable |", () {
    final ISet<int> iSet = {1, 2, 3}.lock.add(4).addAll({5, 6});

    test("ISet.any", () {
      expect(iSet.any((int v) => v == 4), isTrue);
      expect(iSet.any((int v) => v == 100), isFalse);
    });

    test("ISet.cast", () => expect(iSet.cast<num>(), isA<ISet<num>>()));

    test("ISet.contains", () {
      expect(iSet.contains(2), isTrue);
      expect(iSet.contains(4), isTrue);
      expect(iSet.contains(5), isTrue);
      expect(iSet.contains(100), isFalse);
    });

    test("ISet.every", () {
      expect(iSet.every((int v) => v > 0), isTrue);
      expect(iSet.every((int v) => v < 0), isFalse);
      expect(iSet.every((int v) => v != 4), isFalse);
    });

    test("ISet.expand", () {
      expect(iSet.expand((int v) => {v, v}),
          // ignore: equal_elements_in_set
          {1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6});
      expect(iSet.expand((int v) => <int>{}), <int>{});
    });

    test("ISet.length", () => expect(iSet.length, 6));

    test("ISet.first", () => expect(iSet.first, 1));

    test("ISet.last", () => expect(iSet.last, 6));

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.single |", () {
      test("State exception", () => expect(() => iSet.single, throwsStateError));

      test("Access", () => expect({10}.lock.single, 10));
    });

    test("ISet.firstWhere", () {
      expect(iSet.firstWhere((int v) => v > 1, orElse: () => 100), 2);
      expect(iSet.firstWhere((int v) => v > 4, orElse: () => 100), 5);
      expect(iSet.firstWhere((int v) => v > 5, orElse: () => 100), 6);
      expect(iSet.firstWhere((int v) => v > 6, orElse: () => 100), 100);
    });

    test("ISet.fold", () => expect(iSet.fold(100, (int p, int e) => p * (1 + e)), 504000));

    test("ISet.followedBy", () {
      expect(iSet.followedBy({7, 8}).unlock, {1, 2, 3, 4, 5, 6, 7, 8});
      expect(
          iSet.followedBy(<int>{}.lock.add(7).addAll({8, 9})).unlock, {1, 2, 3, 4, 5, 6, 7, 8, 9});
    });

    test("ISet.forEach", () {
      int result = 100;
      iSet.forEach((int v) => result *= 1 + v);
      expect(result, 504000);
    });

    test("ISet.join", () {
      expect(iSet.join(","), "1,2,3,4,5,6");
      expect(<int>{}.lock.join(","), "");
    });

    test("ISet.lastWhere", () {
      expect(iSet.lastWhere((int v) => v < 2, orElse: () => 100), 1);
      expect(iSet.lastWhere((int v) => v < 5, orElse: () => 100), 4);
      expect(iSet.lastWhere((int v) => v < 6, orElse: () => 100), 5);
      expect(iSet.lastWhere((int v) => v < 7, orElse: () => 100), 6);
      expect(iSet.lastWhere((int v) => v < 50, orElse: () => 100), 6);
      expect(iSet.lastWhere((int v) => v < 1, orElse: () => 100), 100);
    });

    test("ISet.map", () {
      expect({1, 2, 3}.lock.map((int v) => v + 1).unlock, {2, 3, 4});
      expect(iSet.map((int v) => v + 1).unlock, {2, 3, 4, 5, 6, 7});
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.reduce |", () {
      test("Regular usage", () {
        expect(iSet.reduce((int p, int e) => p * (1 + e)), 2520);
        expect({5}.lock.reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          "State exception",
          () => expect(() => ISet().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.singleWhere |", () {
      test("Regular usage", () {
        expect(iSet.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(iSet.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          "State exception",
          () => expect(
              () => iSet.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test("ISet.skip", () {
      expect(iSet.skip(1).unlock, {2, 3, 4, 5, 6});
      expect(iSet.skip(3).unlock, {4, 5, 6});
      expect(iSet.skip(5).unlock, {6});
      expect(iSet.skip(10).unlock, <int>{});
    });

    test("ISet.skipWhile", () {
      expect(iSet.skipWhile((int v) => v < 3).unlock, {3, 4, 5, 6});
      expect(iSet.skipWhile((int v) => v < 5).unlock, {5, 6});
      expect(iSet.skipWhile((int v) => v < 6).unlock, {6});
      expect(iSet.skipWhile((int v) => v < 100).unlock, <int>{});
    });

    test("ISet.take", () {
      expect(iSet.take(0).unlock, <int>{});
      expect(iSet.take(1).unlock, {1});
      expect(iSet.take(3).unlock, {1, 2, 3});
      expect(iSet.take(5).unlock, {1, 2, 3, 4, 5});
      expect(iSet.take(10).unlock, {1, 2, 3, 4, 5, 6});
    });

    test("ISet.takeWhile", () {
      expect(iSet.takeWhile((int v) => v < 3).unlock, {1, 2});
      expect(iSet.takeWhile((int v) => v < 5).unlock, {1, 2, 3, 4});
      expect(iSet.takeWhile((int v) => v < 6).unlock, {1, 2, 3, 4, 5});
      expect(iSet.takeWhile((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////

    group("ISet.toList |", () {
      test("Regular usage", () {
        expect(iSet.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(iSet.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test("Unsupported exception",
          () => expect(() => iSet.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test("ISet.toSet", () {
      expect(iSet.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(iSet.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("ISet.where", () {
      expect(iSet.where((int v) => v < 0).unlock, <int>{});
      expect(iSet.where((int v) => v < 3).unlock, {1, 2});
      expect(iSet.where((int v) => v < 5).unlock, {1, 2, 3, 4});
      expect(iSet.where((int v) => v < 100).unlock, {1, 2, 3, 4, 5, 6});
    });

    test("ISet.whereType", () => expect((<num>{1, 2, 1.5}.lock.whereType<double>()).unlock, {1.5}));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("ISet of MapEntry gets special treatment.", () {
    test("Equals", () {
      var iSet1 = ISet<MapEntry<String, int>>([MapEntry("a", 1)]).deepEquals;
      var iSet2 = ISet<MapEntry<String, int>>([MapEntry("a", 1)]).deepEquals;

      expect(iSet1, iSet2);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
