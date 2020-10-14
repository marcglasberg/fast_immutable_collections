import 'dart:collection';

import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable lists |", () {
    final IList iList1 = IList(), iList2 = IList([]);
    final iList3 = IList<String>([]),
        iList4 = IList([1]),
        iList5 = IList.empty<int>(),
        iList6 = [].lock;

    test("Runtime Type", () {
      expect(iList1, isA<IList>());
      expect(iList2, isA<IList>());
      expect(iList3, isA<IList<String>>());
      expect(iList4, isA<IList<int>>());
      expect(iList5, isA<IList<int>>());
      expect(iList6, isA<IList>());
    });

    test("Emptiness Properties", () {
      expect(iList1.isEmpty, isTrue);
      expect(iList2.isEmpty, isTrue);
      expect(iList3.isEmpty, isTrue);
      expect(iList4.isEmpty, isFalse);
      expect(iList5.isEmpty, isTrue);
      expect(iList6.isEmpty, isTrue);

      expect(iList1.isNotEmpty, isFalse);
      expect(iList2.isNotEmpty, isFalse);
      expect(iList3.isNotEmpty, isFalse);
      expect(iList4.isNotEmpty, isTrue);
      expect(iList5.isNotEmpty, isFalse);
      expect(iList6.isNotEmpty, isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Ensuring Immutability |", () {
    group("IList.add method |", () {
      test("Changing the passed mutable list doesn't change the IList", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, original);

        original.add(3);
        original.add(4);

        expect(original, <int>[1, 2, 3, 4]);
        expect(iList.unlock, <int>[1, 2]);
      });

      test("Changing the IList also doesn't change the original list", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, original);

        final IList<int> iListNew = iList.add(3);

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(iListNew, <int>[1, 2, 3]);
      });

      test("If the item being passed is a variable, a pointer to it shouldn't exist inside IList",
          () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, original);

        int willChange = 4;
        final IList<int> iListNew = iList.add(willChange);

        willChange = 5;

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(willChange, 5);
        expect(iListNew, <int>[1, 2, 4]);
      });
    });

    group("IList.addAll method |", () {
      test("Changing the passed mutable list doesn't change the IList", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, <int>[1, 2]);

        original.addAll(<int>[3, 4]);

        expect(original, <int>[1, 2, 3, 4]);
        expect(iList, <int>[1, 2]);
      });

      test("Changing the passed immutable list doesn't change the IList", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, <int>[1, 2]);

        final IList<int> iListNew = iList.addAll(<int>[3, 4]);

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(iListNew, <int>[1, 2, 3, 4]);
      });

      test(
          "If the items being passed are from a variable, "
          "it shouldn't have a pointer to the variable", () {
        final List<int> original = [1, 2];
        final IList<int> iList1 = original.lock;
        final IList<int> iList2 = original.lock;

        expect(iList1, original);
        expect(iList2, original);

        final IList<int> iListNew = iList1.addAll(iList2);
        original.add(3);

        expect(original, <int>[1, 2, 3]);
        expect(iList1, <int>[1, 2]);
        expect(iList2, <int>[1, 2]);
        expect(iListNew, <int>[1, 2, 1, 2]);
      });
    });

    group("IList.remove method |", () {
      test("Changing the passed mutable list doesn't change the IList", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, [1, 2]);

        original.remove(2);

        expect(original, <int>[1]);
        expect(iList, <int>[1, 2]);
      });

      test("Removing from the original IList doesn't change it", () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, <int>[1, 2]);

        final IList<int> iListNew = iList.remove(1);

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(iListNew, <int>[2]);
      });
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Equals and Other Comparisons |", () {
    group("Equals Operator |", () {
      test("IList with identity-equals compares the list instance, not the items", () {
        final IList<int> myList1 = IList([1, 2]).withIdentityEquals;
        expect(myList1 == myList1, isTrue);
        expect(myList1 == IList([1, 2]).withIdentityEquals, isFalse);
        expect(myList1 == IList([2, 1]).withIdentityEquals, isFalse);
        expect(myList1 == [1, 2].lock, isFalse);
        expect(myList1 == IList([1, 2, 3]).withIdentityEquals, isFalse);
      });

      test("IList with deep-equals compares the items, not necessarily the list instance", () {
        final IList<int> myList = IList([1, 2]);
        expect(myList == myList, isTrue);
        expect(myList == IList([1, 2]), isTrue);
        expect(myList == IList([2, 1]), isFalse);
        expect(myList == [1, 2].lock.withDeepEquals, isTrue);
        expect(myList == IList([1, 2, 3]), isFalse);
      });

      test("IList with deep-equals is always different from iList with identity-equals", () {
        expect(IList([1, 2]).withDeepEquals == IList([1, 2]).withIdentityEquals, isFalse);
        expect(IList([1, 2]).withIdentityEquals == IList([1, 2]).withDeepEquals, isFalse);
        expect(IList([1, 2]).withDeepEquals == IList([1, 2]), isTrue);
        expect(IList([1, 2]) == IList([1, 2]).withDeepEquals, isTrue);
      });
    });

    group("Other Comparisons |", () {
      test("IList.isIdentityEquals and IList.isDeepEquals properties", () {
        final IList<int> iList1 = IList([1, 2]), iList2 = IList([1, 2]).withIdentityEquals;

        expect(iList1.isIdentityEquals, isFalse);
        expect(iList1.isDeepEquals, isTrue);
        expect(iList2.isIdentityEquals, isTrue);
        expect(iList2.isDeepEquals, isFalse);
      });

      group("Same, Equals and the == Operator |", () {
        final IList<int> iList1 = IList([1, 2]),
            iList2 = IList([1, 2]),
            iList3 = IList([1]),
            iList4 = IList(([2, 1])),
            iList5 = IList([1, 2]).withIdentityEquals;

        test("IList.same method", () {
          expect(iList1.same(iList1), isTrue);
          expect(iList1.same(iList2), isFalse);
          expect(iList1.same(iList3), isFalse);
          expect(iList1.same(iList4), isFalse);
          expect(iList1.same(iList5), isFalse);
          expect(iList1.same(iList1.remove(3)), isTrue);
        });

        test("IList.equalItemsAndConfig method", () {
          expect(iList1.equalItemsAndConfig(iList1), isTrue);
          expect(iList1.equalItemsAndConfig(iList2), isTrue);
          expect(iList1.equalItemsAndConfig(iList3), isFalse);
          expect(iList1.equalItemsAndConfig(iList4), isFalse);
          expect(iList1.equalItemsAndConfig(iList5), isFalse);
          expect(iList1.equalItemsAndConfig(iList1.remove(3)), isTrue);
        });

        test("IList.== operator", () {
          expect(iList1 == iList1, isTrue);
          expect(iList1 == iList2, isTrue);
          expect(iList1 == iList3, isFalse);
          expect(iList1 == iList4, isFalse);
          expect(iList1 == iList5, isFalse);
        });

        group("IList.equalItems method |", () {
          final IList<int> iList1 = IList([1, 2]),
              iList2 = IList([1]),
              iList3 = IList([2, 1]),
              iList4 = IList([1, 2]);

          test("Identity", () => expect(iList1.equalItems(iList1), isTrue));

          test("Passing a set", () {
            expect(() => iList1.equalItems(ISet([1, 2])), throwsStateError);
            expect(() => iList1.equalItems(HashSet()..add(1)..add(2)), throwsStateError);
          });

          test("If IList, will only be equal if in order and the same items", () {
            expect(iList1.equalItems(iList2), isFalse);
            expect(iList1.equalItems(iList3), isFalse);
            expect(iList1.equalItems(iList4), isTrue);
          });

          test("If List, will only be equal if in order and the same items", () {
            expect(iList1.equalItems(iList2.toList()), isFalse);
            expect(iList1.equalItems(iList3.toList()), isFalse);
            expect(iList1.equalItems(iList4.toList()), isTrue);
          });

          test("If Iterable, will only be equal if in order and the same items", () {
            expect(iList1.equalItems({'a': 1}.values), isFalse);
            expect(iList1.equalItems({'a': 2, 'b': 1}.values), isFalse);
            expect(iList1.equalItems({'a': 1, 'b': 2}.values), isTrue);
          });
        });
      });
    });

    group("IList.hashCode method |", () {
      final IList<int> iList1 = IList([1, 2]),
          iList2 = IList([1, 2]),
          iList3 = IList([1, 2, 3]),
          iList4 = IList([2, 1]);
      final IList<int> iList1WithIdentity = iList1.withIdentityEquals,
          iList2WithIdentity = iList2.withIdentityEquals,
          iList3WithIdentity = iList3.withIdentityEquals,
          iList4WithIdentity = iList4.withIdentityEquals;

      test("deepEquals vs deepEquals", () {
        expect(iList1 == iList2, isTrue);
        expect(iList1 == iList3, isFalse);
        expect(iList1 == iList4, isFalse);
        expect(iList1.hashCode, iList2.hashCode);
        expect(iList1.hashCode, isNot(iList3.hashCode));
        expect(iList1.hashCode, isNot(iList4.hashCode));
      });

      test("identityEquals vs identityEquals", () {
        expect(iList1WithIdentity == iList2WithIdentity, isFalse);
        expect(iList1WithIdentity == iList3WithIdentity, isFalse);
        expect(iList1WithIdentity == iList4WithIdentity, isFalse);
        expect(iList1WithIdentity.hashCode, isNot(iList2WithIdentity.hashCode));
        expect(iList1WithIdentity.hashCode, isNot(iList3WithIdentity.hashCode));
        expect(iList1WithIdentity.hashCode, isNot(iList4WithIdentity.hashCode));
      });

      test("deepEquals vs identityEquals", () {
        expect(iList1 == iList1WithIdentity, isFalse);
        expect(iList2 == iList2WithIdentity, isFalse);
        expect(iList3 == iList3WithIdentity, isFalse);
        expect(iList4 == iList4WithIdentity, isFalse);
        expect(iList1.hashCode, isNot(iList1WithIdentity.hashCode));
        expect(iList2.hashCode, isNot(iList2WithIdentity.hashCode));
        expect(iList3.hashCode, isNot(iList3WithIdentity.hashCode));
        expect(iList4.hashCode, isNot(iList4WithIdentity.hashCode));
      });
    });

    test("IList.withConfig method", () {
      final IList<int> iList = IList([1, 2]);

      expect(iList.isDeepEquals, isTrue);

      IList<int> iListNewConfig = iList.withConfig(iList.config.copyWith());

      IList<int> iListNewConfigIdentity =
          iList.withConfig(iList.config.copyWith(isDeepEquals: false));

      expect(iListNewConfig.isDeepEquals, isTrue);
      expect(iListNewConfigIdentity.isDeepEquals, isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating immutable lists with extensions |", () {
    test("From an empty list", () {
      final IList iList = [].lock;

      expect(iList, isA<IList>());
      expect(iList.isEmpty, isTrue);
      expect(iList.isNotEmpty, isFalse);
    });

    test("From a list with one int item", () {
      final IList iList = [1].lock;

      expect(iList, isA<IList<int>>());
      expect(iList.isEmpty, isFalse);
      expect(iList.isNotEmpty, isTrue);
    });

    test("From a list with one null string", () {
      final String text = null;
      final IList<String> typedList = [text].lock;

      expect(typedList, isA<IList<String>>());
    });

    test("From an empty list typed with String", () {
      final typedList = <String>[].lock;

      expect(typedList, isA<IList<String>>());
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Creating native mutable lists from immutable lists |", () {
    final List<int> list = [1, 2, 3];

    test("From the default factory constructor", () {
      final IList<int> ilist = IList(list);

      expect(ilist.unlock, list);
      expect(identical(ilist.unlock, list), isFalse);
    });

    test("From lock", () {
      final IList<int> iList = list.lock;

      expect(iList.unlock, list);
      expect(identical(iList.unlock, list), isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList.flush method", () {
    final IList<int> ilist = [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);

    expect(ilist.isFlushed, isFalse);

    ilist.flush;

    expect(ilist.isFlushed, isTrue);
    expect(ilist.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("Adding |", () {
    final IList<int> ilist1 = [1, 2, 3].lock;
    final IList<int> ilist2 = ilist1.add(4);
    final IList<int> ilist3 = ilist2.addAll([5, 6]);

    test("IList.add method", () {
      expect(ilist1.unlock, [1, 2, 3]);
      expect(ilist2.unlock, [1, 2, 3, 4]);
    });

    test("IList.addAll method", () {
      expect(ilist1.unlock, [1, 2, 3]);
      expect(ilist3.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("IList.add and IList.addAll methods at the same time",
        () => expect(ilist1.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList.remove method", () {
    final IList<int> ilist1 = [1, 2, 3].lock;

    final IList<int> ilist2 = ilist1.remove(2);
    expect(ilist2.unlock, [1, 3]);

    final IList<int> ilist3 = ilist2.remove(5);
    expect(ilist3.unlock, [1, 3]);

    final IList<int> ilist4 = ilist3.remove(1);
    expect(ilist4.unlock, [3]);

    final IList<int> ilist5 = ilist4.remove(3);
    expect(ilist5.unlock, []);

    final IList<int> ilist6 = ilist5.remove(7);
    expect(ilist6.unlock, []);

    expect(identical(ilist1, ilist2), false);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("IList.maxLength method |", () {
    final IList<int> ilist1 = [1, 2, 3, 4, 5].lock;

    test("Cutting the list off", () {
      final IList<int> ilist2 = ilist1.maxLength(2);
      expect(ilist2.unlock, [1, 2]);

      final IList<int> ilist3 = ilist1.maxLength(3);
      expect(ilist3.unlock, [1, 2, 3]);

      final IList<int> ilist4 = ilist1.maxLength(1);
      expect(ilist4.unlock, [1]);

      final IList<int> ilist5 = ilist1.maxLength(0);
      expect(ilist5.unlock, []);
    });

    test("Invalid argument", () => expect(() => ilist1.maxLength(-1), throwsArgumentError));
  });

  group("IList.toggle method", () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    test("Toggling an existing element", () {
      expect(iList.contains(4), isTrue);

      iList = iList.toggle(4);

      expect(iList.contains(4), isFalse);

      iList = iList.toggle(4);

      expect(iList.contains(4), isTrue);
    });

    test("Toggling an inexistent element", () {
      expect(iList.contains(6), isFalse);

      iList = iList.toggle(6);

      expect(iList.contains(6), isTrue);

      iList = iList.toggle(6);

      expect(iList.contains(6), isFalse);
    });
  });

  group("Index Access |", () {
    final IList<int> iList = [1, 2, 3, 4, 5].lock;

    test("iList[index]", () {
      expect(iList[0], 1);
      expect(iList[1], 2);
      expect(iList[2], 3);
      expect(iList[3], 4);
      expect(iList[4], 5);
    });

    test("Range Errors", () {
      expect(() => iList[5], throwsA(isA<RangeError>()));
      expect(() => iList[-1], throwsA(isA<RangeError>()));
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group("IList methods from Iterable |", () {
    final IList<int> iList = [1, 2, 3].lock.add(4).addAll([5, 6]);

    test("IList.any method", () {
      expect(iList.any((int v) => v == 4), isTrue);
      expect(iList.any((int v) => v == 100), isFalse);
    });

    test("IList.cast method", () => expect(iList.cast<num>(), isA<IList<num>>()));

    test("IList.contains method", () {
      expect(iList.contains(2), isTrue);
      expect(iList.contains(4), isTrue);
      expect(iList.contains(5), isTrue);
      expect(iList.contains(100), isFalse);
    });

    group("IList.elementAt method |", () {
      test("Regular element access", () {
        expect(iList.elementAt(0), 1);
        expect(iList.elementAt(1), 2);
        expect(iList.elementAt(2), 3);
        expect(iList.elementAt(3), 4);
        expect(iList.elementAt(4), 5);
        expect(iList.elementAt(5), 6);
      });

      test("Range exceptions", () {
        expect(() => iList.elementAt(6), throwsRangeError);
        expect(() => iList.elementAt(-1), throwsRangeError);
      });
    });

    test("IList.every method", () {
      expect(iList.every((int v) => v > 0), isTrue);
      expect(iList.every((int v) => v < 0), isFalse);
      expect(iList.every((int v) => v != 4), isFalse);
    });

    test("IList.expand method", () {
      expect(iList.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
      expect(iList.expand((int v) => []), []);
    });

    test("IList.length method", () => expect(iList.length, 6));

    test("IList.first method", () => expect(iList.first, 1));

    test("IList.last method", () => expect(iList.last, 6));

    group("IList.single method |", () {
      test("State exception", () => expect(() => iList.single, throwsStateError));

      test("Access", () => expect([10].lock.single, 10));
    });

    test("IList.firstWhere method", () {
      expect(iList.firstWhere((int v) => v > 1, orElse: () => 100), 2);
      expect(iList.firstWhere((int v) => v > 4, orElse: () => 100), 5);
      expect(iList.firstWhere((int v) => v > 5, orElse: () => 100), 6);
      expect(iList.firstWhere((int v) => v > 6, orElse: () => 100), 100);
    });

    test("IList.fold method", () => expect(iList.fold(100, (int p, int e) => p * (1 + e)), 504000));

    test("IList.followedBy method", () {
      expect(iList.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(
          iList.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test("IList.forEach method", () {
      int result = 100;
      iList.forEach((int v) => result *= 1 + v);
      expect(result, 504000);
    });

    test("IList.join method", () {
      expect(iList.join(","), "1,2,3,4,5,6");
      expect([].lock.join(","), "");
    });

    test("IList.lastWhere method", () {
      expect(iList.lastWhere((int v) => v < 2, orElse: () => 100), 1);
      expect(iList.lastWhere((int v) => v < 5, orElse: () => 100), 4);
      expect(iList.lastWhere((int v) => v < 6, orElse: () => 100), 5);
      expect(iList.lastWhere((int v) => v < 7, orElse: () => 100), 6);
      expect(iList.lastWhere((int v) => v < 50, orElse: () => 100), 6);
      expect(iList.lastWhere((int v) => v < 1, orElse: () => 100), 100);
    });

    test("IList.map method", () {
      expect([1, 2, 3].lock.map((int v) => v + 1).unlock, [2, 3, 4]);
      expect(iList.map((int v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);
    });

    group("IList.reduce method |", () {
      test("Regular usage", () {
        expect(iList.reduce((int p, int e) => p * (1 + e)), 2520);
        expect([5].lock.reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          "State exception",
          () => expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    group("IList.singleWhere method |", () {
      test("Regular usage", () {
        expect(iList.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(iList.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          "State exception",
          () => expect(
              () => iList.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test("IList.skip method", () {
      expect(iList.skip(1).unlock, [2, 3, 4, 5, 6]);
      expect(iList.skip(3).unlock, [4, 5, 6]);
      expect(iList.skip(5).unlock, [6]);
      expect(iList.skip(10).unlock, []);
    });

    test("IList.skipWhile method", () {
      expect(iList.skipWhile((int v) => v < 3).unlock, [3, 4, 5, 6]);
      expect(iList.skipWhile((int v) => v < 5).unlock, [5, 6]);
      expect(iList.skipWhile((int v) => v < 6).unlock, [6]);
      expect(iList.skipWhile((int v) => v < 100).unlock, []);
    });

    test("IList.take method", () {
      expect(iList.take(0).unlock, []);
      expect(iList.take(1).unlock, [1]);
      expect(iList.take(3).unlock, [1, 2, 3]);
      expect(iList.take(5).unlock, [1, 2, 3, 4, 5]);
      expect(iList.take(10).unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("IList.takeWhile method", () {
      expect(iList.takeWhile((int v) => v < 3).unlock, [1, 2]);
      expect(iList.takeWhile((int v) => v < 5).unlock, [1, 2, 3, 4]);
      expect(iList.takeWhile((int v) => v < 6).unlock, [1, 2, 3, 4, 5]);
      expect(iList.takeWhile((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
    });

    group("IList.toList method |", () {
      test("Regular usage", () {
        expect(iList.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(iList.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test("Unsupported exception",
          () => expect(() => iList.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test("IList.toSet method", () {
      expect(iList.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(
          iList
            ..add(6)
            ..toSet(),
          {1, 2, 3, 4, 5, 6});
      expect(iList.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("IList.where method", () {
      expect(iList.where((int v) => v < 0).unlock, []);
      expect(iList.where((int v) => v < 3).unlock, [1, 2]);
      expect(iList.where((int v) => v < 5).unlock, [1, 2, 3, 4]);
      expect(iList.where((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
    });

    test("IList.whereType method",
        () => expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]));

    test("IList.iterator getter", () {
      final Iterator<int> iterator = iList.iterator;

      expect(iterator.current, isNull);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 1);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 2);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 3);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 4);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 5);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.current, 6);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.current, isNull);
    });
  });
}
