import 'dart:collection';
import 'package:fast_immutable_collections/src/imap/m_replace.dart';
import 'package:meta/meta.dart';
import '../../fast_immutable_collections.dart';
import 'm_add.dart';
import 'm_add_all.dart';
import 'm_flat.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  //
  Entry<K, V> get entry => Entry.from<K, V>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Similar to a [MapEntry], but correctly implements
/// equals comparing key and value.
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
  int get hashCode => key.hashCode ^ value.hashCode;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension IMapExtension<K, V> on Map<K, V> {
  //
  /// Locks the map, returning an *immutable* map ([IMap]).
  IMap<K, V> get lock => IMap<K, V>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An *immutable* unordered map.
@immutable
class IMap<K, V> // ignore: must_be_immutable
    extends ImmutableCollection<IMap<K, V>> {
  //

  M<K, V> _m;

  /// If given, will be used to sort list of keys or lists of entries.
  final int Function(K, K) compareKey;

  /// If given, will be used to sort list of values.
  final int Function(V, V) compareValue;

  /// If `false` (the default), the equals operator (`==`) compares by identity.
  /// If `true`, the equals operator (`==`) compares all items, unordered.
  final bool isDeepEquals;

  bool get isIdentityEquals => !isDeepEquals;

  static IMap<K, V> empty<K, V>() => IMap.__(
        MFlat.empty<K, V>(),
        isDeepEquals: defaultIsDeepEquals,
        compareKey: null,
        compareValue: null,
      );

  factory IMap([Map<K, V> map]) => (map == null || map.isEmpty)
      ? IMap.empty<K, V>()
      : IMap<K, V>.__(
          MFlat<K, V>(map),
          isDeepEquals: defaultIsDeepEquals,
          compareKey: null,
          compareValue: null,
        );

  factory IMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    if (entries is IMap<K, V>)
      return IMap.__(
        (entries as IMap<K, V>)._m,
        isDeepEquals: defaultIsDeepEquals,
        compareKey: null,
        compareValue: null,
      );
    else {
      var map = HashMap<K, V>();
      map.addEntries(entries);
      return IMap.__(
        MFlat.unsafe(map),
        isDeepEquals: defaultIsDeepEquals,
        compareKey: null,
        compareValue: null,
      );
    }
  }

  factory IMap.fromKeys({
    @required Iterable<K> keys,
    @required V Function(K) valueMapper,
  }) {
    assert(keys != null);
    assert(valueMapper != null);

    var map = HashMap<K, V>();

    for (K key in keys) {
      map[key] = valueMapper(key);
    }

    return IMap._map(
      map,
      isDeepEquals: defaultIsDeepEquals,
      compareKey: null,
      compareValue: null,
    );
  }

  factory IMap.fromValues({
    @required K Function(V) keyMapper,
    @required Iterable<V> values,
  }) {
    assert(keyMapper != null);
    assert(values != null);

    var map = HashMap<K, V>();

    for (V value in values) {
      map[keyMapper(value)] = value;
    }

    return IMap._map(
      map,
      isDeepEquals: defaultIsDeepEquals,
      compareKey: null,
      compareValue: null,
    );
  }

  factory IMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic) keyMapper,
    V Function(dynamic) valueMapper,
  }) {
    Map<K, V> map = Map.fromIterable(iterable, key: keyMapper, value: valueMapper);
    return IMap._map(
      map,
      isDeepEquals: defaultIsDeepEquals,
      compareKey: null,
      compareValue: null,
    );
  }

  factory IMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    Map<K, V> map = Map.fromIterables(keys, values);
    return IMap._map(
      map,
      isDeepEquals: defaultIsDeepEquals,
      compareKey: null,
      compareValue: null,
    );
  }

  /// Unsafe.
  IMap._map(
    Map<K, V> map, {
    @required this.isDeepEquals,
    @required this.compareKey,
    @required this.compareValue,
  }) : _m = MFlat<K, V>.unsafe(map);

  /// Unsafe.
  IMap.__(
    this._m, {
    @required this.isDeepEquals,
    @required this.compareKey,
    @required this.compareValue,
  });

  IMap<K, V> config({
    int Function(K, K) compareKey,
    int Function(V, V) compareValue,
    bool isDeepEquals,
  }) =>
      IMap.__(
        _m,
        compareKey: compareKey ?? this.compareKey,
        compareValue: compareValue ?? this.compareValue,
        isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      );

  Iterable<MapEntry<K, V>> get entries => _m.entries;

  Iterable<K> get keys => _m.keys;

  Iterable<V> get values => _m.values;

  /// Order is undefined.
  IList<MapEntry<K, V>> get entryList => IList(entries);

  ISet<MapEntry<K, V>> get entrySet => ISet(entries);

  /// Order is undefined.
  IList<K> get keyList => IList(keys);

  ISet<K> get keySet => ISet(keys);

  /// Order is undefined.
  IList<V> get valueList => IList(values);

  Iterator<MapEntry<K, V>> get iterator => _m.iterator;

  /// Convert this map to identityEquals (compares by identity).
  IMap<K, V> get identityEquals => isDeepEquals
      ? IMap.__(
          _m,
          isDeepEquals: false,
          compareKey: compareKey,
          compareValue: compareValue,
        )
      : this;

  /// Convert this map to deepEquals (compares all map entries).
  IMap<K, V> get deepEquals => isDeepEquals
      ? this
      : IMap.__(
          _m,
          isDeepEquals: true,
          compareKey: compareKey,
          compareValue: compareValue,
        );

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock => _m.unlock;

  bool get isEmpty => _m.isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  bool operator ==(Object other) => (other is IMap<K, V>)
      ? isDeepEquals
          ? equals(other)
          : same(other)
      : false;

  @override
  bool equals(IMap<K, V> other) =>
      identical(this, other) ||
      other is IMap<K, V> &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          compareKey == other.compareKey &&
          compareValue == other.compareValue &&
          (flush._m as MFlat<K, V>).deepMapEquals(other.flush._m as MFlat<K, V>);

  @override
  bool same(IMap<K, V> other) =>
      identical(_m, other._m) &&
      isDeepEquals == other.isDeepEquals &&
      compareKey == other.compareKey &&
      compareValue == other.compareValue;

  @override
  int get hashCode => isDeepEquals //
      ? (flush._m as MFlat<K, V>).deepMapHashcode()
      : identityHashCode(_m);

  /// Compacts the list.
  IMap<K, V> get flush {
    if (!isFlushed) _m = MFlat<K, V>.unsafe(unlock);
    return this;
  }

  bool get isFlushed => _m is MFlat;

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> add(K key, V value) => IMap<K, V>.__(
        _m.add(key: key, value: value),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntry(MapEntry<K, V> entry) => IMap<K, V>.__(
        _m.add(key: entry.key, value: entry.value),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addAll(IMap<K, V> iMap) => IMap<K, V>.__(
        _m.addAll(iMap),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addMap(Map<K, V> map) => IMap<K, V>.__(
        _m.addMap(map),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  /// Returns a new map containing the current map plus the given map entries.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntries(Iterable<MapEntry<K, V>> entries) => IMap<K, V>.__(
        _m.addEntries(entries),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  /// Returns a new map containing the current map minus the given key and its value.
  /// However, if the current map doesn't contain the key,
  /// it will return the current map (same instance).
  IMap<K, V> remove(K key) {
    M<K, V> result = _m.remove(key);
    if (identical(result, _m))
      return this;
    else
      return IMap<K, V>.__(
        result,
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );
  }

  V operator [](K k) => _m[k];

  V get(K k) => _m[k];

  bool any(bool Function(K key, V value) test) => _m.any(test);

  // TODO: Falta verificar. O `cast` do `M` está retornando um `Map`, é isso mesmo que queremos?
  IMap<RK, RV> cast<RK, RV>() => IMap._map(
        _m.cast<RK, RV>(),
        isDeepEquals: isDeepEquals,
        compareKey: null,
        compareValue: null,
      );

  bool anyEntry(bool Function(MapEntry<K, V>) test) => _m.anyEntry(test);

  bool contains(K key, V value) => _m.contains(key, value);

  bool containsKey(K key) => _m.containsKey(key);

  bool containsValue(V value) => _m.containsValue(value);

  bool containsEntry(MapEntry<K, V> entry) => _m.contains(entry.key, entry.value);

  /// Order is undefined.
  List<MapEntry<K, V>> toList() => List.of(entries);

  /// Order is undefined.
  IList<MapEntry<K, V>> toIList() => IList(entries);

  ISet<MapEntry<K, V>> toISet() => ISet(entries);

  Set<K> toKeySet() => keys.toSet();

  Set<V> toValueSet() => values.toSet();

  ISet<K> toKeyISet() => ISet(keys);

  /// Will remove duplicate values.
  ISet<V> toValueISet() => ISet(values);

  int get length => _m.length;

  // TODO: Marcelo, por favor, verifique a implementação.
  void forEach(void Function(K key, V value) f) => _m.forEach(f);

  // TODO: Marcelo, por favor, verifique a implementação.
  IMap<K, V> where(bool Function(K key, V value) test) => IMap<K, V>._map(
        _m.where(test),
        isDeepEquals: isDeepEquals,
        compareKey: compareKey,
        compareValue: compareValue,
      );

  // TODO: Marcelo, por favor, verifique a implementação.
  IMap<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper) => IMap<RK, RV>._map(
        _m.map(mapper),
        isDeepEquals: isDeepEquals,
        compareKey: null,
        compareValue: null,
      );

  @override
  String toString() => "{${entries.map((entry) => "${entry.key}: ${entry.value}").join(", ")}}";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class M<K, V> {
  //
  // Implemented by subclasses.
  Iterable<MapEntry<K, V>> get entries => throw AssertionError();

  Iterable<K> get keys => _getFlushed.keys;

  Iterable<V> get values => _getFlushed.values;

  Iterator<MapEntry<K, V>> get iterator => _getFlushed.entries.iterator;

  /// The [M] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed list, but
  /// because that's immutable, we cache it.
  Map<K, V> _flushed;

  Map<K, V> get _getFlushed {
    _flushed ??= unlock;
    return _flushed;
  }

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock {
    Map<K, V> map = HashMap<K, V>();
    map.addEntries(entries);
    return map;
  }

  int get length => _getFlushed.length;

  /// Returns a new map containing the current map plus the given key:value.
  /// However, if the given key already exists in the set,
  /// it will remove the old one and add the new one.
  M<K, V> add({@required K key, @required V value}) {
    bool contains = containsKey(key);
    if (!contains)
      return MAdd<K, V>(this, key, value);
    else {
      var oldValue = this[key];
      return (oldValue == value) //
          ? this
          : MReplace<K, V>(this, key, value);
    }
  }

  // M<K,V> add(T item) => contains(item) ? this : SAdd(this, item);

  M<K, V> addAll(IMap<K, V> imap) => MAddAll<K, V>.unsafe(this, imap._m);

  M<K, V> addMap(Map<K, V> map) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.of(map)));

  M<K, V> addEntries(Iterable<MapEntry<K, V>> items) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.fromEntries(items)));

  /// TODO: FALTA FAZER!!!
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(Map<K, V>.of(_getFlushed)..remove(key));
  }

  // TODO: Marcelo, por favor, verifique a implementação.
  // @override
  // M<RK, RV> cast<RK, RV>() => throw UnsupportedError('cast');
  Map<RK, RV> cast<RK, RV>() => _getFlushed.cast<RK, RV>();

  bool get isEmpty => _getFlushed.isEmpty;

  bool get isNotEmpty => !isEmpty;

  V operator [](K key);

  /// TODO: Is `_value == _value` correct?
  bool contains(K key, V value) {
    var _value = _getFlushed[key];
    return (_value == null) ? false : (_value == _value);
  }

  bool containsKey(K key) => _getFlushed.containsKey(key);

  bool containsValue(V value) => _getFlushed.containsKey(value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      _getFlushed.entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.any(test);

  // TODO: Especificar teste e implementar.
  // bool everyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.every(test);

  // TODO: Marcelo, por favor, verifique a implementação.
  void forEach(void Function(K key, V value) f) => _getFlushed.forEach(f);

  // TODO: Is this optimal?
  Map<K, V> where(bool Function(K key, V value) test) {
    final Map<K, V> matches = {};
    _getFlushed.forEach((K key, V value) {
      if (test(key, value)) matches[key] = value;
    });
    return matches;
  }

  // TODO: Marcelo, por favor, verifique a implementação.
  Map<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper) =>
      _getFlushed.map(mapper);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
