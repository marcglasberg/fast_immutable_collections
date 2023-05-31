// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections
// ignore_for_file: prefer_const_constructors, prefer_final_locals, prefer_final_in_for_each
import 'package:fast_immutable_collections/src/imap/imap.dart';
import "package:meta/meta.dart";
import "package:test/test.dart";

/// These tests are mainly for coverage purposes, it tests methods inside the [M] class which were
/// not reached by its implementations.
void main() {
  //
  test("keys", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    const List<String> keys = ["a", "b", "c"];
    expect(mExample.keys, keys.toSet());
  });

  test("values", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    const List<int> values = [1, 2, 3];
    expect(mExample.values, values.toSet());
  });

  test("isEmpty | isNotEmpty", () {
    expect(MExample().isEmpty, isTrue);
    expect(MExample({}).isEmpty, isTrue);
    expect(MExample<String, int>({}).isEmpty, isTrue);
    expect(MExample({"a": 1}).isEmpty, isFalse);

    expect(MExample().isNotEmpty, isFalse);
    expect(MExample({}).isNotEmpty, isFalse);
    expect(MExample<String, int>({}).isNotEmpty, isFalse);
    expect(MExample({"a": 1}).isNotEmpty, isTrue);
  });

  test("contains", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    expect(mExample.contains("a", 1), isTrue);
    expect(mExample.contains("a", 2), isFalse);
    expect(mExample.contains("b", 2), isTrue);
    expect(mExample.contains("b", 3), isFalse);
    expect(mExample.contains("c", 3), isTrue);
    expect(mExample.contains("c", 4), isFalse);
    expect(mExample.contains("z", 100), isFalse);
  });

  test("containsKey", () {
    final MExample<String?, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    expect(mExample.containsKey("a"), isTrue);
    expect(mExample.containsKey("z"), isFalse);
    expect(mExample.containsKey(null), isFalse);
  });

  test("containsValue", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    expect(mExample.containsValue(1), isTrue);
    expect(mExample.containsValue(100), isFalse);
    expect(mExample.containsValue(null), isFalse);
  });

  test("containsEntry", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    expect(mExample.containsEntry(MapEntry<String, int>("a", 1)), isTrue);
    expect(mExample.containsEntry(MapEntry<String, int>("a", 2)), isFalse);
    expect(mExample.containsEntry(MapEntry<String, int>("b", 1)), isFalse);
    expect(mExample.containsEntry(MapEntry<String, int>("z", 100)), isFalse);
  });

  test("everyEntry", () {
    final MExample<String, int> mExample = MExample({"a": 1, "b": 2, "c": 3});
    expect(mExample.everyEntry((MapEntry<String, int?> entry) => entry.value! < 4), isTrue);
    expect(mExample.everyEntry((MapEntry<String, int?> entry) => entry.key != "z"), isTrue);
    expect(mExample.everyEntry((MapEntry<String, int?> entry) => entry.value! > 10), isFalse);
    expect(mExample.everyEntry((MapEntry<String, int?> entry) => entry.key.length == 2), isFalse);
  });
}

@visibleForTesting
class MExample<K, V> extends M<K, V> {
  final IMap<K, V> _imap;

  MExample([Map<K, V>? map]) : _imap = IMap(map);

  @override
  V? operator [](K key) => _imap[key];

  /// This may be used to help avoid stack-overflow.
  @protected
  @override
  dynamic getVOrM(K key) => _imap[key];

  @override
  Iterable<MapEntry<K, V>> get entries => _imap.entries;

  @override
  int get length => _imap.length;

  @override
  Iterable<K> get keys => _imap.keys;

  @override
  Iterable<V> get values => _imap.values;

  @override
  Iterator<MapEntry<K, V>> get iterator => _imap.iterator;

  @override
  bool containsKey(K? key) => _imap.containsKey(key);

  @override
  bool containsValue(V? value) => _imap.containsValue(value);

  /// Used by tail-call-optimisation.
  /// Returns type [bool] or [M].
  @protected
  @override
  bool containsKeyOrM(K? key) => _imap.containsKey(key);
}
