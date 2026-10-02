// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import "dart:collection";
import "dart:convert";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:test/test.dart";

/// These tests cover [IList] code paths which were not reached by the other tests:
/// const lists with auto-flush on, identity equality on const lists, non-flushed
/// lists which become empty, `IList<Never>`, JSON support, and some edge cases.
void main() {
  //
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
  });

  tearDown(() {
    ImmutableCollection.resetAllConfigurations();
  });

  /////////////////////////////////////////////////////////////////////////////

  test("IList.empty | Non-const constructor creates an empty list", () {
    // Note: This is wrong usage (should always use const), but must still work.
    // ignore: non_const_call_to_literal_constructor
    final IList<int> ilist = IList<int>.empty();

    expect(ilist, isA<IListEmpty<int>>());
    expect(ilist.isEmpty, isTrue);
    expect(ilist.length, 0);
    expect(ilist.isDeepEquals, isTrue);
    expect(ilist, const IList<int>.empty());
    expect(ilist, IList<int>());
    expect(ilist.hashCode, const IList<int>.empty().hashCode);
    expect(ilist.hashCode, IList<int>().hashCode);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("hashCode | IListConst with identity equality", () {
    const IList<int> ilist = IListConst<int>([1, 2], ConfigList(isDeepEquals: false));

    expect(ilist.isIdentityEquals, isTrue);
    expect(ilist.hashCode, isA<int>());

    // Equal by identity of the internal list.
    expect(ilist == ilist, isTrue);
    expect(ilist == const IListConst<int>([1, 2], ConfigList(isDeepEquals: false)), isTrue);

    // Not equal to a list with the same items, but with deep equals.
    expect(ilist == const IListConst<int>([1, 2]), isFalse);
  });

  test(
    "hashCode | IListConst with identity equality is stable and consistent with ==",
    () {
      const IList<int> ilist1 = IListConst<int>([1, 2], ConfigList(isDeepEquals: false));
      const IList<int> ilist2 = IListConst<int>([1, 2], ConfigList(isDeepEquals: false));

      // The hashCode must not change between calls.
      expect(ilist1.hashCode, ilist1.hashCode);

      // Equal objects must have the same hashCode.
      expect(ilist1, ilist2);
      expect(ilist1.hashCode, ilist2.hashCode);

      // So that it works in hash-based collections.
      expect({ilist1}.contains(ilist2), isTrue);

      // Empty const lists are all equal to each other, so they must have the same hashCode.
      const IList<int> empty1 = IListConst<int>([], ConfigList(isDeepEquals: false));
      const IList<int> empty2 = IListConst<int>(<int>[], ConfigList(isDeepEquals: false));
      expect(empty1, empty2);
      expect(empty1.hashCode, empty2.hashCode);
    },
  );

  test("hashCode | IListConst with deep equality is stable and consistent with ==", () {
    const IList<int> ilist1 = IListConst<int>([1, 2]);
    final IList<int> ilist2 = [1, 2].lock;

    expect(ilist1.hashCode, ilist1.hashCode);
    expect(ilist1, ilist2);
    expect(ilist1.hashCode, ilist2.hashCode);
    expect(const IListConst<int>([]).hashCode, const IList<int>.empty().hashCode);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("Auto-flush | Read operations on const lists, with autoFlush on", () {
    expect(ImmutableCollection.autoFlush, isTrue);

    const IList<int> ilist = IListConst<int>([10, 20, 30]);

    expect(ilist[0], 10);
    expect(ilist[2], 30);
    expect(ilist.elementAt(1), 20);
    expect(ilist.contains(20), isTrue);
    expect(ilist.contains(40), isFalse);
    expect(ilist.indexOf(30), 2);
    expect(ilist.indexOf(40), -1);
    expect(ilist.put(1, 25), [10, 25, 30]);
    expect(ilist.replaceFirst(from: 10, to: 11), [11, 20, 30]);
    expect(() => ilist[3], throwsRangeError);

    // The original is unchanged, and is still flushed.
    expect(ilist, [10, 20, 30]);
    expect(ilist.isFlushed, isTrue);
  });

  test("Auto-flush | Read operations on empty lists, with autoFlush on", () {
    expect(ImmutableCollection.autoFlush, isTrue);

    const IList<int> ilist = IList<int>.empty();

    expect(() => ilist[0], throwsRangeError);
    expect(() => ilist.elementAt(0), throwsRangeError);
    expect(ilist.contains(1), isFalse);
    expect(ilist.indexOf(1), -1);
    expect(() => ilist.put(0, 1), throwsRangeError);
    expect(ilist.replaceFirst(from: 1, to: 2), same(ilist));
    expect(ilist.isFlushed, isTrue);

    // The empty IListConst also works.
    const IList<int> ilistConst = IListConst<int>([]);
    expect(() => ilistConst[0], throwsRangeError);
    expect(ilistConst.indexOf(1), -1);
    expect(ilistConst.contains(1), isFalse);
  });

  test("Auto-flush | Read operations on const lists, with autoFlush off", () {
    ImmutableCollection.autoFlush = false;

    const IList<int> ilist = IListConst<int>([10, 20, 30]);

    expect(ilist[1], 20);
    expect(ilist.elementAt(2), 30);
    expect(ilist.contains(10), isTrue);
    expect(ilist.indexOf(20), 1);
    expect(ilist.put(0, 0), [0, 20, 30]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("IList.withConfig | Empty IList of the exact type, with a different config", () {
    const ConfigList identityConfig = ConfigList(isDeepEquals: false);

    final IList<int> original = IList<int>();
    final IList<int> ilist = IList<int>.withConfig(original, identityConfig);

    expect(ilist, isNot(same(original)));
    expect(ilist.isEmpty, isTrue);
    expect(ilist.config, identityConfig);
    expect(ilist.isIdentityEquals, isTrue);
    expect(original.config, const ConfigList());

    // Also works with the const empty list.
    final IList<int> fromConst = IList<int>.withConfig(const IList<int>.empty(), identityConfig);
    expect(fromConst.isEmpty, isTrue);
    expect(fromConst.config, identityConfig);

    // Same config returns the same instance.
    expect(IList<int>.withConfig(original, const ConfigList()), same(original));
  });

  test("IList.withConfig | A null iterable creates an empty list with the given config", () {
    const ConfigList identityConfig = ConfigList(isDeepEquals: false, cacheHashCode: false);

    final IList<int> ilist = IList<int>.withConfig(null, identityConfig);

    expect(ilist, isA<IList<int>>());
    expect(ilist.isEmpty, isTrue);
    expect(ilist.length, 0);
    expect(ilist.config, identityConfig);
    expect(ilist.add(1), [1]);
    expect(ilist.add(1).config, identityConfig);

    // With the default config, it's equal to the empty list.
    expect(IList<String>.withConfig(null, const ConfigList()), const IList<String>.empty());
  });

  /////////////////////////////////////////////////////////////////////////////

  test("IList.fromJson | Creates an IList from a JSON list", () {
    final IList<int> ilist = IList<int>.fromJson([1, 2, 3], (Object? json) => json as int);
    expect(ilist, isA<IList<int>>());
    expect(ilist, [1, 2, 3]);

    final IList<String> empty = IList<String>.fromJson([], (Object? json) => json as String);
    expect(empty, isEmpty);

    // Converting items while decoding.
    final IList<DateTime> dates = IList<DateTime>.fromJson(
      ["2021-01-02T00:00:00.000", "2022-03-04T00:00:00.000"],
      (Object? json) => DateTime.parse(json as String),
    );
    expect(dates, [DateTime(2021, 1, 2), DateTime(2022, 3, 4)]);

    // Not a list.
    expect(() => IList<int>.fromJson(1, (Object? json) => json as int), throwsA(isA<TypeError>()));
  });

  test("IList.toJson | Converts an IList to a JSON list", () {
    final Object json = [1, 2, 3].lock.toJson((int item) => item * 10);
    expect(json, isA<List>());
    expect(json, [10, 20, 30]);

    expect(IList<int>().toJson((int item) => item), []);
    expect(const IListConst<String>(["a", "b"]).toJson((String item) => item), ["a", "b"]);

    // Non-flushed list.
    expect([1].lock.add(2).addAll([3, 4]).toJson((int item) => "$item"), ["1", "2", "3", "4"]);
  });

  test("IList.fromJson / toJson | Round-trip through jsonEncode and jsonDecode", () {
    final IList<int> ilist = [1, 2, 3].lock;
    final String encoded = jsonEncode(ilist.toJson((int item) => item));
    expect(encoded, "[1,2,3]");

    final IList<int> decoded = IList<int>.fromJson(jsonDecode(encoded), (json) => json as int);
    expect(decoded, ilist);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sortReversed | Without a compare function, uses the reversed natural order", () {
    final IList<int> ilist = [3, 1, 5, 2, 4].lock;
    final IList<int> sorted = ilist.sortReversed();

    expect(sorted, [5, 4, 3, 2, 1]);
    expect(ilist, [3, 1, 5, 2, 4]);

    expect(["b", "c", "a"].lock.sortReversed(), ["c", "b", "a"]);
    expect(IList<int>().sortReversed(), isEmpty);
    expect([1].lock.sortReversed(), [1]);
    expect(const IListConst<int>([1, 3, 2]).sortReversed(), [3, 2, 1]);

    // Non-flushed list.
    expect([2].lock.add(5).addAll([1, 4]).sortReversed(), [5, 4, 2, 1]);
  });

  test("sortReversed | With a compare function, reverses it", () {
    final IList<String> ilist = ["ccc", "a", "bb", "dddd"].lock;
    final IList<String> sorted =
        ilist.sortReversed((String a, String b) => a.length.compareTo(b.length));

    expect(sorted, ["dddd", "ccc", "bb", "a"]);
    expect(ilist, ["ccc", "a", "bb", "dddd"]);

    // The compare function is reversed, so a "descending" compare sorts ascending.
    expect([3, 1, 2].lock.sortReversed((int a, int b) => b.compareTo(a)), [1, 2, 3]);
  });

  test("sortReversed | Keeps the config", () {
    final IList<int> ilist = [1, 2, 3].lock.withIdentityEquals;
    final IList<int> sorted = ilist.sortReversed();
    expect(sorted, [3, 2, 1]);
    expect(sorted.isIdentityEquals, isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("equalItems | null is never equal", () {
    expect([1, 2].lock.equalItems(null), isFalse);
    expect(IList<int>().equalItems(null), isFalse);
    expect(const IList<int>.empty().equalItems(null), isFalse);
    expect(const IListConst<int>([1]).equalItems(null), isFalse);
  });

  test("unorderedEqualItems | null is never equal", () {
    expect([1, 2].lock.unorderedEqualItems(null), isFalse);
    expect(IList<int>().unorderedEqualItems(null), isFalse);
    expect(const IList<int>.empty().unorderedEqualItems(null), isFalse);
    expect(const IListConst<int>([1]).unorderedEqualItems(null), isFalse);

    // Sanity check.
    expect([1, 2].lock.unorderedEqualItems([2, 1]), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("addAll | IList<Never>", () {
    final IList<Never> ilist = IList<Never>();
    final IList<Never> result = ilist.addAll(<Never>[]);

    expect(result, isA<IList<Never>>());
    expect(result, isEmpty);
    expect(result.length, 0);
    expect(result.config, ilist.config);

    // The const empty list of Never.
    final IList<Never> fromConst = const IList<Never>.empty().addAll(<Never>[]);
    expect(fromConst, isEmpty);
    expect(fromConst.config, const ConfigList());

    // Keeps the config.
    final IList<Never> identity = IList<Never>().withIdentityEquals.addAll(<Never>[]);
    expect(identity, isEmpty);
    expect(identity.isIdentityEquals, isTrue);

    // Using the + operator.
    expect(IList<Never>() + <Never>[], isEmpty);
  });

  test("addAll | IList<Never> works when unsafe constructors are disallowed", () {
    ImmutableCollection.disallowUnsafeConstructors = true;
    final IList<Never> result = IList<Never>().addAll(<Never>[]);
    expect(result, isEmpty);
    expect(result, isA<IList<Never>>());
  });

  /////////////////////////////////////////////////////////////////////////////

  test("length | A non-flushed empty list gets flushed when its length is read", () {
    final IList<int> ilist = IList<int>().addAll(<int>[]);
    expect(ilist.isFlushed, isFalse);

    expect(ilist.length, 0);
    expect(ilist.isFlushed, isTrue);

    // Still works after flushing.
    expect(ilist.isEmpty, isTrue);
    expect(ilist, IList<int>());
    expect(ilist.add(1), [1]);
  });

  test("length | A non-flushed empty list from adding empty ILists", () {
    final IList<String> ilist = IList<String>().addAll(IList<String>()).addAll(<String>{});
    expect(ilist.isFlushed, isFalse);
    expect(ilist.length, 0);
    expect(ilist.isFlushed, isTrue);
    expect(ilist, isEmpty);
  });

  test("length | A non-flushed non-empty list is not flushed when its length is read", () {
    final IList<int> ilist = [1].lock.add(2);
    expect(ilist.isFlushed, isFalse);
    expect(ilist.length, 2);
    expect(ilist.isFlushed, isFalse);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("corresponds | Iterable which reports a wrong length", () {
    // The length says 3, but iterating gives only 2 items.
    final Iterable<int> lying = _WrongLengthIterable([2, 4], reportedLength: 3);
    expect(lying.length, 3);

    expect([1, 2, 3].lock.corresponds(lying, (a, b) => a * 2 == b), isFalse);

    // Sanity check.
    expect([1, 2].lock.corresponds([2, 4], (a, b) => a * 2 == b), isTrue);
    expect(IList<int>().corresponds(<int>[], (a, b) => false), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeAll | Removing nothing returns the same list", () {
    final IList<int> ilist = [1, 2, 3].lock;
    expect(ilist.removeAll([4, 5]), same(ilist));
    expect(ilist.removeAll([]), same(ilist));

    // Non-flushed list.
    final IList<int> notFlushed = [1].lock.add(2).addAll([3]);
    expect(notFlushed.removeAll([4]), same(notFlushed));

    // Nulls in a list without nulls.
    final IList<int?> nullable = <int?>[1, 2].lock;
    expect(nullable.removeNulls(), same(nullable));

    // Const list.
    // Note: Not necessarily the same instance, since the const list creates its internals on demand.
    const IList<int> constList = IListConst<int>([1, 2]);
    expect(constList.removeAll([3]), constList);

    // Sanity check, when removing something.
    expect(ilist.removeAll([1, 3, 4]), [2]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("sort | IList<MapEntry> without a compare function sorts by key, then value", () {
    final IList<MapEntry> ilist = IList<MapEntry>([
      MapEntry("b", 1),
      MapEntry("a", 2),
      MapEntry("c", 0),
      MapEntry("a", 1),
    ]);

    final IList<MapEntry> sorted = ilist.sort();
    expect(sorted.map((e) => "${e.key}${e.value}"), ["a1", "a2", "b1", "c0"]);

    // Original unchanged.
    expect(ilist.map((e) => "${e.key}${e.value}"), ["b1", "a2", "c0", "a1"]);
  });

  test("sortOrdered | IList<MapEntry> without a compare function sorts by key, then value", () {
    final IList<MapEntry> ilist = IList<MapEntry>([
      MapEntry("b", 1),
      MapEntry("a", 2),
      MapEntry("c", 0),
      MapEntry("a", 1),
    ]);

    final IList<MapEntry> sorted = ilist.sortOrdered();
    expect(sorted.map((e) => "${e.key}${e.value}"), ["a1", "a2", "b1", "c0"]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("operator [] | Index into the second part of a list created by adding an IList", () {
    final IList<int> ilist = [1, 2].lock.addAll([3, 4].lock);
    expect(ilist.isFlushed, isFalse);

    expect(ilist[0], 1);
    expect(ilist[1], 2);
    expect(ilist[2], 3);
    expect(ilist[3], 4);
    expect(ilist.elementAt(3), 4);
    expect(ilist.get(2), 3);
    expect(ilist.getOrNull(3), 4);
    expect(ilist.getOrNull(4), isNull);
    expect(() => ilist[4], throwsRangeError);
    expect(() => ilist[-1], throwsRangeError);

    // The added IList is itself not flushed.
    final IList<int> ilist2 = [1].lock.addAll([2].lock.add(3).add(4));
    expect(ilist2[1], 2);
    expect(ilist2[2], 3);
    expect(ilist2[3], 4);
    expect(() => ilist2[4], throwsRangeError);

    // The added IList is empty.
    final IList<int> ilist3 = [1, 2].lock.addAll(IList<int>());
    expect(ilist3[1], 2);
    expect(() => ilist3[2], throwsRangeError);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("concat | Only the 4th and 5th lists have items", () {
    final List<int> result = <int>[].concat([], [], [4, 5], [6]);
    expect(result, [4, 5, 6]);

    // Fixed-length, but modifiable.
    expect(() => result.add(7), throwsUnsupportedError);
    result[0] = 40;
    expect(result, [40, 5, 6]);

    expect(<int>[].concat(null, null, [1]), [1]);
    expect(<int>[].concat(null, null, [1], null), [1]);
  });

  test("concat | Only the 5th list has items", () {
    expect(<int>[].concat(null, null, null, [7, 8]), [7, 8]);
    expect(<int>[].concat([], [], [], [9]), [9]);
    expect(<String?>[].concat([], [], [], [null]), [null]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("removeDuplicates | With 'by' and 'removeNulls'", () {
    final List<int?> list = [1, null, 2, null, 1, 3, null];
    list.removeDuplicates(by: (int? item) => item, removeNulls: true);
    expect(list, [1, 2, 3]);

    // When not removing nulls, the first null is kept (it's a distinct id).
    final List<int?> list2 = [1, null, 2, null, 1, 3, null];
    list2.removeDuplicates(by: (int? item) => item);
    expect(list2, [1, null, 2, 3]);

    // The nulls are removed before calling the "by" function.
    final List<String?> list3 = ["a", null, "bb", "cc", null, "d"];
    list3.removeDuplicates(by: (String? item) => item!.length, removeNulls: true);
    expect(list3, ["a", "bb"]);

    // Only nulls.
    final List<int?> list4 = [null, null];
    list4.removeDuplicates(by: (int? item) => item, removeNulls: true);
    expect(list4, isEmpty);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("Identity equals | Lists sharing the same internals are equal", () {
    final IList<int> ilist1 = [1, 2, 3].lock.withIdentityEquals;
    final IList<int> ilist2 = IList<int>.withConfig(ilist1, ilist1.config);
    final IList<int> ilist3 = [1, 2, 3].lock.withIdentityEquals;

    expect(ilist2, same(ilist1));
    expect(ilist1 == ilist2, isTrue);
    expect(ilist1 == ilist3, isFalse);
    expect(ilist1.equalItems(ilist3), isTrue);
    expect(ilist1.unorderedEqualItems(ilist3.reversed), isTrue);
    expect(ilist1.hashCode, ilist2.hashCode);
  });

  test("Identity equals | IListConst with the same const list", () {
    const IList<int> ilist1 = IListConst<int>([1, 2, 3], ConfigList(isDeepEquals: false));
    const IList<int> ilist2 = IListConst<int>([1, 2, 3], ConfigList(isDeepEquals: false));
    const IList<int> ilist3 = IListConst<int>([1, 2, 3]);

    expect(ilist1 == ilist2, isTrue);
    expect(ilist1.same(ilist2), isTrue);
    expect(ilist1 == ilist3, isFalse);
    expect(ilist1.equalItems([1, 2, 3]), isTrue);
    expect(ilist1.equalItemsAndConfig(ilist3), isFalse);
  });

  test(
    "equalItems | Ignores the config, even after the hashCodes are calculated",
    () {
      final IList<int> deep = [1, 2].lock;
      final IList<int> identity = [1, 2].lock.withIdentityEquals;
      expect(deep.equalItems(identity), isTrue);

      // Calculating (and caching) the hashCodes must not change the result.
      deep.hashCode;
      identity.hashCode;
      expect(deep.equalItems(identity), isTrue);
      expect(identity.equalItems(deep), isTrue);

      // Const lists always have a hashCode available.
      const IList<int> const1 = IListConst<int>([1, 2]);
      const IList<int> const2 = IListConst<int>([1, 2], ConfigList(cacheHashCode: false));
      const IList<int> const3 = IListConst<int>([1, 2], ConfigList(isDeepEquals: false));
      expect(const1.equalItems(const2), isTrue);
      expect(const3.equalItems(deep), isTrue);
      expect(deep.equalItems(const3), isTrue);

      // Different items with the same config are still detected, before and after the hashCodes.
      final IList<int> other = [1, 3].lock;
      expect(deep.equalItems(other), isFalse);
      other.hashCode;
      expect(deep.equalItems(other), isFalse);
    },
  );

  test("equalItemsAndConfig | Identity equals with equal items but different internals", () {
    final IList<int> ilist1 = IList.withConfig([1, 2], ConfigList(isDeepEquals: false));
    final IList<int> ilist2 = IList.withConfig([1, 2], ConfigList(isDeepEquals: false));
    expect(ilist1 == ilist2, isFalse);
    expect(ilist1.equalItemsAndConfig(ilist2), isTrue);

    // Calculating the (identity based) hashCodes must not change the result.
    ilist1.hashCode;
    ilist2.hashCode;
    expect(ilist1.equalItemsAndConfig(ilist2), isTrue);

    expect(ilist1.equalItemsAndConfig(null), isFalse);
    expect([1].lock.equalItemsAndConfig(null), isFalse);
    expect(const IList<int>.empty().equalItemsAndConfig(null), isFalse);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("Non-flushed lists | Query methods give the same results as flushed lists", () {
    final IList<int> notFlushed = [1, 2].lock.add(3).addAll([4, 5]).addAll([6].lock);
    final IList<int> flushed = [1, 2, 3, 4, 5, 6].lock;
    expect(notFlushed.isFlushed, isFalse);

    expect(notFlushed, flushed);
    expect(notFlushed.hashCode, flushed.hashCode);
    expect(notFlushed.first, 1);
    expect(notFlushed.last, 6);
    expect(notFlushed.length, 6);
    expect(notFlushed.contains(6), isTrue);
    expect(notFlushed.contains(7), isFalse);
    expect(notFlushed.indexOf(4), 3);
    expect(notFlushed.lastIndexOf(6), 5);
    expect(notFlushed.sublist(2, 5), [3, 4, 5]);
    expect(notFlushed.reversed, [6, 5, 4, 3, 2, 1]);
    expect(notFlushed.toList(), [1, 2, 3, 4, 5, 6]);
    expect(notFlushed.unlock, [1, 2, 3, 4, 5, 6]);
    expect(notFlushed.toSet(), {1, 2, 3, 4, 5, 6});
    expect(notFlushed.toJson((int i) => i), [1, 2, 3, 4, 5, 6]);
    expect(notFlushed.join(","), "1,2,3,4,5,6");
    expect(notFlushed.removeAll([1, 6]), [2, 3, 4, 5]);
    expect(notFlushed.sortReversed(), [6, 5, 4, 3, 2, 1]);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("toString | IListConst and IListEmpty", () {
    expect(const IListConst<int>([1, 2]).toString(false), "[1, 2]");
    expect(const IList<int>.empty().toString(false), "[]");
    expect(const IListConst<int>([]).toString(false), "[]");
  });

  test("unlockView / unlockLazy | Const lists", () {
    const IList<int> ilist = IListConst<int>([1, 2, 3]);

    final List<int> view = ilist.unlockView;
    expect(view, [1, 2, 3]);
    expect(() => view.add(4), throwsUnsupportedError);

    final List<int> lazy = ilist.unlockLazy;
    lazy.add(4);
    expect(lazy, [1, 2, 3, 4]);
    expect(ilist, [1, 2, 3]);

    expect(const IList<int>.empty().unlockView, isEmpty);
    expect(const IList<int>.empty().unlockLazy..add(1), [1]);
  });

  test("Const lists | Add and remove return regular lists", () {
    const IList<int> ilist = IListConst<int>([1, 2]);
    expect(ilist.add(3), [1, 2, 3]);
    expect(ilist.addAll([3, 4]), [1, 2, 3, 4]);
    expect(ilist.remove(1), [2]);
    expect(ilist.remove(3), ilist);
    expect(ilist.removeMany(2), [1]);
    expect(ilist.clear(), isEmpty);
    expect(ilist.clear().config, ilist.config);
    expect(ilist.toggle(1), [2]);
    expect(ilist.toggle(3), [1, 2, 3]);

    const IList<int> empty = IList<int>.empty();
    expect(empty.add(1), [1]);
    expect(empty.addAll([1, 2]), [1, 2]);
    expect(empty.remove(1), isEmpty);
    expect(empty.clear(), same(empty));
    expect(empty.reversed, same(empty));
    expect(empty.flush, same(empty));
  });

  test("cached | Const lists compute the value each time", () {
    int computations = 0;
    final CacheKey<IList<int>, int> key = CacheKey<IList<int>, int>((IList<int> list) {
      computations++;
      return list.fold(0, (int a, int b) => a + b);
    });

    const IList<int> ilist = IListConst<int>([1, 2, 3]);
    expect(ilist.cached(key), 6);
    expect(ilist.cached(key), 6);
    expect(computations, 2);

    const IList<int> empty = IList<int>.empty();
    expect(empty.cached(key), 0);
    expect(computations, 3);

    // A regular list caches it.
    final IList<int> regular = [1, 2, 3].lock;
    expect(regular.cached(key), 6);
    expect(regular.cached(key), 6);
    expect(computations, 4);
  });

  test("toLinkedHashSet | Removing duplicates keeps the order of a non-flushed list", () {
    final IList<int> ilist = [3, 1].lock.add(3).addAll([2, 1]);
    expect(ilist.removeDuplicates(), [3, 1, 2]);
  });

  test("remove | removeAll | removeMany | Const and empty lists return the same instance", () {
    const IList<int> constList = IListConst([1, 2, 3]);
    expect(identical(constList.remove(4), constList), isTrue);
    expect(identical(constList.removeAll([4, 5]), constList), isTrue);
    expect(identical(constList.removeMany(4), constList), isTrue);
    expect(constList.remove(2), [1, 3]);

    const IList<int> empty = IList.empty();
    expect(identical(empty.remove(1), empty), isTrue);
    expect(identical(empty.removeAll([1]), empty), isTrue);
    expect(identical(empty.removeMany(1), empty), isTrue);
  });

  test("Identity equals | == and hashCode compare the IList object, and don't change when flushed",
      () {
    const ConfigList noCache = ConfigList(isDeepEquals: false, cacheHashCode: false);
    const ConfigList cache = ConfigList(isDeepEquals: false);

    // The hashCode doesn't change when flushed (even if not cached).
    final IList<int> ilist = IList.withConfig([1], noCache).add(2);
    final int hashCode = ilist.hashCode;
    final Set<IList<int>> set = {ilist};
    ilist.flush;
    expect(ilist.hashCode, hashCode);
    expect(set.contains(ilist), isTrue);

    // Auto-flush, just by reading the list.
    final IList<int> ilist2 = IList.withConfig([1], noCache).add(2);
    final Set<IList<int>> set2 = {ilist2};
    for (int i = 0; i < 600; i++) ilist2[0];
    expect(ilist2.isFlushed, isTrue);
    expect(set2.contains(ilist2), isTrue);

    // Different IList objects are not equal, even if they share the same internals.
    final IList<int> ilist3 = IList.withConfig([1], cache).add(2);
    final IList<int> sameInternals = ilist3.withConfig(noCache).withConfig(cache);
    expect(identical(ilist3, sameInternals), isFalse);
    expect(ilist3.same(sameInternals), isTrue);
    expect(ilist3 == sameInternals, isFalse);

    // The same IList object is always equal to itself.
    expect(ilist3 == ilist3, isTrue);
    ilist3.flush;
    expect(ilist3 == ilist3, isTrue);
    expect(IList.withConfig(ilist3, cache) == ilist3, isTrue);
  });
}

/// An iterable whose [length] is not the number of items it iterates.
class _WrongLengthIterable extends IterableBase<int> {
  final List<int> _items;
  final int reportedLength;

  _WrongLengthIterable(this._items, {required this.reportedLength});

  @override
  Iterator<int> get iterator => _items.iterator;

  @override
  int get length => reportedLength;
}
