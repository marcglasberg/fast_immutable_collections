import 'dart:collection';

import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

int testCount = 0;

void testAndPrint(description, dynamic Function() body) {
  test(
    description,
    () {
      testCount++;
      print("\n\n$testCount. $description -----------\n\n");
      body();
    },
  );
}

void main() {
  print("THESE ARE THE EXAMPLES IN README.md");

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Creating IList", () {
    IList<int> ilist1 = IList([1, 2]);
    IList<int> ilist2 = [1, 2].lock;
    IList<int> ilist3 = {1, 2}.lockAsList;

    var list1 = List.of(ilist1);
    var list2 = ilist1.unlock;

    // All print [1, 2].
    print(ilist1);
    print(list1);
    print(ilist2);
    print(list2);
    print(ilist3);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Basic IList usage", () {
    var ilist1 = [1, 2].lock;
    var ilist2 = ilist1.add(3);
    var ilist3 = ilist2.remove(2);

    print(ilist1); // Prints 1, 2
    print(ilist2); // Prints 1, 2, 3
    print(ilist3); // Prints 1, 3
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Chain methods", () {
    var ilist = [1, 2].lock.add(3).remove(4);
    print(ilist); // Prints 1, 2
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Iterating", () {
    var ilist = [1, 2, 3, 4].lock;
    for (int value in ilist) print(value); // Prints 1, 2, 3, 4.
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("IList methods return IList", () {
    IList<int> ilist = ['Bob', 'Alice', 'Dominic', 'Carl']
        .lock
        .sort() // Alice, Bob, Carl, Dominic
        .map((name) => name.length) // 5, 3, 4, 7
        .take(3) // 5, 3, 4
        .sort() // 3, 4, 5
        .toggle(4) // 3, 5,
        .toggle(2); // 3, 5, 2;

    print(ilist.runtimeType); // Prints: IList<int>
    print(ilist); // Prints [3, 5, 2]
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("ILists can be used as map keys", () {
    Map<IList, int> sumResult = {};

    String getSum(int a, int b) {
      var keys = [a, b].lock;
      var sum = sumResult[keys];
      if (sum != null) {
        return "Got from cache: $a + $b = $sum";
      } else {
        sum = a + b;
        sumResult[keys] = sum;
        return "Newly calculated: $a + $b = $sum";
      }
    }

    print(getSum(5, 3));
    print(getSum(8, 9));
    print(getSum(5, 3));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Getters `withIdentityEquals` and `withDeepEquals`", () {
    var ilist = [1, 2].lock;

    // ILists by default use deep equals.
    var ilist1 = [1, 2].lock;

    // But you can change it to identity equals.
    var ilist2 = ilist.withIdentityEquals;

    // And also change back to deep equals.
    var ilist3 = ilist2.withDeepEquals;

    print(ilist == ilist1); // True!
    print(ilist == ilist2); // False!
    print(ilist == ilist3); // True!
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Method `withConfig`", () {
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Constructor `withConfig`", () {
    var list = [1, 2];
    var ilist1 = IList.withConfig(list, ConfigList(isDeepEquals: true));
    var ilist2 = IList.withConfig(list, ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Global IList configuration", () {
    var list = [1, 2];

    // The default.
    var ilistA1 = IList(list);
    var ilistA2 = IList(list);
    print(ilistA1 == ilistA2); // True!
    expect(ilistA1 == ilistA2, isTrue);

    // Change the default to identity equals, for lists created from now on.
    defaultConfigList = ConfigList(isDeepEquals: false);
    var ilistB1 = IList(list);
    var ilistB2 = IList(list);
    print(ilistB1 == ilistB2); // False!
    expect(ilistB1 == ilistB2, isFalse);

    // Already created lists are not changed.
    print(ilistA1 == ilistA2); // True!
    expect(ilistA1 == ilistA2, isTrue);

    // Change the default back to deep equals.
    defaultConfigList = ConfigList(isDeepEquals: true);
    var ilistC1 = IList(list);
    var ilistC2 = IList(list);
    print(ilistC1 == ilistC2); // True!
    expect(ilistC1 == ilistC2, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  testAndPrint("Usage in tests", () {
    // ignore: unrelated_type_equality_checks
    expect([1, 2] == [1, 2].lock, isFalse);

    expect([1, 2], [1, 2]); // List with List, same order.
    expect([1, 2].lock, [1, 2]); // IList with List, same order.
    expect([1, 2], [1, 2].lock); // List with IList, same order.
    expect([1, 2].lock, [1, 2].lock); // IList with IList, same order.

    expect([2, 1], isNot([1, 2])); // List with List, wrong order.
    expect([2, 1].lock, isNot([1, 2])); // IList with List, wrong order.
    expect([2, 1], isNot([1, 2].lock)); // List with IList, wrong order.
    expect([2, 1].lock, isNot([1, 2].lock)); // IList with IList, wrong order.

    expect([1, 2], {1, 2}); // List with ordered Set in the correct order.
    expect([1, 2].lock, {1, 2}); // IList with ordered Set in the correct order.
    expect({1, 2}, [1, 2]); // Ordered Set in the correct order with List.
    expect({1, 2}, [1, 2].lock); // Ordered Set in the correct order with IList.

    expect([1, 2], {2, 1}); // List with ordered Set in the WRONG order.
    expect({2, 1}, isNot([1, 2])); // Ordered Set in the WRONG order with List.

    expect([1, 2].lock, {2, 1}); // IList with ordered Set in the WRONG order.
    expect({2, 1}, isNot([1, 2].lock)); // Ordered Set in the WRONG order with IList.

    expect({1, 2}, isNot([2, 1])); // Ordered Set in the WRONG order with List.
    expect([2, 1], {1, 2}); // List with ordered Set in the WRONG order.

    expect({1, 2}, isNot([2, 1].lock)); // Ordered Set in the WRONG order with IList.
    expect([2, 1].lock, {1, 2}); // IList with ordered Set in the WRONG order.
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
