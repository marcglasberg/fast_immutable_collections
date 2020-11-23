import "dart:collection";
import "dart:math";

import "package:test/test.dart";

import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  //////////////////////////////////////////////////////////////////////////////

  test("Runtime Type", () {
    expect(IList(), isA<IList>());
    expect(IList([]), isA<IList>());
    expect(IList<String>([]), isA<IList<String>>());
    expect(IList([1]), isA<IList<int>>());
    expect(IList.empty<int>(), isA<IList<int>>());
    expect([].lock, isA<IList>());
  });

  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////

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

  ///////////////////////////////////////////////////////////////////////////////////////

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
      "IList.same()", () {
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
      "IList.equalItemsAndConfig()", () {
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
      "Passing a set", () {
    expect(() => IList([1, 2]).equalItems(ISet([1, 2])), throwsStateError);
    expect(() => IList([1, 2]).equalItems(HashSet()..add(1)..add(2)), throwsStateError);
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
      "If IList, will only be equal if in order and the same items", () {
    expect(IList([1, 2]).equalItems(IList([2, 1])), isFalse);
    expect(IList([1, 2]).equalItems(IList([1, 2])), isTrue);
  });

  test(
      "Equals and Other Comparisons | Equals Operator | "
      "Same, Equals and the == Operator | IList.equalItems method | "
      "Other checks", () {
    expect(IList([1, 2]).equalItems(IList([1])), isFalse);
    expect(IList([1, 2]).equalItems(IList([1, 2, 3])), isFalse);
    expect(IList([1, 2]).equalItems(IList([])), isFalse);
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

  //////////////////////////////////////////////////////////////////////////////

  test("IList.hashCode method | " "deepEquals vs deepEquals", () {
    expect(IList([1, 2]) == IList([1, 2]), isTrue);
    expect(IList([1, 2]) == IList([1, 2, 3]), isFalse);
    expect(IList([1, 2]) == IList([2, 1]), isFalse);
    expect(IList([1, 2]).hashCode, IList([1, 2]).hashCode);
    expect(IList([1, 2]).hashCode, isNot(IList([1, 2, 3]).hashCode));
    expect(IList([1, 2]).hashCode, isNot(IList([2, 1]).hashCode));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.hashCode method | " "identityEquals vs identityEquals", () {
    final IList<int> iListWithIdentityEquals = IList([1, 2]).withIdentityEquals;
    expect(iListWithIdentityEquals == IList([1, 2]).withIdentityEquals, isFalse);
    expect(iListWithIdentityEquals == IList([1, 2, 3]).withIdentityEquals, isFalse);
    expect(iListWithIdentityEquals == IList([2, 1]).withIdentityEquals, isFalse);
    expect(iListWithIdentityEquals.hashCode, isNot(IList([1, 2]).withIdentityEquals.hashCode));
    expect(iListWithIdentityEquals.hashCode, isNot(IList([1, 2, 3]).withIdentityEquals.hashCode));
    expect(iListWithIdentityEquals.hashCode, isNot(IList([2, 1]).withIdentityEquals.hashCode));
  });

  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////

  test("IList.withConfig()", () {
    final IList<int> iList = IList([1, 2]);

    expect(iList.isDeepEquals, isTrue);

    IList<int> iListNewConfig = iList.withConfig(iList.config.copyWith());

    IList<int> iListNewConfigIdentity =
        iList.withConfig(iList.config.copyWith(isDeepEquals: false));

    expect(iListNewConfig.isDeepEquals, isTrue);
    expect(iListNewConfigIdentity.isDeepEquals, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.withConfigFrom()", () {
    final IList<int> iList = IList([1, 2]);

    expect(iList.isDeepEquals, isTrue);

    final IList<int> iListWithNoDeepEquals = iList.withConfig(ConfigList(isDeepEquals: false));

    expect(iListWithNoDeepEquals.isDeepEquals, isFalse);

    final IList<int> iListWithConfig = iList.withConfigFrom(iListWithNoDeepEquals);

    expect(iListWithConfig.isDeepEquals, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Creating immutable lists with extensions |" "From an empty list", () {
    expect([].lock, isA<IList>());
    expect([].lock.isEmpty, isTrue);
    expect([].lock.isNotEmpty, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Creating immutable lists with extensions |"
      "From a list with one int item", () {
    expect([1].lock, isA<IList<int>>());
    expect([1].lock.isEmpty, isFalse);
    expect([1].lock.isNotEmpty, isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Creating immutable lists with extensions |"
      "From a list with one null string",
      () => expect([null].lock, isA<IList<String>>()));

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Creating immutable lists with extensions |"
      "From an empty list typed with String", () {
    final typedList = <String>[].lock;
    expect(typedList, isA<IList<String>>());
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "Creating native mutable lists from immutable lists | "
      "From the default factory constructor", () {
    expect(IList([1, 2, 3]).unlock, [1, 2, 3]);
    expect(identical(IList([1, 2, 3]).unlock, [1, 2, 3]), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Creating native mutable lists from immutable lists | " "From lock", () {
    expect([1, 2, 3].lock.unlock, [1, 2, 3]);
    expect(identical([1, 2, 3].lock.unlock, [1, 2, 3]), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Other Constructors | " "IList.fromISet constructor",
      () => expect(IList.fromISet({1, 2, 3}.lock, config: null), [1, 2, 3]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.unsafe constructor | " "Normal usage", () {
    final List<int> list = [1, 2, 3];
    final IList<int> iList = IList.unsafe(list, config: ConfigList());

    expect(list, [1, 2, 3]);
    expect(iList, [1, 2, 3]);

    list.add(4);

    expect(list, [1, 2, 3, 4]);
    expect(iList, [1, 2, 3, 4]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.unsafe constructor | " "Disallowing it", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    expect(() => IList.unsafe([1, 2, 3], config: ConfigList()), throwsUnsupportedError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.flush()", () {
    final IList<int> ilist = [1, 2, 3].lock.add(4).addAll([5, 6]).add(7).addAll([]).addAll([8, 9]);

    expect(ilist.isFlushed, isFalse);

    ilist.flush;

    expect(ilist.isFlushed, isTrue);
    expect(ilist.unlock, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.add()", () => expect([1, 2, 3].lock.add(4), [1, 2, 3, 4]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.addAll()", () => expect([1, 2, 3, 4].lock.addAll([5, 6]), [1, 2, 3, 4, 5, 6]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.add and IList.addAll methods at the same time",
      () => expect([1, 2, 3].lock.add(10).addAll([20, 30]).unlock, [1, 2, 3, 10, 20, 30]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.+ operator", () => expect([1, 2, 3].lock + [4, 5, 6].lock, [1, 2, 3, 4, 5, 6]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.remove()", () {
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

    expect(ilist1, [1, 2, 3]);
    expect(ilist2, [1, 3]);
    expect(ilist3, [1, 3]);
    expect(ilist4, [3]);
    expect(ilist5, []);
    expect(ilist6, []);
    expect(identical(ilist1, ilist2), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.maxLength method |" "Cutting the list off", () {
    expect([1, 2, 3, 4, 5].lock.maxLength(2), [1, 2]);
    expect([1, 2, 3, 4, 5].lock.maxLength(3), [1, 2, 3]);
    expect([1, 2, 3, 4, 5].lock.maxLength(1), [1]);
    expect([1, 2, 3, 4, 5].lock.maxLength(0), []);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.maxLength method |" "Invalid argument",
      () => expect(() => [1, 2, 3, 4, 5].lock.maxLength(-1), throwsArgumentError));

  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////

  test("IList.toggle method | " "Toggling an existing element", () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    expect(iList.contains(4), isTrue);

    iList = iList.toggle(4);

    expect(iList.contains(4), isFalse);

    iList = iList.toggle(4);

    expect(iList.contains(4), isTrue);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.toggle method | " "Toggling a nonexistent element", () {
    IList<int> iList = [1, 2, 3, 4, 5].lock;

    expect(iList.contains(6), isFalse);

    iList = iList.toggle(6);

    expect(iList.contains(6), isTrue);

    iList = iList.toggle(6);

    expect(iList.contains(6), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Index Access |" "iList[index]", () {
    final IList<String> iList = ["a", "b", "c", "d", "e"].lock;
    expect(iList[0], "a");
    expect(iList[1], "b");
    expect(iList[2], "c");
    expect(iList[3], "d");
    expect(iList[4], "e");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Index Access |" "Range Errors", () {
    final IList<String> iList = ["a", "b", "c", "d", "e"].lock;
    expect(() => iList[5], throwsA(isA<RangeError>()));
    expect(() => iList[-1], throwsA(isA<RangeError>()));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.any()", () {
    expect([1, 2, 3, 4, 5, 6].lock.any((int v) => v == 4), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.any((int v) => v == 100), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.cast()", () => expect([1, 2, 3, 4, 5, 6].lock.cast<num>(), isA<IList<num>>()));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.contains()", () {
    expect([1, 2, 3, 4, 5, 6].lock.contains(2), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(4), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(5), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.contains(100), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.elementAt method | " "Regular element access", () {
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(0), "a");
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(1), "b");
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(2), "c");
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(3), "d");
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(4), "e");
    expect(["a", "b", "c", "d", "e", "f"].lock.elementAt(5), "f");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.elementAt method | " "Range exceptions", () {
    expect(() => ["a", "b", "c", "d", "e", "f"].lock.elementAt(6), throwsRangeError);
    expect(() => ["a", "b", "c", "d", "e", "f"].lock.elementAt(-1), throwsRangeError);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.every()", () {
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v > 0), isTrue);
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v < 0), isFalse);
    expect([1, 2, 3, 4, 5, 6].lock.every((int v) => v != 4), isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.expand()", () {
    expect([1, 2, 3, 4, 5, 6].lock.expand((int v) => [v, v]),
        allOf(isA<IList<int>>(), [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6].lock));
    expect(
        [1, 2, 3, 4, 5, 6].lock.expand((int v) => <int>[]), allOf(isA<IList<int>>(), <int>[].lock));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.length", () => expect([1, 2, 3, 4, 5, 6].lock.length, 6));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.first", () => expect(["a", "b", "c", "d", "e", "f"].lock.first, "a"));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.last", () => expect(["a", "b", "c", "d", "e", "f"].lock.last, "f"));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.single() | State exception",
      () => expect(() => [1, 2, 3, 4, 5, 6].lock.single, throwsStateError));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.single() | Access", () => expect([10].lock.single, 10));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.firstWhere()", () {
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 1, orElse: () => 100), 2);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 4, orElse: () => 100), 5);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 5, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.firstWhere((int v) => v > 6, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.fold()",
      () => expect([1, 2, 3, 4, 5, 6].lock.fold(100, (int p, int e) => p * (1 + e)), 504000));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.followedBy()", () {
    expect([1, 2, 3, 4, 5, 6].lock.followedBy([7, 8]).unlock, [1, 2, 3, 4, 5, 6, 7, 8]);
    expect([1, 2, 3, 4, 5, 6].lock.followedBy(<int>[].lock.add(7).addAll([8, 9])).unlock,
        [1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.forEach()", () {
    int result = 100;
    [1, 2, 3, 4, 5, 6].lock.forEach((int v) => result *= 1 + v);
    expect(result, 504000);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.join()", () {
    expect([1, 2, 3, 4, 5, 6].lock.join(","), "1,2,3,4,5,6");
    expect([].lock.join(","), "");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.lastWhere()", () {
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 2, orElse: () => 100), 1);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 5, orElse: () => 100), 4);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 6, orElse: () => 100), 5);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 7, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 50, orElse: () => 100), 6);
    expect([1, 2, 3, 4, 5, 6].lock.lastWhere((int v) => v < 1, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.map()", () {
    expect([1, 2, 3].lock.map((int v) => v + 1).unlock, [2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.map((int v) => v + 1).unlock, [2, 3, 4, 5, 6, 7]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.reduce() | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.reduce((int p, int e) => p * (1 + e)), 2520);
    expect([5].lock.reduce((int p, int e) => p * (1 + e)), 5);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.reduce() | " "State exception",
      () => expect(
          () => IList().reduce((dynamic p, dynamic e) => p * (1 + (e as num))), throwsStateError));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.singleWhere() | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v == 4, orElse: () => 100), 4);
    expect([1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v == 50, orElse: () => 100), 100);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.singleWhere() | " "State exception",
      () => expect(() => [1, 2, 3, 4, 5, 6].lock.singleWhere((int v) => v < 4, orElse: () => 100),
          throwsStateError));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.skip()", () {
    expect([1, 2, 3, 4, 5, 6].lock.skip(1).unlock, [2, 3, 4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(3).unlock, [4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(5).unlock, [6]);
    expect([1, 2, 3, 4, 5, 6].lock.skip(10).unlock, <int>[]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.skipWhile()", () {
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 3).unlock, [3, 4, 5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 5).unlock, [5, 6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 6).unlock, [6]);
    expect([1, 2, 3, 4, 5, 6].lock.skipWhile((int v) => v < 100).unlock, []);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.take()", () {
    expect([1, 2, 3, 4, 5, 6].lock.take(0).unlock, []);
    expect([1, 2, 3, 4, 5, 6].lock.take(1).unlock, [1]);
    expect([1, 2, 3, 4, 5, 6].lock.take(3).unlock, [1, 2, 3]);
    expect([1, 2, 3, 4, 5, 6].lock.take(5).unlock, [1, 2, 3, 4, 5]);
    expect([1, 2, 3, 4, 5, 6].lock.take(10).unlock, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.takeWhile()", () {
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 3).unlock, [1, 2]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 5).unlock, [1, 2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 6).unlock, [1, 2, 3, 4, 5]);
    expect([1, 2, 3, 4, 5, 6].lock.takeWhile((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.toList() | " "Regular usage", () {
    expect([1, 2, 3, 4, 5, 6].lock.toList()..add(7), [1, 2, 3, 4, 5, 6, 7]);
    expect([1, 2, 3, 4, 5, 6].lock.unlock, [1, 2, 3, 4, 5, 6]);
  });

  test(
      "IList.toList () | " "Unsupported exception",
      () => expect(
          () => [1, 2, 3, 4, 5, 6].lock.toList(growable: false)..add(7), throwsUnsupportedError));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.toSet()", () {
    expect([1, 2, 3, 4, 5, 6].lock.toSet()..add(7), {1, 2, 3, 4, 5, 6, 7});
    expect(
        [1, 2, 3, 4, 5, 6].lock
          ..add(6)
          ..toSet(),
        {1, 2, 3, 4, 5, 6});
    expect([1, 2, 3, 4, 5, 6].lock.unlock, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.where()", () {
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 0).unlock, []);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 3).unlock, [1, 2]);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 5).unlock, [1, 2, 3, 4]);
    expect([1, 2, 3, 4, 5, 6].lock.where((int v) => v < 100).unlock, [1, 2, 3, 4, 5, 6]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.whereType()", () => expect((<num>[1, 2, 1.5].lock.whereType<double>()).unlock, [1.5]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.iterator", () {
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

  //////////////////////////////////////////////////////////////////////////////

  test("IList.toString()", () => expect([1, 2, 3, 4, 5, 6].lock.toString(), "[1, 2, 3, 4, 5, 6]"));

  //////////////////////////////////////////////////////////////////////////////

  test("Views | " "IList.unlockView", () {
    final List<int> unmodifiableListView = [1, 2, 3].lock.unlockView;

    expect(unmodifiableListView, allOf(isA<List<int>>(), [1, 2, 3]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Views | " "IList.unlockLazy", () {
    final List<int> modifiableListView = [1, 2, 3].lock.unlockLazy;

    expect(modifiableListView, allOf(isA<List<int>>(), [1, 2, 3]));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or Null Getters | " "IList.firstOrNull", () {
    expect(<int>[].lock.firstOrNull, isNull);
    expect(<int>[1, 2].lock.firstOrNull, 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or Null Getters | " "IList.lastOrNull", () {
    expect(<int>[].lock.lastOrNull, isNull);
    expect(<int>[1, 2].lock.lastOrNull, 2);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or Null Getters | " "IList.singleOrNull", () {
    expect(<int>[].lock.singleOrNull, isNull);
    expect(<int>[1, 2].lock.singleOrNull, isNull);
    expect(<int>[1].lock.singleOrNull, 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or (else) Methods | " "IList.firstOr()", () {
    expect(<int>[].lock.firstOr(10), 10);
    expect(<int>[1, 2].lock.firstOr(10), 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or (else) Methods | " "IList.lastOr()", () {
    expect(<int>[].lock.lastOr(10), 10);
    expect(<int>[1, 2].lock.lastOr(10), 2);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("Or (else) Methods | " "IList.singleOr()", () {
    expect(<int>[].lock.singleOr(10), 10);
    expect(<int>[1, 2].lock.singleOr(10), 10);
    expect(<int>[1].lock.singleOr(10), 1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.sort()", () {
    expect([10, 2, 4, 6, 5].lock.sort(), [2, 4, 5, 6, 10]);
    expect([10, 2, 4, 6, 5].lock.sort((int a, int b) => -a.compareTo(b)), [10, 6, 5, 4, 2]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.asMap()", () {
    expect(["hel", "lo", "there"].lock.asMap(), isA<IMap<int, String>>());
    expect(["hel", "lo", "there"].lock.asMap().unlock, {0: "hel", 1: "lo", 2: "there"});
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.clear()", () {
    final IList<int> iList = IList.withConfig([1, 2, 3], ConfigList(isDeepEquals: false));

    final IList<int> iListCleared = iList.clear();

    // TODO: Marcelo, eu fiz com que o clear retornasse um `IList` (estava com `void`).
    expect(iListCleared, allOf(isA<IList<int>>(), []));
    expect(iListCleared.config.isDeepEquals, isFalse);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.indexOf()", () {
    var iList = ["do", "re", "mi", "re"].lock;
    expect(iList.indexOf("re"), 1);
    expect(iList.indexOf("re", 2), 3);
    expect(iList.indexOf("fa"), -1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.indexWhere()", () {
    var iList = ["do", "re", "mi", "re"].lock;
    expect(iList.indexWhere((String element) => element == "re"), 1);
    expect(iList.indexWhere((String element) => element == "re", 2), 3);
    expect(iList.indexWhere((String element) => element == "fa"), -1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.lastIndexOf()", () {
    var iList = ["do", "re", "mi", "re"].lock;
    expect(iList.lastIndexOf("re", 2), 1);
    expect(iList.lastIndexOf("re"), 3);
    expect(iList.lastIndexOf("fa"), -1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.lastIndexWhere()", () {
    var iList = ["do", "re", "mi", "re"].lock;
    expect(iList.lastIndexWhere((String note) => note.startsWith("r")), 3);
    expect(iList.lastIndexWhere((String note) => note.startsWith("r"), 2), 1);
    expect(iList.lastIndexWhere((String note) => note.startsWith("k")), -1);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.replaceFirst()", () {
    var ilist = ["do", "re", "mi", "re"].lock;
    expect(ilist.replaceFirst(from: "re", to: "x"), ["do", "x", "mi", "re"]);
    expect(ilist.replaceFirst(from: "fa", to: "x"), ["do", "re", "mi", "re"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.replaceAll()", () {
    var ilist = ["do", "re", "mi", "re"].lock;
    expect(ilist.replaceAll(from: "re", to: "x"), ["do", "x", "mi", "x"]);
    expect(ilist.replaceAll(from: "fa", to: "x"), ["do", "re", "mi", "re"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.replaceFirstWhere()", () {
    var ilist = ["do", "re", "mi", "re"].lock;

    expect(ilist.replaceFirstWhere((String item) => item == "re", "x"), ["do", "x", "mi", "re"]);

    expect(ilist.replaceFirstWhere((String item) => item == "fa", "x"), ["do", "re", "mi", "re"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.replaceAllWhere()", () {
    var ilist = ["do", "re", "mi", "re"].lock;

    expect(ilist.replaceAllWhere((String item) => item == "re", "x"), ["do", "x", "mi", "x"]);

    expect(ilist.replaceAllWhere((String item) => item == "fa", "x"), ["do", "re", "mi", "re"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.replaceRange()",
      () => expect(
          ['a', 'b', 'c', 'd', 'e'].lock.replaceRange(1, 4, ['f', 'g']), ['a', 'f', 'g', 'e']));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.fillRange()", () {
    expect(List<int>(3).lock.fillRange(0, 2, 1), [1, 1, null]);
    expect(List<int>(3).lock, [null, null, null]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.getRange()", () {
    final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
    final Iterable<String> range = colors.getRange(1, 4);
    expect(range, ["green", "blue", "orange"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"]);
    // TODO: Marcelo, o comportamento de `colors.length` na documentação é algo mutável,
    // Você vai querer implementá-lo adaptadamente?
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.setRange()",
      () => expect([1, 2, 3, 4].lock.setRange(1, 3, [5, 6, 7, 8, 9].lock, 3), [1, 8, 9, 4]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.insert()",
      () => expect(["do", "re", "mi", "re"].lock.insert(2, "fa"), ["do", "re", "fa", "mi", "re"]));

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.insertAll()",
      () => expect(["do", "re", "mi", "re"].lock.insertAll(3, ["fa", "fo", "fu"]),
          ["do", "re", "mi", "fa", "fo", "fu", "re"]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.removeAt()", () {
    expect(["do", "re", "mi", "re"].lock.removeAt(2), ["do", "re", "re"]);
    final Output<String> item = Output();
    expect(["do", "re", "mi", "re"].lock.removeAt(1, item), ["do", "mi", "re"]);
    expect(item.value, "re");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.removeLast()", () {
    expect(["do", "re", "mi", "re"].lock.removeLast(), ["do", "re", "mi"]);
    final Output<String> item = Output();
    expect(["do", "re", "mi", "re"].lock.removeLast(item), ["do", "re", "mi"]);
    expect(item.value, "re");
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.removeRange()",
      () => expect(["do", "re", "mi", "re"].lock.removeRange(1, 3), ["do", "re"]));

  //////////////////////////////////////////////////////////////////////////////

  test(
      "IList.removeWhere()",
      () => expect(
          ["one", "two", "three", "four"].lock.removeWhere((String item) => item.length == 3),
          ["three", "four"]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.put()", () {
    final IList<int> iList = [1, 2, 4, 5].lock;

    final IList<int> completeIList = iList.put(2, 3);

    expect(iList, [1, 2, 4, 5]);
    expect(completeIList, [1, 2, 3, 5]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.process()", () {
    var original = ["do", "re", "mi", "re"].lock;

    // Check all items are tested.
    // Check convert is called for all items that test true.
    int testCount = 0;
    int convertCount = 0;
    var converted = original.process(test: (IList<String> iList, int index, String item) {
      testCount++;
      expect(identical(item, iList[index]), isTrue);
      return true;
    }, convert: (IList<String> iList, int index, String item) {
      convertCount++;
      expect(identical(item, iList[index]), isTrue);
      return ["x"];
    });
    expect(converted, ["x", "x", "x", "x"]);
    expect(testCount, 4);
    expect(convertCount, 4);

    // Convert only items which tested true.
    converted = original.process(
        test: (_, __, String item) => item == "re", convert: (_, __, String item) => [item + item]);
    expect(converted, ["do", "rere", "mi", "rere"]);

    // No items satisfy the test.
    converted = original.process(
        test: (_, __, String item) => item == "fa", convert: (_, __, String item) => [item + item]);
    expect(identical(converted, original), isTrue);

    // Items satisfy the test, but convert returns null.
    converted =
        original.process(test: (_, __, String item) => true, convert: (_, __, String item) => null);
    expect(identical(converted, original), isTrue);

    // Items satisfy the test, but convert returns the item in a list.
    converted = original.process(
        test: (_, __, String item) => true, convert: (_, __, String item) => [item]);
    expect(identical(converted, original), isTrue);

    // Convert returns empty.
    converted = original.process(
        test: (_, __, String item) => item == "re", convert: (_, __, String item) => const []);
    expect(converted, ["do", "mi"]);

    // Convert returns multiple items.
    converted = original.process(
        test: (_, __, String item) => item == "re",
        convert: (_, __, String item) => ["re1", "re1", "re3"]);
    expect(converted, ["do", "re1", "re1", "re3", "mi", "re1", "re1", "re3"]);

    // If no test is provided, apply to all items.
    converted = original.process(convert: (_, __, String item) => [item + item]);
    expect(converted, ["dodo", "rere", "mimi", "rere"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.sublist()", () {
    final IList<String> colors = ["red", "green", "blue", "orange", "pink"].lock;
    expect(colors.sublist(1, 3), ["green", "blue"]);
    expect(colors.sublist(1), ["green", "blue", "orange", "pink"]);
    expect(colors, ["red", "green", "blue", "orange", "pink"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.retainWhere()", () {
    final IList<String> numbers = ["one", "two", "three", "four"].lock;
    expect(numbers.retainWhere((String item) => item.length == 3), ["one", "two"]);
    expect(numbers, ["one", "two", "three", "four"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.reversed getter",
      () => expect(["do", "re", "mi", "re"].lock.reversed, ["re", "mi", "re", "do"]));

  //////////////////////////////////////////////////////////////////////////////

  test("IList.setAll()", () {
    final IList<String> iList = ["a", "b", "c"].lock;
    expect(iList.setAll(1, ["bee", "sea"]), ["a", "bee", "sea"]);
    expect(iList, ["a", "b", "c"]);
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.shuffle()", () {
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
    final int maxError = (expectedTotal * .02).round();
    shuffledSum.forEach((int sum) => expect((expectedTotal - sum).abs(), lessThan(maxError)));
  });

  //////////////////////////////////////////////////////////////////////////////

  test("IList.whereMoveToTheEnd and whereMoveToTheFront methods", () {
    final IList<int> numbs = [1, 5, 20, 21, 19, 16, 54, 50, 23, 55, 18, 20, 15].lock;

    /// Even numbers to the end.
    expect(numbs.whereMoveToTheEnd((int n) => n % 2 == 0),
        [1, 5, 21, 19, 23, 55, 15, 20, 16, 54, 50, 18, 20]);

    /// Even numbers to the start.
    expect(numbs.whereMoveToTheStart((int n) => n % 2 == 0),
        [20, 16, 54, 50, 18, 20, 1, 5, 21, 19, 23, 55, 15]);
  });
}
