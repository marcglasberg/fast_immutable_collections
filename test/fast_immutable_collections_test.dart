import 'package:flutter_test/flutter_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Create immutable list.', () {
    var list1 = IList();
    expect(list1.runtimeType, IList);
    expect(list1.isEmpty, isTrue);
    expect(list1.isNotEmpty, isFalse);

    var list2 = IList([]);
    expect(list2.runtimeType, IList);
    expect(list2.isEmpty, isTrue);
    expect(list2.isNotEmpty, isFalse);

    var list3 = IList<String>([]);
    expect(list3.runtimeType.toString(), "IList<String>");

    var list4 = IList([1]);
    expect(list4.runtimeType.toString(), "IList<int>");
    expect(list4.isEmpty, isFalse);
    expect(list4.isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Create immutable list with extensions.', () {
    var list1 = [].lock;
    expect(list1.runtimeType, IList);
    expect(list1.isEmpty, isTrue);
    expect(list1.isNotEmpty, isFalse);

    var list2 = [1].lock;
    expect(list2.runtimeType.toString(), "IList<int>");
    expect(list2.isEmpty, isFalse);
    expect(list2.isNotEmpty, isTrue);

    String text;
    IList<String> typedList1 = [text].lock;
    expect(typedList1.runtimeType.toString(), "IList<String>");

    var typedList2 = <String>[].lock;
    expect(typedList2.runtimeType.toString(), "IList<String>");
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('Create native mutable list from immutable list.', () {
    var list = [1, 2, 3];

    var ilist1 = IList(list);
    expect(ilist1.unlock, list);
    expect(identical(ilist1.unlock, list), isFalse);

    var ilist2 = list.lock;
    expect(ilist2.unlock, list);
    expect(identical(ilist2.unlock, list), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('IList.flush', () {
    var ilist = [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);

    expect(ilist.isFlushed, isFalse);
    ilist.flush();
    expect(ilist.isFlushed, isTrue);
    expect(ilist.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test('IList.add e addAll', () {
    var ilist1 = [1, 2, 3].lock;
    var ilist2 = ilist1.add(4);
    var ilist3 = ilist2.addAll([5, 6]);
    expect(ilist1.unlock, [1, 2, 3]);
    expect(ilist2.unlock, [1, 2, 3, 4]);
    expect(ilist3.unlock, [1, 2, 3, 4, 5, 6]);

    // Methods are chainable.
    expect(ilist1.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]);
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
    expect(list.followedBy([].lock.add(7).addAll([8, 9])).unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);

    // forEach
    var result = 100;
    list.forEach((v) => result *= 1 + v);
    expect(result, 504000);

    // join
    expect(list.join(','), "1,2,3,4,5,6");
    expect([].lock.join(','), "");

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
    expect(() => list.singleWhere((v) => v < 4, orElse: () => 100), throwsStateError);

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
