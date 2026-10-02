// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
//
// Tests for IMap code paths which were not reached by the other IMap tests.
import "dart:collection";
import "dart:convert";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/imap/imap.dart";
import "package:test/test.dart";

enum _Fruit { apple, banana }

/// A key with no `toJson` method.
class _NotSerializable {
  @override
  String toString() => "NotSerializable";
}

/// A key whose `toJson` method returns an `int` (not a `String`).
class _NumericId {
  final int value;

  const _NumericId(this.value);

  int toJson() => value;
}

var _computeCount = 0;

final _countingLength = CacheKey<IMap<String, int>, int>((map) {
  _computeCount++;
  return map.length;
});

extension _CounterExtension on IMap {
  int get counter => InternalsForTestingPurposesIMap(this).counter;
}

void main() {
  setUp(() {
    ImmutableCollection.resetAllConfigurations();
    ImmutableCollection.autoFlush = false;
  });

  tearDown(() {
    ImmutableCollection.resetAllConfigurations();
  });

  group("IMapConst | identity equals:", () {
    test("hashCode | identity equals", () {
      const IMap<String, int> imap1 = IMapConst({"a": 1}, ConfigMap(isDeepEquals: false));
      const IMap<String, int> imap2 = IMapConst({"a": 1}, ConfigMap(isDeepEquals: false));
      const IMap<String, int> imap3 = IMapConst({"a": 2}, ConfigMap(isDeepEquals: false));

      expect(imap1.isIdentityEquals, isTrue);
      expect(imap1.hashCode, isA<int>());

      // Constants are canonicalized, so they share the same internal map.
      expect(identical(imap1, imap2), isTrue);
      expect(imap1 == imap2, isTrue);
      expect(imap1 == imap3, isFalse);

      // Same entries but different internal map instance: not equal by identity.
      expect(imap1 == IMap.withConfig({"a": 1}, ConfigMap(isDeepEquals: false)), isFalse);

      // Different config: not equal.
      expect(imap1 == const IMapConst<String, int>({"a": 1}), isFalse);

      // The hashCode is stable between calls, and consistent with ==.
      expect(imap1.hashCode, imap1.hashCode);
      expect(imap1.hashCode, imap2.hashCode);
      expect({imap1}.contains(imap2), isTrue);

      // Empty const maps are all equal to each other, so they must have the same hashCode.
      const IMap<String, int> empty1 = IMapConst({}, ConfigMap(isDeepEquals: false));
      const IMap<String, int> empty2 = IMapConst(<String, int>{}, ConfigMap(isDeepEquals: false));
      expect(empty1, empty2);
      expect(empty1.hashCode, empty2.hashCode);
    });

    test("hashCode | deep equals is consistent with equivalent maps", () {
      const IMap<String, int> imap1 = IMapConst({"a": 1, "b": 2});
      final IMap<String, int> imap2 = {"b": 2, "a": 1}.lock;
      final IMap<String, int> imap3 = {"a": 1}.lock.add("b", 2);

      expect(imap1.hashCode, imap1.hashCode);
      expect(imap1 == imap2, isTrue);
      expect(imap1.hashCode, imap2.hashCode);
      expect(imap1.hashCode, imap3.hashCode);
    });

    test("cached | IMapConst can't cache, so it computes every time", () {
      _computeCount = 0;
      const IMap<String, int> imap = IMapConst({"a": 1, "b": 2});

      expect(imap.cached(_countingLength), 2);
      expect(imap.cached(_countingLength), 2);
      expect(_computeCount, 2);

      // A regular IMap computes only once.
      _computeCount = 0;
      final IMap<String, int> regular = {"a": 1, "b": 2}.lock;
      expect(regular.cached(_countingLength), 2);
      expect(regular.cached(_countingLength), 2);
      expect(_computeCount, 1);
    });
  });

  group("Auto-flush counter in constant maps:", () {
    test("Reading from const IMap.empty() with autoFlush on", () {
      ImmutableCollection.autoFlush = true;
      const IMap<String, int> imap = IMap.empty();

      expect(imap.isFlushed, isTrue);
      expect(imap["a"], isNull);
      expect(imap.get("a"), isNull);
      expect(imap.contains("a", 1), isFalse);
      expect(imap.containsKey("a"), isFalse);
      expect(imap.containsValue(1), isFalse);
      expect(imap.counter, 0);
      expect(imap.isFlushed, isTrue);
    });

    test("Reading from const IMapConst with autoFlush on", () {
      ImmutableCollection.autoFlush = true;
      const IMap<String, int> imap = IMapConst({"a": 1, "b": 2});

      expect(imap.isFlushed, isTrue);
      expect(imap["a"], 1);
      expect(imap.get("b"), 2);
      expect(imap["z"], isNull);
      expect(imap.contains("a", 1), isTrue);
      expect(imap.contains("a", 2), isFalse);
      expect(imap.containsKey("b"), isTrue);
      expect(imap.containsKey("z"), isFalse);
      expect(imap.containsValue(2), isTrue);
      expect(imap.containsValue(3), isFalse);
      expect(imap.counter, 0);
      expect(imap.isFlushed, isTrue);
    });

    test("putIfAbsent and update on const maps with autoFlush on", () {
      ImmutableCollection.autoFlush = true;
      const IMap<String, int> empty = IMap.empty();
      const IMap<String, int> imap = IMapConst({"a": 1});

      // putIfAbsent
      final Output<int> output = Output();
      expect(identical(imap.putIfAbsent("a", () => 100, previousValue: output), imap), isTrue);
      expect(output.value, 1);
      expect(imap.putIfAbsent("b", () => 2).unlock, {"a": 1, "b": 2});
      expect(empty.putIfAbsent("x", () => 9).unlock, {"x": 9});

      // update
      expect(imap.update("a", (int value) => value + 1).unlock, {"a": 2});
      expect(identical(imap.update("z", (int value) => value + 1), imap), isTrue);
      expect(empty.update("z", (int value) => value, ifAbsent: () => 7).unlock, {"z": 7});

      // The const maps themselves are unchanged.
      expect(imap.unlock, {"a": 1});
      expect(empty.isEmpty, isTrue);
      expect(imap.counter, 0);
      expect(empty.counter, 0);
    });

    test("add to const maps with autoFlush on", () {
      ImmutableCollection.autoFlush = true;
      const IMap<String, int> empty = IMap.empty();
      const IMap<String, int> imap = IMapConst({"a": 1});

      final IMap<String, int> added1 = empty.add("a", 1);
      final IMap<String, int> added2 = imap.add("b", 2);

      expect(added1.unlock, {"a": 1});
      expect(added2.unlock, {"a": 1, "b": 2});

      // The result is not flushed, and its counter was incremented.
      expect(added2.isFlushed, isFalse);
      expect(added2.counter, 1);
    });
  });

  group("toEntrySet / toKeySet with compare:", () {
    test("toEntrySet | with compare", () {
      final IMap<String, int> imap = {"b": 2, "c": 3, "a": 1}.lock;

      final Set<MapEntry<String, int>> set =
          imap.toEntrySet(compare: (a, b) => b.key.compareTo(a.key));

      expect(set, isA<LinkedHashSet<MapEntry<String, int>>>());
      expect(set.map((entry) => entry.key), ["c", "b", "a"]);
      expect(set.map((entry) => entry.value), [3, 2, 1]);

      // Sorted by value, ascending.
      expect(
          imap
              .toEntrySet(compare: (a, b) => a.value.compareTo(b.value))
              .map((entry) => entry.asComparableEntry),
          [Entry("a", 1), Entry("b", 2), Entry("c", 3)]);

      // The compare function wins over the sort configuration.
      expect(
          imap
              .withConfig(ConfigMap(sort: true))
              .toEntrySet(compare: (a, b) => b.key.compareTo(a.key))
              .map((entry) => entry.key),
          ["c", "b", "a"]);
    });

    test("toEntrySet | with compare, in unflushed, const and empty maps", () {
      final IMap<String, int> unflushed = {"b": 2}.lock.add("a", 1).addAll({"c": 3}.lock);
      expect(unflushed.isFlushed, isFalse);
      expect(
          unflushed
              .toEntrySet(compare: (a, b) => a.key.compareTo(b.key))
              .map((entry) => entry.key),
          ["a", "b", "c"]);

      const IMap<String, int> constMap = IMapConst({"y": 1, "x": 2});
      expect(
          constMap
              .toEntrySet(compare: (a, b) => a.key.compareTo(b.key))
              .map((entry) => entry.key),
          ["x", "y"]);

      expect(
          const IMap<String, int>.empty().toEntrySet(compare: (a, b) => a.key.compareTo(b.key)),
          isEmpty);
    });

    test("toKeySet | with compare", () {
      final IMap<String, int> imap = {"b": 2, "c": 3, "a": 1}.lock;

      final Set<String> set = imap.toKeySet(compare: (a, b) => b.compareTo(a));
      expect(set, isA<LinkedHashSet<String>>());
      expect(set.toList(), ["c", "b", "a"]);

      expect(imap.toKeySet(compare: (a, b) => a.compareTo(b)).toList(), ["a", "b", "c"]);

      // The compare function wins over the sort configuration.
      expect(
          imap
              .withConfig(ConfigMap(sort: true))
              .toKeySet(compare: (a, b) => b.compareTo(a))
              .toList(),
          ["c", "b", "a"]);
    });

    test("toKeySet | with compare, in unflushed, const and empty maps", () {
      final IMap<int, String> unflushed = {3: "c"}.lock.add(1, "a").add(2, "b");
      expect(unflushed.isFlushed, isFalse);
      expect(unflushed.toKeySet(compare: (a, b) => a.compareTo(b)).toList(), [1, 2, 3]);

      const IMap<int, String> constMap = IMapConst({2: "b", 1: "a"});
      expect(constMap.toKeySet(compare: (a, b) => a.compareTo(b)).toList(), [1, 2]);

      expect(const IMap<int, String>.empty().toKeySet(compare: (a, b) => a.compareTo(b)), isEmpty);
    });

    test("toEntrySet / toKeySet | without compare keep the iteration order", () {
      final IMap<String, int> imap = {"b": 2, "c": 3, "a": 1}.lock;
      expect(imap.toKeySet().toList(), ["b", "c", "a"]);
      expect(imap.toEntrySet().map((entry) => entry.key), ["b", "c", "a"]);

      final IMap<String, int> sorted = imap.withConfig(ConfigMap(sort: true));
      expect(sorted.toKeySet().toList(), ["a", "b", "c"]);
      expect(sorted.toEntrySet().map((entry) => entry.key), ["a", "b", "c"]);
    });

    test("toValueSet | with and without compare", () {
      final IMap<String, int> imap = {"a": 2, "b": 3, "c": 1, "d": 3}.lock;

      // Without compare: same order as the values, without repetitions.
      expect(imap.toValueSet().toList(), [2, 3, 1]);

      // With compare: sorted.
      expect(imap.toValueSet(compare: (a, b) => a.compareTo(b)).toList(), [1, 2, 3]);
      expect(imap.toValueSet(compare: (a, b) => b.compareTo(a)).toList(), [3, 2, 1]);

      // Unflushed, const and empty maps.
      expect({"a": 2}.lock.add("b", 1).toValueSet(compare: (a, b) => a.compareTo(b)).toList(),
          [1, 2]);
      expect(const IMapConst({"a": 2, "b": 1}).toValueSet(compare: (a, b) => a.compareTo(b)).toList(),
          [1, 2]);
      expect(const IMap<String, int>.empty().toValueSet(compare: (a, b) => a.compareTo(b)), isEmpty);
    });
  });

  group("toString with sort:", () {
    test("toString | sort == true, prettyPrint == false", () {
      // Note: IMap.unsafe does not sort, so the entries are kept unsorted internally,
      // which proves toString itself sorts them.
      final IMap<String, int> imap =
          IMap.unsafe({"b": 2, "c": 3, "a": 1}, config: ConfigMap(sort: true));
      expect(imap.keys, ["b", "c", "a"]);

      expect(imap.toString(false), "{a: 1, b: 2, c: 3}");

      ImmutableCollection.prettyPrint = false;
      expect(imap.toString(), "{a: 1, b: 2, c: 3}");

      // A regularly created sorted map.
      expect(IMap.withConfig({"z": 26, "y": 25, "x": 24}, ConfigMap(sort: true)).toString(false),
          "{x: 24, y: 25, z: 26}");

      // Sorted maps with 0 and 1 entries.
      expect(IMap.withConfig(<String, int>{}, ConfigMap(sort: true)).toString(false), "{}");
      expect(IMap.withConfig({"a": 1}, ConfigMap(sort: true)).toString(false), "{a: 1}");
    });

    test("toString | sort == true, prettyPrint == true", () {
      final IMap<String, int> imap =
          IMap.unsafe({"b": 2, "c": 3, "a": 1}, config: ConfigMap(sort: true));

      const String expected = "{\n"
          "   a: 1,\n"
          "   b: 2,\n"
          "   c: 3\n"
          "}";

      expect(imap.toString(true), expected);

      ImmutableCollection.prettyPrint = true;
      expect(imap.toString(), expected);

      // Sorted maps with 0 and 1 entries.
      expect(IMap.withConfig(<String, int>{}, ConfigMap(sort: true)).toString(true), "{}");
      expect(IMap.withConfig({"a": 1}, ConfigMap(sort: true)).toString(true), "{a: 1}");
    });

    test("toString | sort == true, with nested immutable collections", () {
      final IMap<int, IList<int>> imap = IMap.unsafe({
        2: [3, 4].lock,
        1: [1, 2].lock,
      }, config: ConfigMap(sort: true));

      expect(imap.toString(false), "{1: [1, 2], 2: [3, 4]}");
    });
  });

  group("Json keys:", () {
    test("toJson | Enum keys are converted to their names", () {
      final IMap<_Fruit, int> imap = {_Fruit.banana: 2, _Fruit.apple: 1}.lock;
      final Object json = imap.toJson((key) => key, (value) => value);

      expect(json, {"banana": 2, "apple": 1});
      expect(jsonEncode(json), '{"banana":2,"apple":1}');

      // Round trip.
      expect(
          IMap<_Fruit, int>.fromJson(jsonDecode(jsonEncode(json)) as Map<String, Object?>,
              (key) => _Fruit.values.byName(key as String), (value) => value as int),
          imap);
    });

    test("toJson | Keys without a toJson method throw", () {
      final IMap<_NotSerializable, int> imap = {_NotSerializable(): 1}.lock;

      expect(
          () => imap.toJson((key) => key, (value) => value),
          throwsA(isA<Exception>().having((e) => e.toString(), "message",
              "Exception: IMap key NotSerializable of type _NotSerializable not serializable to/from json")));

      // An object without toJson also throws if returned by toJsonK.
      expect(() => {"a": 1}.lock.toJson((key) => Object(), (value) => value),
          throwsA(isA<Exception>()));
    });

    test("toJson | Keys whose toJson returns a non-String value", () {
      final IMap<_NumericId, String> imap = {_NumericId(7): "a", _NumericId(-1): "b"}.lock;
      expect(imap.toJson((key) => key, (value) => value), {"7": "a", "-1": "b"});
    });

    test("toJson | null keys", () {
      final IMap<String?, int> imap = {null: 1, "x": 2}.lock;
      final Object json = imap.toJson((key) => key, (value) => value);

      expect(json, {"null": 1, "x": 2});
      expect(jsonEncode(json), '{"null":1,"x":2}');

      // A toJsonK which returns null also generates the "null" key.
      expect({"a": 1}.lock.toJson((key) => null, (value) => value), {"null": 1});
    });

    test("fromJson | The 'null' key with a nullable key type becomes the null key", () {
      final List<Object?> received = [];
      final IMap<String?, int> imap = IMap<String?, int>.fromJson({"null": 1, "x": 2}, (key) {
        received.add(key);
        return key as String?;
      }, (value) => value as int);

      expect(imap.containsKey(null), isTrue);
      expect(imap.containsKey("null"), isFalse);
      expect(imap[null], 1);
      expect(imap["x"], 2);
      expect(received, [null, "x"]);

      // Nullable int keys.
      final IMap<int?, String> imap2 = IMap<int?, String>.fromJson(
          {"null": "a", "3": "b"}, (key) => key as int?, (value) => value as String);
      expect(imap2.unlock, {null: "a", 3: "b"});

      // Round trip.
      final IMap<String?, int> original = {null: 1, "x": 2}.lock;
      expect(
          IMap<String?, int>.fromJson(
              original.toJson((key) => key, (value) => value) as Map<String, Object?>,
              (key) => key as String?,
              (value) => value as int),
          original);
    });

    test("fromJson | The 'null' key with a non-nullable key type is a regular string key", () {
      final IMap<String, int> imap =
          IMap<String, int>.fromJson({"null": 1}, (key) => key as String, (value) => value as int);

      expect(imap.containsKey("null"), isTrue);
      expect(imap["null"], 1);
      expect(imap.length, 1);
    });

    test("fromJson | fromJsonK fails with the parsed key, but works with the key string", () {
      final List<Object?> received = [];
      final IMap<int, String> imap = IMap<int, String>.fromJson({"1": "a", "-20": "b"}, (key) {
        received.add(key);
        return int.parse(key as String);
      }, (value) => value as String);

      expect(imap.unlock, {1: "a", -20: "b"});
      // Called first with the parsed int, then with the original string.
      expect(received, [1, "1", -20, "-20"]);

      // Also for bool keys.
      expect(
          IMap<bool, String>.fromJson({"true": "yes", "false": "no"},
              (key) => (key as String) == "true", (value) => value as String).unlock,
          {true: "yes", false: "no"});

      // Also for double keys.
      expect(
          IMap<double, String>.fromJson(
              {"1.5": "a"}, (key) => double.parse(key as String), (value) => value as String).unlock,
          {1.5: "a"});
    });

    test("fromJson | fromJsonK fails both with the parsed key and the key string", () {
      final List<Object?> received = [];
      expect(
          () => IMap<int, String>.fromJson({"1": "a"}, (key) {
                received.add(key);
                if (key is int) throw ArgumentError("parsed");
                throw StateError("string");
              }, (value) => value as String),
          // The original error (from the parsed key) is rethrown.
          throwsA(isA<ArgumentError>().having((e) => e.message, "message", "parsed")));

      expect(received, [1, "1"]);
    });

    test("fromJson | Keys that can't be parsed to the primitive type use the key string", () {
      final List<Object?> received = [];
      expect(
          () => IMap<int, String>.fromJson({"abc": "a"}, (key) {
                received.add(key);
                return (key as num).toInt();
              }, (value) => value as String),
          throwsA(isA<TypeError>()));
      expect(received, ["abc"]);
    });

    test("fromJson | num keys", () {
      final IMap<num, String> imap = IMap<num, String>.fromJson(
          {"1": "a", "1.5": "b", "-3": "c"}, (key) => key as num, (value) => value as String);

      expect(imap.unlock, {1: "a", 1.5: "b", -3: "c"});
      expect(imap.keys.map((key) => key.runtimeType), [int, double, int]);

      // Nullable num keys.
      final IMap<num?, String> imap2 = IMap<num?, String>.fromJson(
          {"null": "a", "2.5": "b"}, (key) => key as num?, (value) => value as String);
      expect(imap2.unlock, {null: "a", 2.5: "b"});

      // Round trip.
      final IMap<num, String> original = {1: "a", 2.5: "b"}.lock;
      expect(
          IMap<num, String>.fromJson(
              jsonDecode(jsonEncode(original.toJson((key) => key, (value) => value)))
                  as Map<String, Object?>,
              (key) => key as num,
              (value) => value as String),
          original);
    });

    test("toJson / fromJson | empty maps", () {
      expect(const IMap<String, int>.empty().toJson((key) => key, (value) => value), {});
      expect(IMap<String, int>.fromJson({}, (key) => key as String, (value) => value as int),
          const IMap<String, int>.empty());
    });
  });

  group("equalItemsToIMap:", () {
    test("equalItemsToIMap | equal and different items", () {
      final IMap<String, int> imap = {"a": 1, "b": 2}.lock;

      expect(imap.equalItemsToIMap({"a": 1, "b": 2}.lock), isTrue);
      expect(imap.equalItemsToIMap({"b": 2, "a": 1}.lock), isTrue);
      expect(imap.equalItemsToIMap({"a": 1, "b": 3}.lock), isFalse);
      expect(imap.equalItemsToIMap({"a": 1}.lock), isFalse);
      expect(imap.equalItemsToIMap({"a": 1, "b": 2, "c": 3}.lock), isFalse);
      expect(imap.equalItemsToIMap(const IMap.empty()), isFalse);
      expect(const IMap<String, int>.empty().equalItemsToIMap(IMap()), isTrue);
    });

    test("equalItemsToIMap | unflushed and const maps", () {
      final IMap<String, int> unflushed = {"a": 1}.lock.add("b", 2);
      const IMap<String, int> constMap = IMapConst({"b": 2, "a": 1});

      expect(unflushed.equalItemsToIMap(constMap), isTrue);
      expect(constMap.equalItemsToIMap(unflushed), isTrue);
      expect(constMap.equalItemsToIMap({"a": 1}.lock.add("b", 3)), isFalse);
    });

    test("equalItemsToIMap | items differ, with cached hashCodes", () {
      final IMap<String, int> imap1 = {"a": 1, "b": 2}.lock;
      final IMap<String, int> imap2 = {"a": 1, "b": 3}.lock;

      // Caches the hashCodes.
      expect(imap1.hashCode, isNot(imap2.hashCode));

      expect(imap1.equalItemsToIMap(imap2), isFalse);
      expect(imap2.equalItemsToIMap(imap1), isFalse);
    });

    test("equalItemsToIMap | items are equal, with cached hashCodes", () {
      final IMap<String, int> imap1 = {"a": 1, "b": 2}.lock;
      final IMap<String, int> imap2 = {"b": 2, "a": 1}.lock;

      expect(imap1.hashCode, imap2.hashCode);

      expect(imap1.equalItemsToIMap(imap2), isTrue);
    });

    test("equalItemsToIMap | Ignores the config, even after the hashCodes are calculated", () {
      final IMap<String, int> sorted = IMap.withConfig({"a": 1}, ConfigMap(sort: true));
      final IMap<String, int> notSorted = IMap.withConfig({"a": 1}, ConfigMap(sort: false));
      final IMap<String, int> identity = IMap.withConfig({"a": 1}, ConfigMap(isDeepEquals: false));
      const IMap<String, int> constMap = IMapConst({"a": 1}, ConfigMap(cacheHashCode: false));

      expect(sorted.equalItemsToIMap(notSorted), isTrue);
      expect(sorted.equalItemsToIMap(identity), isTrue);
      expect(sorted.equalItemsToIMap(constMap), isTrue);

      sorted.hashCode;
      notSorted.hashCode;
      identity.hashCode;

      expect(sorted.equalItemsToIMap(notSorted), isTrue);
      expect(notSorted.equalItemsToIMap(sorted), isTrue);
      expect(sorted.equalItemsToIMap(identity), isTrue);
      expect(identity.equalItemsToIMap(sorted), isTrue);
      expect(sorted.equalItemsToIMap(constMap), isTrue);
      expect(constMap.equalItemsToIMap(sorted), isTrue);
    });

    test("equalItemsAndConfig | Identity equals with equal items but different internals", () {
      final IMap<String, int> imap1 = IMap.withConfig({"a": 1}, ConfigMap(isDeepEquals: false));
      final IMap<String, int> imap2 = IMap.withConfig({"a": 1}, ConfigMap(isDeepEquals: false));
      expect(imap1 == imap2, isFalse);
      expect(imap1.equalItemsAndConfig(imap2), isTrue);

      imap1.hashCode;
      imap2.hashCode;
      expect(imap1.equalItemsAndConfig(imap2), isTrue);
    });
  });

  group("length:", () {
    test("length | Flushes an unflushed empty map", () {
      // Adding two empty maps creates an unflushed empty map.
      final IMap<String, int> imap = IMap<String, int>().addAll(IMap<String, int>());
      expect(imap.isFlushed, isFalse);

      expect(imap.length, 0);
      expect(imap.isFlushed, isTrue);
      expect(imap.isEmpty, isTrue);
      expect(imap.unlock, <String, int>{});
      expect(imap, const IMap<String, int>.empty());

      // It's still possible to add to it.
      expect(imap.add("a", 1).unlock, {"a": 1});
    });

    test("length | Does not flush an unflushed non-empty map", () {
      final IMap<String, int> imap = {"a": 1}.lock.add("b", 2);
      expect(imap.isFlushed, isFalse);
      expect(imap.length, 2);
      expect(imap.isFlushed, isFalse);
    });

    test("length | const maps", () {
      expect(const IMap<String, int>.empty().length, 0);
      expect(const IMapConst<String, int>({}).length, 0);
      expect(const IMapConst<String, int>({"a": 1, "b": 2}).length, 2);
    });
  });

  group("cast:", () {
    test("cast | flushed map to the same type", () {
      final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
      final IMap<String, int> casted = imap.cast<String, int>();
      expect(casted, isA<IMap<String, int>>());
      expect(casted.unlock, {"a": 1, "b": 2});
      expect(casted, imap);
      expect(identical(casted, imap), isTrue);
    });

    test("cast | unflushed map to the same type, or to a supertype, returns it unchanged", () {
      final IMap<String, int> imap = {"a": 1}.lock.add("b", 2);
      expect(imap.isFlushed, isFalse);

      final IMap<String, int> casted = imap.cast<String, int>();
      expect(identical(casted, imap), isTrue);
      expect(casted.unlock, {"a": 1, "b": 2});

      final IMap<Object, num> casted2 = imap.cast<Object, num>();
      expect(identical(casted2, imap), isTrue);
    });

    test("cast | unflushed map to a subtype", () {
      final IMap<String, num> imap = <String, num>{"a": 1}.lock.add("b", 2);
      expect(imap.isFlushed, isFalse);

      final IMap<String, int> casted = imap.cast<String, int>();
      expect(casted, isA<IMap<String, int>>());
      expect(casted.unlock, {"a": 1, "b": 2});
      expect(casted["b"], 2);

      // Can't be read if the values are not of the right type.
      final IMap<String, num> withDouble = imap.add("c", 1.5);
      expect(() => withDouble.cast<String, int>()["c"], throwsA(isA<TypeError>()));
    });

    test("cast | const maps", () {
      const IMap<String, int> imap = IMapConst({"a": 1});
      final IMap<String, num> casted = imap.cast<String, num>();
      expect(casted, isA<IMap<String, num>>());
      expect(casted["a"], 1);
      expect(casted.config, imap.config);

      final IMap<Object, Object> casted2 = const IMap<String, int>.empty().cast<Object, Object>();
      expect(casted2, isA<IMap<Object, Object>>());
      expect(casted2.isEmpty, isTrue);
    });

    test("cast | keeps the config", () {
      final IMap<String, int> imap =
          IMap.withConfig({"b": 2, "a": 1}, ConfigMap(sort: true, isDeepEquals: false));
      final IMap<String, num> casted = imap.cast<String, num>();
      expect(casted.config, ConfigMap(sort: true, isDeepEquals: false));
      expect(casted.keys, ["a", "b"]);
    });
  });

  group("map / updateAll:", () {
    test("map | without config uses the default config", () {
      final IMap<String, int> imap = {"b": 1, "a": 2}.lock;
      final IMap<int, String> mapped = imap.map((String key, int value) => MapEntry(value, key));

      expect(mapped.config, IMap.defaultConfig);
      expect(mapped.keys, [1, 2]);
      expect(mapped.values, ["b", "a"]);

      // When the default config is sorted, the result is sorted.
      final IMap<String, int> source = {"b": 2, "a": 1}.lock;
      IMap.defaultConfig = ConfigMap(sort: true);
      try {
        final IMap<int, String> mapped2 =
            source.map((String key, int value) => MapEntry(value * 10, key));
        expect(mapped2.config.sort, isTrue);
        expect(mapped2.keys, [10, 20]);
        expect(mapped2.values, ["a", "b"]);
      } finally {
        IMap.defaultConfig = const ConfigMap();
      }

      // Empty map.
      expect(const IMap<String, int>.empty().map((key, value) => MapEntry(value, key)).isEmpty,
          isTrue);
    });

    test("updateAll | with ifRemove", () {
      final IMap<String, int> imap = {"a": 1, "b": 2, "c": 3}.lock;

      expect(
          imap
              .updateAll((String key, int value) => value * 10,
                  ifRemove: (String key, int value) => value > 15)
              .unlock,
          {"a": 10});

      // Can remove everything.
      expect(
          imap.updateAll((key, value) => value, ifRemove: (key, value) => true).isEmpty, isTrue);

      // Removes nothing.
      expect(imap.updateAll((key, value) => -value, ifRemove: (key, value) => false).unlock,
          {"a": -1, "b": -2, "c": -3});

      // The original map is unchanged.
      expect(imap.unlock, {"a": 1, "b": 2, "c": 3});

      // Unflushed and const maps.
      expect(
          {"a": 1}
              .lock
              .add("b", 2)
              .updateAll((key, value) => value + 1, ifRemove: (key, value) => key == "a")
              .unlock,
          {"b": 3});
      expect(
          const IMapConst<String, int>({"x": 5, "y": 6})
              .updateAll((key, value) => value, ifRemove: (key, value) => value.isOdd)
              .unlock,
          {"y": 6});
    });
  });

  group("Conversions with config:", () {
    test("toEntryIList / toKeyIList / toValueIList | with config", () {
      final IMap<String, int> imap = {"b": 2, "a": 1}.lock;
      const ConfigList configList = ConfigList(isDeepEquals: false);

      final IList<MapEntry<String, int>> entries = imap.toEntryIList(config: configList);
      expect(entries.config, configList);
      expect(entries.map((entry) => entry.key), ["b", "a"]);

      final IList<String> keys = imap.toKeyIList(config: configList);
      expect(keys.config, configList);
      expect(keys, ["b", "a"]);

      final IList<int> values = imap.toValueIList(config: configList);
      expect(values.config, configList);
      expect(values, [2, 1]);

      // Without config, the default list config is used.
      expect(imap.toKeyIList().config, IList.defaultConfig);
    });

    test("toEntryISet / toKeyISet / toValueISet | with config", () {
      final IMap<String, int> imap = {"b": 2, "a": 1, "c": 3}.lock;
      const ConfigSet configSet = ConfigSet(sort: true);

      final ISet<MapEntry<String, int>> entries = imap.toEntryISet(config: configSet);
      expect(entries.config, configSet);
      expect(entries.map((entry) => entry.key), ["a", "b", "c"]);

      final ISet<String> keys = imap.toKeyISet(config: configSet);
      expect(keys.config, configSet);
      expect(keys.toList(), ["a", "b", "c"]);

      final ISet<int> values = imap.toValueISet(config: configSet);
      expect(values.config, configSet);
      expect(values.toList(), [1, 2, 3]);

      // Without config, the default set config is used.
      expect(imap.toKeyISet().config, ISet.defaultConfig);
      expect(imap.toKeyISet().toList(), ["b", "a", "c"]);
    });

    test("unlockSorted | sorted config", () {
      final IMap<String, int> imap = IMap.withConfig({"c": 3, "a": 1, "b": 2}, ConfigMap(sort: true));
      final Map<String, int> map = imap.unlockSorted;
      expect(map, isA<LinkedHashMap<String, int>>());
      expect(map.keys, ["a", "b", "c"]);

      // It's a mutable copy.
      map["d"] = 4;
      expect(imap.containsKey("d"), isFalse);
    });

    test("unlockSorted | not sorted config", () {
      final IMap<String, int> imap =
          IMap.withConfig({"c": 3, "a": 1, "b": 2}, ConfigMap(sort: false));
      expect(imap.keys, ["c", "a", "b"]);
      expect(imap.unlockSorted.keys, ["a", "b", "c"]);
      expect(imap.unlockSorted.values, [1, 2, 3]);

      // Unflushed and const maps.
      expect(imap.add("0", 0).unlockSorted.keys, ["0", "a", "b", "c"]);
      expect(const IMapConst({"b": 2, "a": 1}).unlockSorted.keys, ["a", "b"]);
      expect(const IMap<String, int>.empty().unlockSorted, isEmpty);
    });
  });

  group("Other methods in unflushed and const maps:", () {
    test("entry / entryOrNull", () {
      final IMap<String, int?> unflushed = <String, int?>{"a": 1}.lock.add("b", null);
      expect(unflushed.entry("a").asComparableEntry, Entry<String, int?>("a", 1));
      expect(unflushed.entry("b").asComparableEntry, Entry<String, int?>("b", null));
      expect(unflushed.entry("z").asComparableEntry, Entry<String, int?>("z", null));
      expect(unflushed.entryOrNull("a")!.asComparableEntry, Entry<String, int?>("a", 1));
      expect(unflushed.entryOrNull("z"), isNull);

      const IMap<String, int> constMap = IMapConst({"a": 1});
      expect(constMap.entry("a").asComparableEntry, Entry<String, int?>("a", 1));
      expect(constMap.entryOrNull("a")!.asComparableEntry, Entry<String, int>("a", 1));
      expect(constMap.entryOrNull("z"), isNull);
      expect(const IMap<String, int>.empty().entryOrNull("a"), isNull);
    });

    test("entryOrNull | key present with a null value", () {
      final IMap<String, int?> imap = <String, int?>{"a": null, "b": 2}.lock;
      final MapEntry<String, int?>? entry = imap.entryOrNull("a");
      expect(entry, isNotNull);
      expect(entry!.key, "a");
      expect(entry.value, isNull);
      expect(imap.entryOrNull("b")!.value, 2);
      expect(imap.entryOrNull("z"), isNull);

      // Unflushed map.
      expect(imap.add("c", null).entryOrNull("c")!.value, isNull);
    });

    test("removeWhere | returns the same instance when nothing is removed", () {
      final IMap<String, int> imap = {"a": 1, "b": 2}.lock;
      expect(identical(imap.removeWhere((key, value) => value > 10), imap), isTrue);

      final IMap<String, int> unflushed = imap.add("c", 3);
      expect(identical(unflushed.removeWhere((key, value) => false), unflushed), isTrue);
      expect(unflushed.removeWhere((key, value) => value.isOdd).unlock, {"b": 2});

      const IMap<String, int> constMap = IMapConst({"a": 1, "b": 2});
      expect(constMap.removeWhere((key, value) => false).unlock, {"a": 1, "b": 2});
      expect(constMap.removeWhere((key, value) => key == "a").unlock, {"b": 2});
      expect(constMap.unlock, {"a": 1, "b": 2});
    });

    test("withIdentityEquals / withDeepEquals | const maps", () {
      const IMap<String, int> constMap = IMapConst({"a": 1});

      final IMap<String, int> identityMap = constMap.withIdentityEquals;
      expect(identityMap.isIdentityEquals, isTrue);
      expect(identityMap.unlock, {"a": 1});
      expect(identical(identityMap.withIdentityEquals, identityMap), isTrue);

      final IMap<String, int> deepMap = identityMap.withDeepEquals;
      expect(deepMap.isDeepEquals, isTrue);
      expect(deepMap, constMap);
      expect(identical(constMap.withDeepEquals, constMap), isTrue);
    });

    test("anyEntry / everyEntry / any | empty and unflushed maps", () {
      const IMap<String, int> empty = IMap.empty();
      expect(empty.any((key, value) => true), isFalse);
      expect(empty.anyEntry((entry) => true), isFalse);
      expect(empty.everyEntry((entry) => false), isTrue);

      final IMap<String, int> unflushed = {"a": 1}.lock.add("b", 2);
      expect(unflushed.any((key, value) => key == "b" && value == 2), isTrue);
      expect(unflushed.anyEntry((entry) => entry.value > 5), isFalse);
      expect(unflushed.everyEntry((entry) => entry.value > 0), isTrue);
    });
  });

  group("Map extensions:", () {
    test("FicMapOfSetsExtension | lock", () {
      final IMapOfSets<String, int> imapOfSets = {
        "a": {1, 2},
        "b": {3},
      }.lock;

      expect(imapOfSets, isA<IMapOfSets<String, int>>());
      expect(imapOfSets.config, IMapOfSets.defaultConfig);
      expect(imapOfSets.get("a"), {1, 2});
      expect(imapOfSets.get("b"), {3});
      expect(imapOfSets.unlock, {
        "a": {1, 2},
        "b": {3},
      });
    });

    test("FicMapOfSetsExtension | toIMapOfSets", () {
      final Map<String, Set<int>> map = {
        "a": {1, 2},
        "b": {3},
      };

      final IMapOfSets<String, int>? imapOfSets1 = map.toIMapOfSets();
      expect(imapOfSets1!.config, IMapOfSets.defaultConfig);
      expect(imapOfSets1.get("a"), {1, 2});

      const ConfigMapOfSets config = ConfigMapOfSets(isDeepEquals: false, sortKeys: true);
      final IMapOfSets<String, int>? imapOfSets2 = map.toIMapOfSets(config);
      expect(imapOfSets2!.config, config);
      expect(imapOfSets2.get("b"), {3});

      // It's a copy.
      map["a"]!.add(100);
      expect(imapOfSets1.get("a"), {1, 2});
    });

    test("FicMapIteratorExtension | toIterable", () {
      final IMap<String, int> imap = {"a": 1}.lock.add("b", 2);

      final Iterable<MapEntry<String, int>> iterable = imap.iterator.toIterable();
      expect(iterable.map((entry) => entry.asComparableEntry), [Entry("a", 1), Entry("b", 2)]);

      expect(const IMap<String, int>.empty().iterator.toIterable(), isEmpty);
      expect(<String, int>{"x": 9}.entries.iterator.toIterable().single.key, "x");
    });
  });

  test("remove | removeWhere | Const and empty maps return the same instance", () {
    const IMap<String, int> constMap = IMapConst({"a": 1, "b": 2});
    expect(identical(constMap.remove("z"), constMap), isTrue);
    expect(identical(constMap.removeWhere((k, v) => false), constMap), isTrue);
    expect(constMap.remove("a").unlock, {"b": 2});
    expect(constMap.removeWhere((k, v) => v == 2).unlock, {"a": 1});

    const IMap<String, int> empty = IMap.empty();
    expect(identical(empty.remove("z"), empty), isTrue);
    expect(identical(empty.removeWhere((k, v) => true), empty), isTrue);
  });

  test("Identity equals | == and hashCode compare the IMap object, and don't change when flushed",
      () {
    const ConfigMap noCache = ConfigMap(isDeepEquals: false, cacheHashCode: false);
    const ConfigMap cache = ConfigMap(isDeepEquals: false);

    final IMap<String, int> imap = IMap.withConfig({"a": 1}, noCache).add("b", 2);
    final int hashCode = imap.hashCode;
    final Set<IMap<String, int>> set = {imap};
    imap.flush;
    expect(imap.hashCode, hashCode);
    expect(set.contains(imap), isTrue);

    // Different IMap objects are not equal, even if they share the same internals.
    final IMap<String, int> imap2 = IMap.withConfig({"a": 1}, cache).add("b", 2);
    final IMap<String, int> sameInternals = imap2.withConfig(noCache).withConfig(cache);
    expect(identical(imap2, sameInternals), isFalse);
    expect(imap2 == sameInternals, isFalse);

    expect(imap2 == imap2, isTrue);
    imap2.flush;
    expect(imap2 == imap2, isTrue);
  });
}
