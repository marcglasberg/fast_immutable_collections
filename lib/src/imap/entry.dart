// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:fast_immutable_collections/src/base/hash.dart";

extension FicIterableOfMapEntryExtension<K, V> on Iterable<MapEntry<K, V>> {
  /// [MapEntry] is **not** [Comparable].
  /// If you need to compare two iterables of [MapEntry] you can do this:
  ///
  /// expect(entries1.asComparableEntries, entries2.asComparableEntries);
  /// ```
  Iterable<Entry<K, V>> get asComparableEntries => map((entry) => entry.asComparableEntry);
}

extension FicMapEntryExtension<K, V> on MapEntry<K, V> {
  //
  /// [MapEntry] is **not** [Comparable].
  /// If you need it to be comparable, you can use this getter to turn
  /// it into an [Entry]. Using [Entry] makes testing easier. For example:
  ///
  /// ```dart
  /// MapEntry mapEntry = map.entries.first;
  ///
  /// // Does NOT work.
  /// expect(mapEntry, MapEntry("a", 1));
  ///
  /// // Works!
  /// expect(mapEntry.asComparableEntry, Entry("a", 1));
  /// ```
  ///
  /// Note another alternative is to use [containsPair] matcher in the map:
  ///
  /// ```dart
  /// // See [`containsPair` Matcher](https://pub.dev/documentation/matcher/latest/matcher/containsPair.html)
  /// expect(map, containsPair("a", 1));
  /// ```
  Entry<K, V> get asComparableEntry => Entry.from<K, V>(this);

  /// Compare the `key`s of the map entries, if they are [Comparable].
  /// If the `key`s are the same or not [Comparable], then compare the values,
  /// if they are [Comparable].
  /// If `key`s and values are the same or not [Comparable], return `0`.
  ///
  /// Note: This is not called "`compareTo`" as to not mislead people into thinking
  /// [MapEntry] is [Comparable].
  /// See: [Issue #32559 of the Dart SDK](https://github.com/dart-lang/sdk/issues/32559)
  /// and [Issue #100 of Dart's Matchers](https://github.com/dart-lang/matcher/issues/100).
  ///
  int compareKeyAndValue(MapEntry? other) => compareObject(this, other);

  String print([bool? prettyPrint]) {
    final String keyStr = (key is ImmutableCollection)
        ? (key as ImmutableCollection).toString(prettyPrint)
        : key.toString();
    final String valueStr = (value is ImmutableCollection)
        ? (value as ImmutableCollection).toString(prettyPrint)
        : value.toString();

    return "$keyStr: $valueStr";
  }
}

/// Similar to a [MapEntry], but correctly implements
/// equals ([==] comparing [key] and [value]), [hashcode] and [Comparable.compareTo].
class Entry<K, V> implements Comparable<Entry<K, V>> {
  final K key;
  final V value;

  const Entry(this.key, this.value);

  static Entry<K, V> from<K, V>(MapEntry<K, V> entry) => Entry(entry.key, entry.value);

  @override
  String toString() => "Entry($key: $value)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => hashObj2(key, value);

  @override
  int compareTo(Entry<K, V> other) {
    int result = compareObject(key, other.key);
    if (result == 0) result = compareObject(value, other.value);
    return result;
  }
}
