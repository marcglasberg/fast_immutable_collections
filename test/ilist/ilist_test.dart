import "dart:collection";
import "dart:math";

import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Runtime Type", () {
    expect(IList(), isA<IList>());
    expect(IList([]), isA<IList>());
    expect(IList<String>([]), isA<IList<String>>());
    expect(IList([1]), isA<IList<int>>());
    expect(IList.empty<int>(), isA<IList<int>>());
    expect([].lock, isA<IList>());
  });

  test("isEmpty | isNotEmpty", () {
    expect(IList().isEmpty, isTrue);
    expect(IList().isNotEmpty, isFalse);

    expect(IList([]).isEmpty, isTrue);
    expect(IList([]).isNotEmpty, isFalse);

    expect(IList<String>([]).isEmpty, isTrue);
    expect(IList<String>([]).isNotEmpty, isFalse);

    expect(IList([1]).isEmpty, isFalse);
    expect(IList([1]).isNotEmpty, isTrue);

    expect(IList.empty<int>().isEmpty, isTrue);
    expect(IList.empty<int>().isNotEmpty, isFalse);

    expect([].lock.isEmpty, isTrue);
    expect([].lock.isNotEmpty, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test(
      "Ensuring Immutability | IList.add method | "
      "Changing the passed mutable list doesn't change the IList", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, original);

    original.add(3);
    original.add(4);

    expect(original, <int>[1, 2, 3, 4]);
    expect(iList.unlock, <int>[1, 2]);
  });

  test(
      "Ensuring Immutability | IList.add method | "
      "Changing the IList also doesn't change the original list", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, original);

    final IList<int> iListNew = iList.add(3);

    expect(original, <int>[1, 2]);
    expect(iList, <int>[1, 2]);
    expect(iListNew, <int>[1, 2, 3]);
  });

  test(
      "Ensuring Immutability | IList.add method | "
      "If the item being passed is a variable, a pointer to it shouldn't exist inside IList", () {
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

  test(
      "Ensuring Immutability | IList.addAll method | "
      "Changing the passed mutable list doesn't change the IList", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, <int>[1, 2]);

    original.addAll(<int>[3, 4]);

    expect(original, <int>[1, 2, 3, 4]);
    expect(iList, <int>[1, 2]);
  });

  test(
      "Ensuring Immutability | IList.addAll method | "
      "Changing the passed immutable list doesn't change the IList", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, <int>[1, 2]);

    final IList<int> iListNew = iList.addAll(<int>[3, 4]);

    expect(original, <int>[1, 2]);
    expect(iList, <int>[1, 2]);
    expect(iListNew, <int>[1, 2, 3, 4]);
  });

  test(
      "Ensuring Immutability | IList.addAll method | "
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

  test(
      "Ensuring Immutability | IList.remove method | "
      "Changing the passed mutable list doesn't change the IList", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, [1, 2]);

    original.remove(2);

    expect(original, <int>[1]);
    expect(iList, <int>[1, 2]);
  });

  test(
      "Ensuring Immutability | IList.remove method | "
      "Removing from the original IList doesn't change it", () {
    final List<int> original = [1, 2];
    final IList<int> iList = original.lock;

    expect(iList, <int>[1, 2]);

    final IList<int> iListNew = iList.remove(1);

    expect(original, <int>[1, 2]);
    expect(iList, <int>[1, 2]);
    expect(iListNew, <int>[2]);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "IList with identity-equals compares the list instance, not the items", () {
    final IList<int> myList1 = IList([1, 2]).withIdentityEquals;
    expect(myList1 == myList1, isTrue);
    expect(IList([1, 2]).withIdentityEquals == IList([1, 2]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals == IList([2, 1]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals == [1, 2].lock, isFalse);
    expect(IList([1, 2]).withIdentityEquals == IList([1, 2, 3]).withIdentityEquals, isFalse);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "IList with deep-equals compares the items, not necessarily the list instance", () {
    final IList<int> myList = IList([1, 2]);
    expect(myList == myList, isTrue);
    expect(IList([1, 2]) == IList([1, 2]), isTrue);
    expect(IList([1, 2]) == IList([2, 1]), isFalse);
    expect(IList([1, 2]) == [1, 2].lock.withDeepEquals, isTrue);
    expect(IList([1, 2]) == IList([1, 2, 3]), isFalse);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "IList with deep-equals is always different from iList with identity-equals", () {
    expect(IList([1, 2]).withDeepEquals == IList([1, 2]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals == IList([1, 2]).withDeepEquals, isFalse);
    expect(IList([1, 2]).withDeepEquals == IList([1, 2]), isTrue);
    expect(IList([1, 2]) == IList([1, 2]).withDeepEquals, isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "IList.isIdentityEquals and IList.isDeepEquals properties", () {
    expect(IList([1, 2]).isIdentityEquals, isFalse);
    expect(IList([1, 2]).isDeepEquals, isTrue);
    expect(IList([1, 2]).withIdentityEquals.isIdentityEquals, isTrue);
    expect(IList([1, 2]).withIdentityEquals.isDeepEquals, isFalse);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | Same, Equals and the == Operator | "
      "IList.same method", () {
    final IList<int> iList1 = IList([1, 2]);
    expect(iList1.same(iList1), isTrue);
    expect(iList1.same(IList([1, 2])), isFalse);
    expect(iList1.same(IList([1])), isFalse);
    expect(iList1.same(IList(([2, 1]))), isFalse);
    expect(iList1.same(IList([1, 2]).withIdentityEquals), isFalse);
    expect(iList1.same(iList1.remove(3)), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | Same, Equals and the == Operator | "
      "IList.equalItemsAndConfig method", () {
    final IList<int> iList1 = IList([1, 2]);
    expect(iList1.equalItemsAndConfig(iList1), isTrue);
    expect(iList1.equalItemsAndConfig(IList([1, 2])), isTrue);
    expect(iList1.equalItemsAndConfig(IList([1])), isFalse);
    expect(iList1.equalItemsAndConfig(IList(([2, 1]))), isFalse);
    expect(iList1.equalItemsAndConfig(IList([1, 2]).withIdentityEquals), isFalse);
    expect(iList1.equalItemsAndConfig(iList1.remove(3)), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | Same, Equals and the == Operator | "
      "IList.== operator", () {
    final IList<int> iList1 = IList([1, 2]);
    expect(iList1 == iList1, isTrue);
    expect(iList1 == IList([1, 2]), isTrue);
    expect(iList1 == IList([1]), isFalse);
    expect(iList1 == IList(([2, 1])), isFalse);
    expect(iList1 == IList([1, 2]).withIdentityEquals, isFalse);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "Identity", () {
    final IList<int> iList1 = IList([1, 2]);
    expect(iList1.equalItems(iList1), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "Passing a set", () {
    expect(() => IList([1, 2]).equalItems(ISet([1, 2])), throwsStateError);
    expect(() => IList([1, 2]).equalItems(HashSet()..add(1)..add(2)), throwsStateError);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "If IList, will only be equal if in order and the same items", () {
    expect(IList([1, 2]).equalItems(IList([1])), isFalse);
    expect(IList([1, 2]).equalItems(IList([2, 1])), isFalse);
    expect(IList([1, 2]).equalItems(IList([1, 2])), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "If List, will only be equal if in order and the same items", () {
    expect(IList([1, 2]).equalItems(IList([1]).toList()), isFalse);
    expect(IList([1, 2]).equalItems(IList([2, 1]).toList()), isFalse);
    expect(IList([1, 2]).equalItems(IList([1, 2]).toList()), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "If Iterable, will only be equal if in order and the same items", () {
    expect(IList([1, 2]).equalItems({"a": 1}.values), isFalse);
    expect(IList([1, 2]).equalItems({"a": 2, "b": 1}.values), isFalse);
    expect(IList([1, 2]).equalItems({"a": 1, "b": 2}.values), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.unorderedEqualItems method | "
      "Identity", () {
    final IList<int> iList1 = IList([1, 2]);
    expect(iList1.unorderedEqualItems(iList1), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.unorderedEqualItems method | "
      "If Iterable, then compares each item with no specific order", () {
    expect(IList([1, 2]).unorderedEqualItems(IList([1])), isFalse);
    expect(IList([1, 2]).unorderedEqualItems(IList([2, 1])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems(IList([1, 2])), isTrue);
    expect(IList([1, 2]).unorderedEqualItems({1}), isFalse);
    expect(IList([1, 2]).unorderedEqualItems({1, 2}), isTrue);
  });

  test("IList.hashCode method | " "deepEquals vs deepEquals", () {
    expect(IList([1, 2]) == IList([1, 2]), isTrue);
    expect(IList([1, 2]) == IList([1, 2, 3]), isFalse);
    expect(IList([1, 2]) == IList([2, 1]), isFalse);
    expect(IList([1, 2]).hashCode, IList([1, 2]).hashCode);
    expect(IList([1, 2]).hashCode, isNot(IList([1, 2, 3]).hashCode));
    expect(IList([1, 2]).hashCode, isNot(IList([2, 1]).hashCode));
  });

  test("IList.hashCode method | " "identityEquals vs identityEquals", () {
    expect(IList([1, 2]).withIdentityEquals == IList([1, 2]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals == IList([1, 2, 3]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals == IList([2, 1]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).withIdentityEquals.hashCode,
        isNot(IList([1, 2]).withIdentityEquals.hashCode));
    expect(IList([1, 2]).withIdentityEquals.hashCode,
        isNot(IList([1, 2, 3]).withIdentityEquals.hashCode));
    expect(IList([1, 2]).withIdentityEquals.hashCode,
        isNot(IList([2, 1]).withIdentityEquals.hashCode));
  });

  test("IList.hashCode method | " "deepEquals vs identityEquals", () {
    expect(IList([1, 2]) == IList([1, 2]).withIdentityEquals, isFalse);
    expect(IList([1, 2]) == IList([1, 2]).withIdentityEquals, isFalse);
    expect(IList([1, 2, 3]) == IList([1, 2, 3]).withIdentityEquals, isFalse);
    expect(IList([2, 1]) == IList([2, 1]).withIdentityEquals, isFalse);
    expect(IList([1, 2]).hashCode, isNot(IList([1, 2]).withIdentityEquals.hashCode));
    expect(IList([1, 2]).hashCode, isNot(IList([1, 2]).withIdentityEquals.hashCode));
    expect(IList([1, 2, 3]).hashCode, isNot(IList([1, 2, 3]).withIdentityEquals.hashCode));
    expect(IList([2, 1]).hashCode, isNot(IList([2, 1]).withIdentityEquals.hashCode));
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

  test("IList.withConfigFrom method", () {
    final IList<int> iList = IList([1, 2]);

    expect(iList.isDeepEquals, isTrue);

    final IList<int> iListWithNoDeepEquals = iList.withConfig(ConfigList(isDeepEquals: false));

    expect(iListWithNoDeepEquals.isDeepEquals, isFalse);

    final IList<int> iListWithConfig = iList.withConfigFrom(iListWithNoDeepEquals);

    expect(iListWithConfig.isDeepEquals, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Creating immutable lists with extensions |" "From an empty list", () {
    expect([].lock, isA<IList>());
    expect([].lock.isEmpty, isTrue);
    expect([].lock.isNotEmpty, isFalse);
  });

  test("Creating immutable lists with extensions |" "From a list with one int item", () {
    expect([1].lock, isA<IList<int>>());
    expect([1].lock.isEmpty, isFalse);
    expect([1].lock.isNotEmpty, isTrue);
  });

  test("Creating immutable lists with extensions |" "From a list with one null string",
      () => expect([null].lock, isA<IList<String>>()));

  test("Creating immutable lists with extensions |" "From an empty list typed with String", () {
    final typedList = <String>[].lock;
    expect(typedList, isA<IList<String>>());
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test(
      "Creating native mutable lists from immutable lists | "
      "From the default factory constructor", () {
    expect(IList([1, 2, 3]).unlock, [1, 2, 3]);
    expect(identical(IList([1, 2, 3]).unlock, [1, 2, 3]), isFalse);
  });

  test("Creating native mutable lists from immutable lists | " "From lock", () {
    expect([1, 2, 3].lock.unlock, [1, 2, 3]);
    expect(identical([1, 2, 3].lock.unlock, [1, 2, 3]), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("Other Constructors |" "IList.fromISet constructor",
      () => expect(IList.fromISet({1, 2, 3}.lock, config: null), [1, 2, 3]));

  test("IList.unsafe constructor |" "Normal usage", () {
    final List<int> list = [1, 2, 3];
    final IList<int> iList = IList.unsafe(list, config: ConfigList());

    expect(list, [1, 2, 3]);
    expect(iList, [1, 2, 3]);

    list.add(4);

    expect(list, [1, 2, 3, 4]);
    expect(iList, [1, 2, 3, 4]);
  });

  test("IList.unsafe constructor |" "Disallowing it", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    expect(() => IList.unsafe([1, 2, 3], config: ConfigList()), throwsUnsupportedError);
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

  test("IList.add method", () {
    expect([1, 2, 3].lock, [1, 2, 3]);
    expect([1, 2, 3].lock.add(4), [1, 2, 3, 4]);
  });

  test("IList.addAll method", () {
    expect([1, 2, 3].lock, [1, 2, 3]);
    expect([1, 2, 3, 4].lock.addAll([5, 6]), [1, 2, 3, 4, 5, 6]);
  });

  test("IList.add and IList.addAll methods at the same time",
      () => expect([1, 2, 3].lock.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]));

  test("IList.+ operator", () => expect([1, 2, 3].lock + [4, 5, 6].lock, [1, 2, 3, 4, 5, 6]));

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

  test("IList.maxLength method |" "Cutting the list off", () {
    expect([1, 2, 3, 4, 5].lock.maxLength(2), [1, 2]);
    expect([1, 2, 3, 4, 5].lock.maxLength(3), [1, 2, 3]);
    expect([1, 2, 3, 4, 5].lock.maxLength(1), [1]);
    expect([1, 2, 3, 4, 5].lock.maxLength(0), []);
  });

  test("IList.maxLength method |" "Invalid argument",
      () => expect(() => [1, 2, 3, 4, 5].lock.maxLength(-1), throwsArgumentError));

  test("IList.maxLength method |" "Priority", () {
    final IList<int> ilist = [5, 3, 5, 8, 12, 18, 32, 2, 1, 9].lock;
    expect(ilist.maxLength(3), [5, 3, 5]); // No priority.
    expect(ilist.maxLength(100, priority: (int a, int b) => a.compareTo(b)),
        [5, 3, 5, 8, 12, 18, 32, 2, 1, 9]); // No priority.
    expect(
        ilist.maxLength(3, priority: (int a, int b) => a.compareTo(b)), [3, 2, 1]); // No priority.
    expect(ilist.maxLength(4, priority: (int a, int b) => a.compareTo(b)),
        [5, 3, 2, 1]); // No priority.
    expect(ilist.maxLength(5, priority: (int a, int b) => a.compareTo(b)),
        [5, 3, 5, 2, 1]); // No priority.
    expect(ilist.maxLength(6, priority: (int a, int b) => a.compareTo(b)),
        [5, 3, 5, 8, 2, 1]); // No priority.
  });

  test("IList.toggle method | " "Toggling an existing element", () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    expect(iList.contains(4), isTrue);

    iList = iList.toggle(4);

    expect(iList.contains(4), isFalse);

    iList = iList.toggle(4);

    expect(iList.contains(4), isTrue);
  });

  test("IList.toggle method | " "Toggling a nonexistent element", () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    expect(iList.contains(6), isFalse);

    iList = iList.toggle(6);

    expect(iList.contains(6), isTrue);

    iList = iList.toggle(6);

    expect(iList.contains(6), isFalse);
  });

  test("Index Access |" "iList[index]", () {
    final IList<int> iList = [1, 2, 3, 4, 5].lock;
    expect(iList[0], 1);
    expect(iList[1], 2);
    expect(iList[2], 3);
    expect(iList[3], 4);
    expect(iList[4], 5);
  });

  test("Index Access |" "Range Errors", () {
    final IList<int> iList = [1, 2, 3, 4, 5].lock;
    expect(() => iList[5], throwsA(isA<RangeError>()));
    expect(() => iList[-1], throwsA(isA<RangeError>()));
  });

  //////////////////////////////////////////////////////////////////////////////////////////////////

  test("IList.any method", () {
    expect([1, 2, 3, 4, 5, 6].lock.any((int v) => v == 4), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.any((int v) => v == 100), isFalse);
  });

  test("IList.cast method", () => expect([1, 2, 3, 4, 5, 6].lock.cast<num>(), isA<IList<num>>()));

  test("IList.contains method", () {
    expect([1, 2, 3, 4, 5, 6].lock.contains(2), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(4), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(5), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(100), isFalse);
  });

  test("IList.elementAt method | " "Regular element access", () {
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(0), 1);
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(1), 2);
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(2), 3);
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(3), 4);
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(4), 5);
    expect([1, 2, 3, 4, 5, 6].lock.elementAt(5), 6);
  });

  test("IList.elementAt method | " "Range exceptions", () {
    expect(() => [1, 2, 3, 4, 5, 6].lock.elementAt(6), throwsRangeError);
    expect(() => [1, 2, 3, 4, 5, 6].lock.elementAt(-1), throwsRangeError);
  });

  test("IList.every method", () {
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v > 0), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v < 0), isFalse);
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v != 4), isFalse);
  });

  test("IList.expand method", () {
    expect([1, 2, 3, 4, 5, 6].lock.expand((int v) => [v, v]), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.expand((int v) => []), []);
  });

  test("IList.length method", () => expect([1, 2, 3, 4, 5, 6].lock.length, 6));

  test("IList.first method", () => expect([1, 2, 3, 4, 5, 6].lock.first, 1));

  test("IList.last method", () => expect([1, 2, 3, 4, 5, 6].lock.last, 6));

  test("IList.single method | " "State exception",
      () => expect(() => [1, 2, 3, 4, 5, 6].lock.single, throwsStateError));

  test("IList.single method | " "Access", () => expect([10].lock.single, 10));

  test("IList.firstWhere method", () {
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  test("IList.fold method",
      () => expect([1, 2, 3, 4, 5, 6].lock.fold(100, (int p, int e) => p * (1 + e)), 504000));

  test("IList.followedBy method", () {
    expect([1, 2, 3, 4, 5, 6].lock.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
    expect([1, 2, 3, 4, 5, 6].lock.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock,
        [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  test("IList.forEach method", () {
    int result = 100;
    [1, 2, 3, 4, 5, 6].lock.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  test("IList.join method", () {
    expect([1, 2, 3, 4, 5, 6].lock.join(","), "1,2,3,4,5,6");
    expect([].lock.join(","), "");
  });

  test("IList.lastWhere method", () {
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  test("IList.map method", () {
    expect([1, 2, 3].lock.map((int v) => v + 1).unlock, [2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.map((int v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);
  });

  test("IList.reduce method | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.reduce((int p, int e) => p * (1 + e)), 2520);
    expect([5].lock.reduce((int p, int e) => p * (1 + e)), 5);
  });

  test(
      "IList.reduce method | " "State exception",
      () => expect(
          () => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError));

  test("IList.singleWhere method | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect([1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  test(
      "IList.singleWhere method | "
      "State exception",
      () => expect(() => [1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v < 4, orElse: () => 100),
          throwsStateError));

  test("IList.skip method", () {
    expect([1, 2, 3, 4, 5, 6].lock.skip(1).unlock, [2, 3, 4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(3).unlock, [4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(5).unlock, [6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(10).unlock, []);
  });

  test("IList.skipWhile method", () {
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 3).unlock, [3, 4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 5).unlock, [5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 6).unlock, [6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 100).unlock, []);
  });

  test("IList.take method", () {
    expect([1, 2, 3, 4, 5, 6].lock.take(0).unlock, []);
    expect([1, 2, 3, 4, 5, 6].lock.take(1).unlock, [1]);
    expect([1, 2, 3, 4, 5, 6].lock.take(3).unlock, [1, 2, 3]);
    expect([1, 2, 3, 4, 5, 6].lock.take(5).unlock, [1, 2, 3, 4, 5]);
    expect([1, 2, 3, 4, 5, 6].lock.take(10).unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("IList.takeWhile method", () {
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 3).unlock, [1, 2]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 5).unlock, [1, 2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 6).unlock, [1, 2, 3, 4, 5]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("IList.toList method | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect([1, 2, 3, 4, 5, 6].lock.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test(
      "IList.toList method | " "Unsupported exception",
      () => expect(
          () => [1, 2, 3, 4, 5, 6].lock.toList(growable: false)..add(7), throwsUnsupportedError));

  test("IList.toSet method", () {
    expect([1, 2, 3, 4, 5, 6].lock.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        [1, 2, 3, 4, 5, 6].lock
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect([1, 2, 3, 4, 5, 6].lock.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("IList.where method", () {
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 0).unlock, []);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 3).unlock, [1, 2]);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 5).unlock, [1, 2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  });

  test("IList.whereType method",
      () => expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]));

  test("IList.iterator getter", () {
    final Iterator<int> iterator = [1, 2, 3, 4, 5, 6].lock.iterator;

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

  test("IList.toString method",
      () => expect([1, 2, 3, 4, 5, 6].lock.toString(), "[1, 2, 3, 4, 5, 6]"));

  test("Views | " "IList.unlockView getter", () {
    final List<int> unmodifiableListView = [1, 2, 3].lock.unlockView;

    expect(unmodifiableListView, allOf(isA<List<int>>(), [1, 2, 3]));
  });

  test("Views | " "IList.unlockLazy getter", () {
    final List<int> modifiableListView = [1, 2, 3].lock.unlockLazy;

    expect(modifiableListView, allOf(isA<List<int>>(), [1, 2, 3]));
  });

  test("Or Null Getters | " "IList.firstOrNull getter", () {
    expect(<int>[].lock.firstOrNull, isNull);
    expect(<int>[1, 2].lock.firstOrNull, 1);
  });

  test("Or Null Getters | " "IList.lastOrNull getter", () {
    expect(<int>[].lock.lastOrNull, isNull);
    expect(<int>[1, 2].lock.lastOrNull, 2);
  });

  test("Or Null Getters | " "IList.singleOrNull getter", () {
    expect(<int>[].lock.singleOrNull, isNull);
    expect(<int>[1, 2].lock.singleOrNull, isNull);
    expect(<int>[1].lock.singleOrNull, 1);
  });

  test("Or (else) Methods | " "IList.firstOr method", () {
    expect(<int>[].lock.firstOr(10), 10);
    expect(<int>[1, 2].lock.firstOr(10), 1);
  });

  test("Or (else) Methods | " "IList.lastOr method", () {
    expect(<int>[].lock.lastOr(10), 10);
    expect(<int>[1, 2].lock.lastOr(10), 2);
  });

  test("Or (else) Methods | " "IList.singleOr method", () {
    expect(<int>[].lock.singleOr(10), 10);
    expect(<int>[1, 2].lock.singleOr(10), 10);
    expect(<int>[1].lock.singleOr(10), 1);
  });

  test("IList.sort method", () {
    expect([10, 2, 4, 6, 5].lock.sort(), [2, 4, 5, 6, 10]);
    expect([10, 2, 4, 6, 5].lock.sort((int a, int b) => -a.compareTo(b)), [10, 6, 5, 4, 2]);
  });

  test("IList.asMap method", () {
    expect(["hel", "lo", "there"].lock.asMap(), isA<IMap<int, String>>());
    expect(["hel", "lo", "there"].lock.asMap().unlock, {0: "hel", 1: "lo", 2: "there"});
  });

  test("IList.clear method", () {
    final IList<int> iList = IList.withConfig([1, 2, 3], ConfigList(isDeepEquals: false));

    final IList<int> iListCleared = iList.clear();

    // TODO: Marcelo, eu fiz com que o clear retornasse um `IList` (estava com `void`).
    expect(iListCleared, allOf(isA<IList<int>>(), []));
    expect(iListCleared.config.isDeepEquals, isFalse);
  });

  group("Replacing and Related Methods |", () {
    final IList<String> notes = ["do", "re", "mi", "re"].lock;

    tearDown(() => expect(notes, ["do", "re", "mi", "re"]));

    group("Index Operations |", () {
      test("IList.indexOf method", () {
        expect(notes.indexOf("re"), 1);
        expect(notes.indexOf("re", 2), 3);
        // TODO: Marcelo, mudei o `for` para `<= _length - 1`.
        expect(notes.indexOf("fa"), -1);
      });

      test("IList.indexWhere method", () {
        expect(notes.indexWhere((String element) => element == "re"), 1);
        expect(notes.indexWhere((String element) => element == "re", 2), 3);
        // TODO: Marcelo, mudei o `for` para `<= _length - 1`.
        expect(notes.indexWhere((String element) => element == "fa"), -1);
      });

      test("IList.lastIndexOf method", () {
        expect(notes.lastIndexOf("re", 2), 1);
        expect(notes.lastIndexOf("re"), 3);
        expect(notes.lastIndexOf("fa"), -1);
      });

      test("IList.lastIndexWhere method", () {
        expect(notes.lastIndexWhere((String note) => note.startsWith("r")), 3);
        expect(notes.lastIndexWhere((String note) => note.startsWith("r"), 2), 1);
        expect(notes.lastIndexWhere((String note) => note.startsWith("k")), -1);
      });
    });

    group("Replace |", () {
      test("IList.replaceFirst method", () {
        expect(notes.replaceFirst(from: "re", to: "fa"), ["do", "fa", "mi", "re"]);
        expect(notes.replaceFirst(from: "fa", to: "sol"), ["do", "re", "mi", "re"]);
      });

      test("IList.replaceAll method", () {
        expect(notes.replaceAll(from: "re", to: "fa"), ["do", "fa", "mi", "fa"]);
        expect(notes.replaceAll(from: "fa", to: "sol"), ["do", "re", "mi", "re"]);
      });

      test("IList.replaceFirstWhere method", () {
        expect(
            notes.replaceFirstWhere((String item) => item == "re", "fa"), ["do", "fa", "mi", "re"]);
        expect(notes.replaceFirstWhere((String item) => item == "fa", "sol"),
            ["do", "re", "mi", "re"]);
      });

      test("IList.replaceAllWhere method", () {
        expect(
            notes.replaceAllWhere((String item) => item == "re", "fa"), ["do", "fa", "mi", "fa"]);
        expect(
            notes.replaceAllWhere((String item) => item == "fa", "sol"), ["do", "re", "mi", "re"]);
      });

      test("IList.replaceRange method", () {
        final IList<int> iList = [1, 2, 3, 4, 5].lock;
        expect(iList.replaceRange(1, 4, [6, 7]), [1, 6, 7, 5]);
      });
    });

    group("Range |", () {
      test("IList.fillRange method", () {
        final IList<int> iList = List<int>(3).lock;
        expect(iList.fillRange(0, 2, 1), [1, 1, null]);
        expect(iList, [null, null, null]);
      });

      test("IList.getRange method", () {
        final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
        final Iterable<String> range = colors.getRange(1, 4);
        expect(range, ["green", "blue", "orange"]);
        expect(colors, ["red", "green", "blue", "orange", "pink"]);
        // TODO: Marcelo, o comportamento de `colors.length` na documentação é algo mutável,
        // Você vai querer implementá-lo adaptadamente?
      });

      test("IList.setRange method", () {
        final IList<int> iList1 = [1, 2, 3, 4].lock;
        final IList<int> iList2 = [5, 6, 7, 8, 9].lock;
        expect(iList1.setRange(1, 3, iList2, 3), [1, 8, 9, 4]);
      });
    });

    group("Insert |", () {
      test("IList.insert method", () {
        expect(notes.insert(2, "fa"), ["do", "re", "fa", "mi", "re"]);
      });

      test("IList.insertAll method", () {
        expect(notes.insertAll(3, ["fa", "fo", "fu"]), ["do", "re", "mi", "fa", "fo", "fu", "re"]);
      });
    });

    group("Remove |", () {
      test("IList.removeAt method", () {
        expect(notes.removeAt(2), ["do", "re", "re"]);
        final Output<String> item = Output();
        expect(notes.removeAt(1, item), ["do", "mi", "re"]);
        expect(item.value, "re");
      });

      test("IList.removeLast method", () {
        expect(notes.removeLast(), ["do", "re", "mi"]);
        final Output<String> item = Output();
        expect(notes.removeLast(item), ["do", "re", "mi"]);
        expect(item.value, "re");
      });

      test("IList.removeRange method", () {
        expect(notes.removeRange(1, 3), ["do", "re"]);
      });

      test("IList.removeWhere method", () {
        final IList<String> numbers = ["one", "two", "three", "four"].lock;
        expect(numbers.removeWhere((String item) => item.length == 3), ["three", "four"]);
        expect(numbers, ["one", "two", "three", "four"]);
      });
    });

    test("IList.put method", () {
      final IList<int> iList = [1, 2, 4, 5].lock;

      final IList<int> completeIList = iList.put(2, 3);

      expect(iList, [1, 2, 4, 5]);
      expect(completeIList, [1, 2, 3, 5]);
    });

    group("Others |", () {
      test("IList.process method", () {
        // TODO: Marcelo, isso parece estar fazendo o oposto do que deveria.
        expect(
            notes.process(
              test: (IList<String> iList, int index, String item) => iList[index] == "re",
              apply: (IList<String> iList, int index, String item) => [item + item],
            ),
            ["do", "rere", "mi", "rere"]);
        expect(
            notes.process(
              test: (IList<String> iList, int index, String item) => iList[index] == "fa",
              apply: (IList<String> iList, int index, String item) => [item + item],
            ),
            ["do", "re", "mi", "re"]);
        expect(
            notes.process(
              apply: (IList<String> iList, int index, String item) => [item + item],
            ),
            ["dodo", "rere", "mimi", "rere"]);
      });

      test("IList.sublist method", () {
        final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
        expect(colors.sublist(1, 3), ["green", "blue"]);
        expect(colors.sublist(1), ["green", "blue", "orange", "pink"]);
        expect(colors, ["red", "green", "blue", "orange", "pink"]);
      });

      test("IList.retainWhere method", () {
        final IList<String> numbers = ["one", "two", "three", "four"].lock;
        expect(numbers.retainWhere((String item) => item.length == 3), ["one", "two"]);
        expect(numbers, ["one", "two", "three", "four"]);
      });

      test("IList.reversed getter", () {
        expect(notes.reversed, ["re", "mi", "re", "do"]);
      });

      test("IList.setAll method", () {
        final IList<String> iList = ["a", "b", "c"].lock;
        expect(iList.setAll(1, ["bee", "sea"]), ["a", "bee", "sea"]);
        expect(iList, ["a", "b", "c"]);
      });

      test("IList.shuffle method", () {
        // TODO: Marcelo, por favor, revise.
        final Random random = Random(0);
        final IList<int> iList = [1, 2, 3, 4, 5, 6, 7, 8, 9].lock;

        IList<int> shuffledSum = iList;
        IList<int> shuffledList;
        const int shuffles = 100000;
        for (int i = 0; i < shuffles; i++) {
          shuffledList = iList.shuffle(random);

          for (int i = 0; i < iList.length; i++) {
            final List<int> tempList = shuffledSum.toList(growable: false);
            tempList[i] += shuffledList[i];
            shuffledSum = tempList.lock;
          }
        }

        final int expectedTotal = shuffles * ((iList.first + iList.last) ~/ 2);
        final int maxError = expectedTotal ~/ 50;
        shuffledSum.forEach((int sum) => expect((expectedTotal - sum).abs(), lessThan(maxError)));
      });

      test("IList.whereMoveToTheEnd and whereMoveToTheFront methods", () {
        final IList<int> numbs = [1, 5, 20, 21, 19, 16, 54, 50, 23, 55, 18, 20, 15].lock;

        /// Even numbers to the end.
        expect(numbs.whereMoveToTheEnd((n) => n % 2 == 0),
            [1, 5, 21, 19, 23, 55, 15, 20, 16, 54, 50, 18, 20]);

        /// Even numbers to the front.
        expect(numbs.whereMoveToTheStart((n) => n % 2 == 0),
            [20, 16, 54, 50, 18, 20, 1, 5, 21, 19, 23, 55, 15]);
      });
    });
  });
}
