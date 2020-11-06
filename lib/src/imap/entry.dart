import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/base/hash.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  //

  /// [MapEntry] is not [Comparable].
  /// If you need it to be comparable, you can use this getter to turn
  /// it into an [Entry]. This makes testing easier. For example:
  ///
  ///     MapEntry mapEntry = map.entries.first;
  ///
  ///     // Does NOT work.
  ///     expect(mapEntry, MapEntry("a", 1));
  ///
  ///     // Works!
  ///     expect(mapEntry.asEntry, Entry("a", 1));
  ///
  ///  Note another alternative is to use [containsPair] matcher in the map:
  ///
  ///     // See https://pub.dev/documentation/matcher/latest/matcher/containsPair.html
  ///     expect(map, containsPair("a", 1));
  ///
  ///
  Entry<K, V> get asEntry => Entry.from<K, V>(this);

  static int compare(MapEntry a, MapEntry b) {
    if (a == null) {
      return b == null ? 0 : 1;
    } else if (b == null) return -1;

    int result = ImmutableCollection.compare(a.key, b.key);
    if (result == 0) result = ImmutableCollection.compare(a, b.value);
    return result;
  }

  /// Compare the keys of the map entries, if they are [Comparable].
  /// If the keys are the same or not [Comparable], then compare the values,
  /// if they are [Comparable].
  /// If keys and values are the same or not [Comparable], return 0.
  ///
  /// Note: This is not called "compareTo" as to not mislead people into thinking
  /// [MapEntry] is [Comparable]. See: https://github.com/dart-lang/sdk/issues/32559
  /// and https://github.com/dart-lang/matcher/issues/100
  ///
  int compareKeyAndValue(MapEntry other) => compare(this, other);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Similar to a [MapEntry], but correctly implements
/// equals ([==] comparing [key] and [value]), hashcode and [Comparable.compareTo].
class Entry<K, V> implements Comparable<Entry<K, V>> {
  final K key;
  final V value;

  const Entry(this.key, this.value);

  static Entry<K, V> from<K, V>(MapEntry<K, V> entry) => Entry(entry.key, entry.value);

  @override
  String toString() => "Entry(${key.toString()}: ${value.toString()})";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => hash2(key, value);

  @override
  int compareTo(Entry<K, V> other) {
    int result = ImmutableCollection.compare(key, other.key);
    if (result == 0) result = ImmutableCollection.compare(value, other.value);
    return result;
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
