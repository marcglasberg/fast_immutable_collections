import 'package:test/test.dart';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Creating immutable lists |', () {
    final IList iList1 = IList(), iList2 = IList([]);
    final iList3 = IList<String>([]);
    final iList4 = IList([1]);
    final iList5 = IList.empty<int>();
    final iList6 = [].lock;

    test('Runtime Type', () {
      expect(iList1, isA<IList>());
      expect(iList2, isA<IList>());
      expect(iList3, isA<IList<String>>());
      expect(iList4, isA<IList<int>>());
      expect(iList5, isA<IList<int>>());
      expect(iList6, isA<IList>());
    });

    test('Emptiness Properties', () {
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

  group('Ensuring Immutability |', () {
    group('`add` |', () {
      test('Changing the passed mutable list doesn\'t change the `IList`', () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, original);

        original.add(3);
        original.add(4);

        expect(original, <int>[1, 2, 3, 4]);
        expect(iList.unlock, <int>[1, 2]);
      });

      test('Changing the `IList` also doesn\'t change the original list', () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, original);

        final IList<int> iListNew = iList.add(3);

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(iListNew, <int>[1, 2, 3]);
      });

      test('If the item being passed is a variable, a pointer to it shouldn\'t exist inside `IList`',
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

    group('`addAll` |', () {
      test('Changing the passed mutable list doesn\'t change the `IList`', () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, <int>[1, 2]);

        original.addAll(<int>[3, 4]);

        expect(original, <int>[1, 2, 3, 4]);
        expect(iList, <int>[1, 2]);
      });

      test('Changing the passed mutable list doesn\'t change the `IList`', () {
        final List<int> original = [1, 2];
        final IList<int> iList = original.lock;

        expect(iList, <int>[1, 2]);

        final IList<int> iListNew = iList.addAll(<int>[3, 4]);

        expect(original, <int>[1, 2]);
        expect(iList, <int>[1, 2]);
        expect(iListNew, <int>[1, 2, 3, 4]);
      });

      test('If the items being passed are from a variable, '
          'it shouldn\'t have a pointer to the variable', () {
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

    group('`remove` |', () {
      test('Changing the passed mutable list doesn\'t change the `IList`', () {
        
      final List<int> original = [1, 2];
      final IList<int> iList = original.lock;

      expect(iList, [1, 2]);

      original.remove(2);

      expect(original, <int>[1]);
      expect(iList, <int>[1, 2]);
      });

      test('Removing from the original `IList` doesn\'t change it', () {
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

  group('Equals |', () {
    test(
        'IList with identity-equals compares the list instance, '
        'not the items.', () {
      var myList = IList([1, 2]);
      expect(myList == myList, isTrue);
      expect(myList == IList([1, 2]), isFalse);
      expect(myList == [1, 2].lock, isFalse);
      expect(myList == IList([1, 2, 3]), isFalse);

      myList = IList([1, 2]).identityEquals;
      expect(myList == myList, isTrue);
      expect(myList == IList([1, 2]).identityEquals, isFalse);
      expect(myList == IList([1, 2, 3]).identityEquals, isFalse);
    });

    test(
        'IList with deep-equals compares the items, '
        'not the list instance.', () {
      var myList = IList([1, 2]).deepEquals;
      expect(myList == myList, isTrue);
      expect(myList == IList([1, 2]).deepEquals, isTrue);
      expect(myList == [1, 2].deep, isTrue);
      expect(myList == IList([1, 2, 3]).deepEquals, isFalse);
    });

    test(
        'IList with deep-equals is always different '
        'from iList with identity-equals.', () {
      expect(IList([1, 2]).deepEquals == IList([1, 2]).identityEquals, isFalse);
      expect(IList([1, 2]).identityEquals == IList([1, 2]).deepEquals, isFalse);
      expect(IList([1, 2]).deepEquals == IList([1, 2]), isFalse);
      expect(IList([1, 2]) == IList([1, 2]).deepEquals, isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Creating immutable lists with extensions |', () {
    test('From an empty list', () {
      final IList iList = [].lock;

      expect(iList, isA<IList>());
      expect(iList.isEmpty, isTrue);
      expect(iList.isNotEmpty, isFalse);
    });

    test('From a list with one `int` item', () {
      final IList iList = [1].lock;

      expect(iList, isA<IList<int>>());
      expect(iList.isEmpty, isFalse);
      expect(iList.isNotEmpty, isTrue);
    });

    test('From a list with one `null` string', () {
      final String text = null;
      final IList<String> typedList = [text].lock;

      expect(typedList, isA<IList<String>>());
    });

    test('From an empty list typed with `String`', () {
      final typedList = <String>[].lock;

      expect(typedList, isA<IList<String>>());
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Creating native mutable lists from immutable lists |', () {
    final List<int> list = [1, 2, 3];

    test('From the default factory constructor', () {
      final IList<int> ilist = IList(list);

      expect(ilist.unlock, list);
      expect(identical(ilist.unlock, list), isFalse);
    });

    test('From `lock`', () {
      final IList<int> iList = list.lock;

      expect(iList.unlock, list);
      expect(identical(iList.unlock, list), isFalse);
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('`flush`', () {
    final IList<int> ilist = [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);

    expect(ilist.isFlushed, isFalse);

    ilist.flush;

    expect(ilist.isFlushed, isTrue);
    expect(ilist.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('Adding |', () {
    final IList<int> ilist1 = [1, 2, 3].lock;
    final IList<int> ilist2 = ilist1.add(4);
    final IList<int> ilist3 = ilist2.addAll([5, 6]);

    test('`add`', () {
      expect(ilist1.unlock, [1, 2, 3]);
      expect(ilist2.unlock, [1, 2, 3, 4]);
    });

    test('`addAll`', () {
      expect(ilist1.unlock, [1, 2, 3]);
      expect(ilist3.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test('`add` and `addAll` at the same time',
        () => expect(ilist1.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('`remove`', () {
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

  group('`maxLength` |', () {
    final IList<int> ilist1 = [1, 2, 3, 4, 5].lock;

    test('Cutting the list off', () {
      final IList<int> ilist2 = ilist1.maxLength(2);
      expect(ilist2.unlock, [1, 2]);

      final IList<int> ilist3 = ilist1.maxLength(3);
      expect(ilist3.unlock, [1, 2, 3]);

      final IList<int> ilist4 = ilist1.maxLength(1);
      expect(ilist4.unlock, [1]);

      final IList<int> ilist5 = ilist1.maxLength(0);
      expect(ilist5.unlock, []);
    });

    test('Invalid argument', () => expect(() => ilist1.maxLength(-1), throwsArgumentError));
  });

  group('`toggle`', () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    test('Toggling an existing element', () {
      expect(iList.contains(4), isTrue);

      iList = iList.toggle(4);

      expect(iList.contains(4), isFalse);

      iList = iList.toggle(4);

      expect(iList.contains(4), isTrue);
    });

    test('Toggling an inexistent element', () {
      expect(iList.contains(6), isFalse);

      iList = iList.toggle(6);

      expect(iList.contains(6), isTrue);

      iList = iList.toggle(6);

      expect(iList.contains(6), isFalse);
    });
  });

  group('Index Access |', () {
    final IList<int> iList = [1, 2, 3, 4, 5].lock;

    test('`iList[index]`', () {
      expect(iList[0], 1);
      expect(iList[1], 2);
      expect(iList[2], 3);
      expect(iList[3], 4);
      expect(iList[4], 5);
    });

    test('Range Errors', () {
      expect(() => iList[5], throwsA(isA<RangeError>()));
      expect(() => iList[-1], throwsA(isA<RangeError>()));
    });
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  group('`IList` methods from `Iterable` |', () {
    final IList<int> iList = [1, 2, 3].lock.add(4).addAll([5, 6]);

    test('`any`', () {
      expect(iList.any((int v) => v == 4), isTrue);
      expect(iList.any((int v) => v == 100), isFalse);
    });

    test('`cast`', () => expect(iList.cast<num>(), isA<IList<num>>()));

    test('`contains`', () {
      expect(iList.contains(2), isTrue);
      expect(iList.contains(4), isTrue);
      expect(iList.contains(5), isTrue);
      expect(iList.contains(100), isFalse);
    });

    group('`elementAt` |', () {
      test('Regular element access', () {
        expect(iList.elementAt(0), 1);
        expect(iList.elementAt(1), 2);
        expect(iList.elementAt(2), 3);
        expect(iList.elementAt(3), 4);
        expect(iList.elementAt(4), 5);
        expect(iList.elementAt(5), 6);
      });

      test('Range exceptions', () {
        expect(() => iList.elementAt(6), throwsRangeError);
        expect(() => iList.elementAt(-1), throwsRangeError);
      });
    });

    test('`every`', () {
      expect(iList.every((int v) => v > 0), isTrue);
      expect(iList.every((int v) => v < 0), isFalse);
      expect(iList.every((int v) => v != 4), isFalse);
    });

    test('`expand`', () {
      expect(iList.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
      expect(iList.expand((int v) => []), []);
    });

    test('`length`', () => expect(iList.length, 6));

    test('`first`', () => expect(iList.first, 1));

    test('`last`', () => expect(iList.last, 6));

    group('`single` |', () {
      test('State exception', () => expect(() => iList.single, throwsStateError));

      test('Access', () => expect([10].lock.single, 10));
    });

    test('`firstWhere`', () {
      expect(iList.firstWhere((int v) => v > 1, orElse: () => 100), 2);
      expect(iList.firstWhere((int v) => v > 4, orElse: () => 100), 5);
      expect(iList.firstWhere((int v) => v > 5, orElse: () => 100), 6);
      expect(iList.firstWhere((int v) => v > 6, orElse: () => 100), 100);
    });

    test('`fold`', () => expect(iList.fold(100, (int p, int e) => p * (1 + e)), 504000));

    test('`followedBy`', () {
      expect(iList.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(
          iList.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('`forEach`', () {
      int result = 100;
      iList.forEach((int v) => result *= 1 + v);
      expect(result, 504000);
    });

    test('`join`', () {
      expect(iList.join(','), '1,2,3,4,5,6');
      expect([].lock.join(','), '');
    });

    test('`lastWhere`', () {
      expect(iList.lastWhere((int v) => v < 2, orElse: () => 100), 1);
      expect(iList.lastWhere((int v) => v < 5, orElse: () => 100), 4);
      expect(iList.lastWhere((int v) => v < 6, orElse: () => 100), 5);
      expect(iList.lastWhere((int v) => v < 7, orElse: () => 100), 6);
      expect(iList.lastWhere((int v) => v < 50, orElse: () => 100), 6);
      expect(iList.lastWhere((int v) => v < 1, orElse: () => 100), 100);
    });

    test('`map`', () {
      expect([1, 2, 3].lock.map((int v) => v + 1).unlock, [2, 3, 4]);
      expect(iList.map((int v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);
    });

    group('`reduce` |', () {
      test('Regular usage', () {
        expect(iList.reduce((int p, int e) => p * (1 + e)), 2520);
        expect([5].lock.reduce((int p, int e) => p * (1 + e)), 5);
      });

      test(
          'State exception',
          () => expect(() => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))),
              throwsStateError));
    });

    group('`singleWhere` |', () {
      test('Regular usage', () {
        expect(iList.singleWhere((int v) => v == 4, orElse: () => 100), 4);
        expect(iList.singleWhere((int v) => v == 50, orElse: () => 100), 100);
      });

      test(
          'State exception',
          () => expect(
              () => iList.singleWhere((int v) => v < 4, orElse: () => 100), throwsStateError));
    });

    test('`skip`', () {
      expect(iList.skip(1).unlock, [2, 3, 4, 5, 6]);
      expect(iList.skip(3).unlock, [4, 5, 6]);
      expect(iList.skip(5).unlock, [6]);
      expect(iList.skip(10).unlock, []);
    });

    test('`skipWhile`', () {
      expect(iList.skipWhile((int v) => v < 3).unlock, [3, 4, 5, 6]);
      expect(iList.skipWhile((int v) => v < 5).unlock, [5, 6]);
      expect(iList.skipWhile((int v) => v < 6).unlock, [6]);
      expect(iList.skipWhile((int v) => v < 100).unlock, []);
    });

    test('`take`', () {
      expect(iList.take(0).unlock, []);
      expect(iList.take(1).unlock, [1]);
      expect(iList.take(3).unlock, [1, 2, 3]);
      expect(iList.take(5).unlock, [1, 2, 3, 4, 5]);
      expect(iList.take(10).unlock, [1, 2, 3, 4, 5, 6]);
    });

    test('`takeWhile`', () {
      expect(iList.takeWhile((int v) => v < 3).unlock, [1, 2]);
      expect(iList.takeWhile((int v) => v < 5).unlock, [1, 2, 3, 4]);
      expect(iList.takeWhile((int v) => v < 6).unlock, [1, 2, 3, 4, 5]);
      expect(iList.takeWhile((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
    });

    group('`toList` |', () {
      test('Regular usage', () {
        expect(iList.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
        expect(iList.unlock, [1, 2, 3, 4, 5, 6]);
      });

      test('Unsupported exception',
          () => expect(() => iList.toList(growable: false)..add(7), throwsUnsupportedError));
    });

    test('`toSet`', () {
      expect(iList.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
      expect(
          iList
            ..add(6)
            ..toSet(),
          {1, 2, 3, 4, 5, 6});
      expect(iList.unlock, [1, 2, 3, 4, 5, 6]);
    });

    test('`where`', () {
      expect(iList.where((int v) => v < 0).unlock, []);
      expect(iList.where((int v) => v < 3).unlock, [1, 2]);
      expect(iList.where((int v) => v < 5).unlock, [1, 2, 3, 4]);
      expect(iList.where((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
    });

    test('`whereType`', () => expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]));
  });
}
