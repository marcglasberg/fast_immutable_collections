import 'package:test/test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Creating IList", () {
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

  test("Basic IList usage", () {
    var ilist1 = [1, 2].lock;
    var ilist2 = ilist1.add(3);
    var ilist3 = ilist2.remove(2);

    print(ilist1); // Prints 1, 2
    print(ilist2); // Prints 1, 2, 3
    print(ilist3); // Prints 1, 3
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Chain methods", () {
    var ilist = [1, 2].lock.add(3).remove(4);

    print(ilist); // Prints 1, 2
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Iterating", () {
    var ilist = [1, 2, 3, 4].lock;
    for (int value in ilist) print(value); // Prints 1, 2, 3, 4.
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList methods return IList", () {
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

  test("ILists can be used as map keys", () {
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

  test("IList equality", () {
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

  test("withConfig method", () {
    var list = [1, 2];
    var ilist1 = list.lock.withConfig(ConfigList(isDeepEquals: true));
    var ilist2 = list.lock.withConfig(ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList equality configuration", () {
    var list = [1, 2];
    var ilist1 = IList.withConfig(list, ConfigList(isDeepEquals: true));
    var ilist2 = IList.withConfig(list, ConfigList(isDeepEquals: false));

    print(list.lock == ilist1); // True!
    print(list.lock == ilist2); // False!
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////
}
