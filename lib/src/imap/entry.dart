import "../utils/hash.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  //
  Entry<K, V> get entry => Entry.from<K, V>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Similar to a [MapEntry], but correctly implements
/// equals ([==] comparing [key] and [value]) and hashcode.
class Entry<K, V> {
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
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
