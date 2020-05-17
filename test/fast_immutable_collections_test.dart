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

  test('IList.add', () {
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
}
