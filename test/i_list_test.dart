import 'package:test/test.dart'
    show
        expect,
        group,
        isA,
        isFalse,
        isTrue,
        test,
        throwsArgumentError,
        throwsRangeError,
        throwsStateError,
        throwsUnsupportedError;

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show IList, IListExtension;

void main() {
  group('Creating immutable lists |', () {
    final IList iList1 = IList(), iList2 = IList([]);
    final iList3 = IList<String>([]);
    final iList4 = IList([1]);

    test('Runtime Type', () {
      expect(iList1, isA<IList>());
      expect(iList2, isA<IList>());
      expect(iList3, isA<IList<String>>());
      expect(iList4, isA<IList<int>>());
    });

    test('Emptiness Properties', () {
      expect(iList1.isEmpty, isTrue);
      expect(iList2.isEmpty, isTrue);
      expect(iList3.isEmpty, isTrue);
      expect(iList4.isEmpty, isFalse);

      expect(iList1.isNotEmpty, isFalse);
      expect(iList2.isNotEmpty, isFalse);
      expect(iList3.isNotEmpty, isFalse);
      expect(iList4.isNotEmpty, isTrue);
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

  group('Creating native mutable lists from immutable lists', () {
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
    final IList<int> ilist =
        [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);

    expect(ilist.isFlushed, isFalse);

    ilist.flush;

    expect(ilist.isFlushed, isTrue);
    expect(ilist.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('`add` and `addAll`', () {
    final IList<int> ilist1 = [1, 2, 3].lock;
    final IList<int> ilist2 = ilist1.add(4);
    final IList<int> ilist3 = ilist2.addAll([5, 6]);

    expect(ilist1.unlock, [1, 2, 3]);
    expect(ilist2.unlock, [1, 2, 3, 4]);
    expect(ilist3.unlock, [1, 2, 3, 4, 5, 6]);

    // Methods are chainable.
    expect(ilist1.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]);
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

  group('`maxLength`', () {
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

    test('Invalid argument',
        () => expect(() => ilist1.maxLength(-1), throwsArgumentError));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Test IList methods that belong to Iterable.', () {
    var list = [1, 2, 3].lock.add(4).addAll([5, 6]);

    // any
    expect(list.any((v) => v == 4), isTrue);
    expect(list.any((v) => v == 100), isFalse);

    // cast
    // expect(list.cast<num>().runtimeType, "<CastList<dynamic, num>>");

    // contains
    expect(list.contains(2), isTrue);
    expect(list.contains(4), isTrue);
    expect(list.contains(5), isTrue);
    expect(list.contains(100), isFalse);

    // elementAt
    expect(list.elementAt(0), 1);
    expect(list.elementAt(1), 2);
    expect(list.elementAt(2), 3);
    expect(list.elementAt(3), 4);
    expect(list.elementAt(4), 5);
    expect(list.elementAt(5), 6);
    expect(() => list.elementAt(6), throwsRangeError);
    expect(() => list.elementAt(-1), throwsRangeError);

    // every
    expect(list.every((v) => v > 0), isTrue);
    expect(list.every((v) => v < 0), isFalse);
    expect(list.every((v) => v != 4), isFalse);

    // every
    expect(list.expand((v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect(list.expand((v) => []), []);

    // length
    expect(list.length, 6);

    // first
    expect(list.first, 1);

    // last
    expect(list.last, 6);

    // single
    expect(() => list.single, throwsStateError);
    expect([10].lock.single, 10);

    // firstWhere
    expect(list.firstWhere((v) => v > 1, orElse: () => 100), 2);
    expect(list.firstWhere((v) => v > 4, orElse: () => 100), 5);
    expect(list.firstWhere((v) => v > 5, orElse: () => 100), 6);
    expect(list.firstWhere((v) => v > 6, orElse: () => 100), 100);

    // fold
    expect(list.fold(100, (p, e) => p * (1 + e)), 504000);

    // followedBy
    expect(list.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(list.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock,
        [1, 2, 3, 4, 5, 6, 7, 8, 9]);

    // forEach
    var result = 100;
    list.forEach((v) => result *= 1 + v);
    expect(result, 504000);

    // join
    expect(list.join(','), '1,2,3,4,5,6');
    expect([].lock.join(','), '');

    // lastWhere
    expect(list.lastWhere((v) => v < 2, orElse: () => 100), 1);
    expect(list.lastWhere((v) => v < 5, orElse: () => 100), 4);
    expect(list.lastWhere((v) => v < 6, orElse: () => 100), 5);
    expect(list.lastWhere((v) => v < 7, orElse: () => 100), 6);
    expect(list.lastWhere((v) => v < 50, orElse: () => 100), 6);
    expect(list.lastWhere((v) => v < 1, orElse: () => 100), 100);

    // map
    expect([1, 2, 3].lock.map((v) => v + 1).unlock, [2, 3, 4]);
    expect(list.map((v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);

    // reduce
    expect(list.reduce((p, e) => p * (1 + e)), 2520);
    expect([5].lock.reduce((p, e) => p * (1 + e)), 5);
    expect(() => [].reduce((p, e) => p * (1 + e)), throwsStateError);

    // singleWhere
    expect(list.singleWhere((v) => v == 4, orElse: () => 100), 4);
    expect(list.singleWhere((v) => v == 50, orElse: () => 100), 100);
    expect(() => list.singleWhere((v) => v < 4, orElse: () => 100),
        throwsStateError);

    // skip
    expect(list.skip(1).unlock, [2, 3, 4, 5, 6]);
    expect(list.skip(3).unlock, [4, 5, 6]);
    expect(list.skip(5).unlock, [6]);
    expect(list.skip(10).unlock, []);

    // skipWhile
    expect(list.skipWhile((v) => v < 3).unlock, [3, 4, 5, 6]);
    expect(list.skipWhile((v) => v < 5).unlock, [5, 6]);
    expect(list.skipWhile((v) => v < 6).unlock, [6]);
    expect(list.skipWhile((v) => v < 100).unlock, []);

    // take
    expect(list.take(0).unlock, []);
    expect(list.take(1).unlock, [1]);
    expect(list.take(3).unlock, [1, 2, 3]);
    expect(list.take(5).unlock, [1, 2, 3, 4, 5]);
    expect(list.take(10).unlock, [1, 2, 3, 4, 5, 6]);

    // takeWhile
    expect(list.takeWhile((v) => v < 3).unlock, [1, 2]);
    expect(list.takeWhile((v) => v < 5).unlock, [1, 2, 3, 4]);
    expect(list.takeWhile((v) => v < 6).unlock, [1, 2, 3, 4, 5]);
    expect(list.takeWhile((v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);

    // toList
    expect(list.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect(list.unlock, [1, 2, 3, 4, 5, 6]);
    expect(() => list.toList(growable: false)..add(7), throwsUnsupportedError);

    // toSet
    expect(list.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(list.unlock, [1, 2, 3, 4, 5, 6]);

    // where
    expect(list.where((v) => v < 0).unlock, []);
    expect(list.where((v) => v < 3).unlock, [1, 2]);
    expect(list.where((v) => v < 5).unlock, [1, 2, 3, 4]);
    expect(list.where((v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);

    // whereType
    expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
