import "dart:collection";
import "package:collection/collection.dart";
import "package:meta/meta.dart";
import "../ilist/ilist.dart";
import "../imap_of_sets/imap_of_sets.dart";
import "../iset/iset.dart";
import "../utils/immutable_collection.dart";
import "m_add.dart";
import "m_add_all.dart";
import "m_flat.dart";
import "m_replace.dart";
import "unmodifiable_map_view.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// An **immutable**, unordered map.
@immutable
class IMap<K, V> // ignore: must_be_immutable
    extends ImmutableCollection<IMap<K, V>> {
  //

  M<K, V> _m;

  /// The map configuration.
  final ConfigMap config;

  static IMap<K, V> empty<K, V>([ConfigMap config]) =>
      IMap._unsafe(MFlat.empty<K, V>(), config: config ?? defaultConfigMap);

  /// Create an [IMap] from a [Map].
  factory IMap([Map<K, V> map]) => //
      IMap.withConfig(map, defaultConfigMap);

  /// Create an [IMap] from a [Map] and a [ConfigMap].
  factory IMap.withConfig(Map<K, V> map, ConfigMap config) => (map == null || map.isEmpty)
      ? IMap.empty<K, V>()
      : IMap<K, V>._unsafe(MFlat<K, V>(map), config: config ?? defaultConfigMap);

  /// Create an [IMap] from an [Iterable] of [MapEntry].
  factory IMap.fromEntries(Iterable<MapEntry<K, V>> entries, {ConfigMap config}) {
    if (entries is IMap<K, V>)
      return IMap._unsafe((entries as IMap<K, V>)._m, config: config ?? defaultConfigMap);
    else {
      var map = HashMap<K, V>();
      map.addEntries(entries);
      return IMap._unsafe(MFlat.unsafe(map), config: config ?? defaultConfigMap);
    }
  }

  factory IMap.fromKeys({
    @required Iterable<K> keys,
    @required V Function(K) valueMapper,
    ConfigMap config,
  }) {
    assert(keys != null);
    assert(valueMapper != null);

    var map = HashMap<K, V>();

    for (K key in keys) {
      map[key] = valueMapper(key);
    }

    return IMap._(map, config: config ?? defaultConfigMap);
  }

  factory IMap.fromValues({
    @required K Function(V) keyMapper,
    @required Iterable<V> values,
    ConfigMap config,
  }) {
    assert(keyMapper != null);
    assert(values != null);

    var map = HashMap<K, V>();

    for (V value in values) {
      map[keyMapper(value)] = value;
    }

    return IMap._(map, config: config ?? defaultConfigMap);
  }

  factory IMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic) keyMapper,
    V Function(dynamic) valueMapper,
    ConfigMap config,
  }) {
    Map<K, V> map = Map.fromIterable(iterable, key: keyMapper, value: valueMapper);
    return IMap._(map, config: config ?? defaultConfigMap);
  }

  factory IMap.fromIterables(Iterable<K> keys, Iterable<V> values, {ConfigMap config}) {
    Map<K, V> map = Map.fromIterables(keys, values);
    return IMap._(map, config: config ?? defaultConfigMap);
  }

  /// Unsafe.
  IMap._(Map<K, V> map, {@required this.config}) : _m = MFlat<K, V>.unsafe(map);

  /// Unsafe constructor. Use this at your own peril.
  /// This constructor is fast, since it makes no defensive copies of the map.
  /// However, you should only use this with a new map you"ve created yourself,
  /// when you are sure no external copies exist. If the original map is modified,
  /// it will break the IMap and any other derived maps in unpredictable ways.
  IMap.unsafe(Map<K, V> map, {@required this.config})
      : assert(config != null),
        _m = (map == null) ? MFlat.empty<K, V>() : MFlat<K, V>.unsafe(map) {
    if (disallowUnsafeConstructors) throw UnsupportedError("IMap.unsafe is disallowed.");
  }

  /// Unsafe.
  IMap._unsafe(this._m, {@required this.config});

  /// Unsafe.
  IMap._unsafeFromMap(Map<K, V> map, {@required this.config})
      : assert(config != null),
        _m = (map == null) ? MFlat.empty<K, V>() : MFlat<K, V>.unsafe(map);

  bool get isDeepEquals => config.isDeepEquals;

  bool get isIdentityEquals => !config.isDeepEquals;

  /// Creates a new map with the given [config].
  ///
  /// To copy the config from another [IMap]:
  ///    `map = map.withConfig(other.config)`.
  ///
  /// To change the current config:
  ///    `map = map.withConfig(map.config.copyWith(isDeepEquals: isDeepEquals))`.
  ///
  /// See also: [withIdentityEquals] and [withDeepEquals].
  ///
  IMap<K, V> withConfig(ConfigMap config) {
    assert(config != null);
    return (config == this.config) ? this : IMap._unsafe(_m, config: config);
  }

  /// Creates a map with `identityEquals` (compares the internals by `identity`).
  IMap<K, V> get withIdentityEquals =>
      config.isDeepEquals ? IMap._unsafe(_m, config: config.copyWith(isDeepEquals: false)) : this;

  /// Creates a map with `deepEquals` (compares all map entries by equality).
  IMap<K, V> get withDeepEquals =>
      config.isDeepEquals ? this : IMap._unsafe(_m, config: config.copyWith(isDeepEquals: true));

  Iterable<MapEntry<K, V>> get entries => _m.entries;

  Iterable<K> get keys => _m.keys;

  Iterable<V> get values => _m.values;

  /// Order is undefined.
  IList<MapEntry<K, V>> get entryList => IList(entries);

  ISet<MapEntry<K, V>> get entrySet => ISet(entries);

  /// Order is undefined.
  IList<K> get keyList => IList(keys);

  /// Order is undefined.
  IList<V> get valueList => IList(values);

  ISet<K> get keySet => ISet(keys);

  ISet<V> get valueSet => ISet(values);

  Iterator<MapEntry<K, V>> get iterator => _m.iterator;

  /// Returns a regular Dart (mutable) Map.
  Map<K, V> get unlock => _m.unlock;

  @override
  bool get isEmpty => _m.isEmpty;

  @override
  bool get isNotEmpty => !isEmpty;

  /// If [isDeepEquals] configuration is `true`:
  /// Will return `true` only if the map entries are equal (not necessarily in the same order),
  /// and the map configurations are equal. This may be slow for very
  /// large maps, since it compares each entry, one by one.
  ///
  /// If [isDeepEquals] configuration is `false`:
  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  ///
  @override
  bool operator ==(Object other) => (other is IMap<K, V>)
      ? isDeepEquals
          ? equalItemsAndConfig(other)
          : same(other)
      : false;

  /// Will return `true` only if the [IMap] entries are equal to the entries in the [Iterable].
  /// Order is irrelevant. This may be slow for very large maps, since it compares each entry,
  /// one by one. To compare with a map, use method [equalItemsToMap] or [equalItemsToIMap].
  @override
  bool equalItems(covariant Iterable<MapEntry<K, V>> other) =>
      (other == null) ? false : (flush._m as MFlat<K, V>).deepMapEquals_toIterable(other);

  /// Will return true only if the two maps have the same number of entries,
  /// and if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToMap(Map<K, V> other) =>
      const MapEquality().equals(UnmodifiableMapView(this), other);

  /// Will return true only if the two maps have the same number of entries,
  /// and if the entries of the two maps are pairwise equal on both key and value.
  bool equalItemsToIMap(IMap<K, V> other) =>
      (flush._m as MFlat<K, V>).deepMapEquals(other.flush._m as MFlat<K, V>);

  @override
  bool equalItemsAndConfig(IMap<K, V> other) =>
      identical(this, other) ||
      other is IMap<K, V> &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          (flush._m as MFlat<K, V>).deepMapEquals(other.flush._m as MFlat<K, V>);

  /// Will return `true` only if the maps internals are the same instances
  /// (comparing by identity). This will be fast even for very large maps,
  /// since it doesn't  compare each entry.
  /// Note: This is not the same as `identical(map1, map2)` since it doesn't
  /// compare the maps themselves, but their internal state. Comparing the
  /// internal state is better, because it will return `true` more often.
  @override
  bool same(IMap<K, V> other) => identical(_m, other._m) && (config == other.config);

  @override
  int get hashCode => isDeepEquals //
      ? (flush._m as MFlat<K, V>).deepMapHashcode() ^ config.hashCode
      : identityHashCode(_m) ^ config.hashCode;

  /// Compacts the map.
  IMap<K, V> get flush {
    if (!isFlushed) _m = MFlat<K, V>.unsafe(unlock);
    return this;
  }

  bool get isFlushed => _m is MFlat;

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> add(K key, V value) =>
      IMap<K, V>._unsafe(_m.add(key: key, value: value), config: config);

  /// Returns a new map containing the current map plus the given key:value.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntry(MapEntry<K, V> entry) =>
      IMap<K, V>._unsafe(_m.add(key: entry.key, value: entry.value), config: config);

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addAll(IMap<K, V> iMap) => IMap<K, V>._unsafe(_m.addAll(iMap), config: config);

  /// Returns a new map containing the current map plus the given map.
  /// (if necessary, the given will override the current).
  IMap<K, V> addMap(Map<K, V> map) => IMap<K, V>._unsafe(_m.addMap(map), config: config);

  /// Returns a new map containing the current map plus the given map entries.
  /// (if necessary, the given will override the current).
  IMap<K, V> addEntries(Iterable<MapEntry<K, V>> entries) =>
      IMap<K, V>._unsafe(_m.addEntries(entries), config: config);

  /// Returns a new map containing the current map minus the given key and its value.
  /// However, if the current map doesn't  contain the key,
  /// it will return the current map (same instance).
  IMap<K, V> remove(K key) {
    M<K, V> result = _m.remove(key);
    return identical(result, _m) ? this : IMap<K, V>._unsafe(result, config: config);
  }

  /// Returns a new map containing the current map minus the
  /// entries that satisfy the given [predicate].
  /// However, if nothing is removed, it will return the current map (same instance).
  IMap<K, V> removeWhere(bool Function(K key, V value) predicate) {
    M<K, V> result = _m.removeWhere(predicate);
    return identical(result, _m) ? this : IMap<K, V>._unsafe(result, config: config);
  }

  V operator [](K k) => _m[k];

  V get(K k) => _m[k];

  bool any(bool Function(K key, V value) test) => _m.any(test);

  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already an `IMap<RK, RV>`, it is returned unchanged.
  ///
  /// If this map contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `IMap<K, V>` and a
  /// `IMap<RK, RV>`.
  IMap<RK, RV> cast<RK, RV>() {
    Object result = _m.cast<RK, RV>();
    if (result is M<RK, RV>)
      return IMap._unsafe(result, config: config);
    else if (result is Map<RK, RV>)
      return IMap._(result, config: config);
    else
      throw AssertionError(result.runtimeType);
  }

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

  void forEach(void Function(K key, V value) f) => _m.forEach(f);

  IMap<K, V> where(bool Function(K key, V value) test) =>
      IMap<K, V>._(_m.where(test), config: config);

  IMap<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper, {ConfigMap config}) =>
      IMap<RK, RV>._(_m.map(mapper),
          config: config ?? ((RK == K && RV == V) ? this.config : defaultConfigMap));

  @override
  String toString() => "{${entries.map((entry) => "${entry.key}: ${entry.value}").join(", ")}}";

  /// Returns an empty map with the same configuration.
  IMap<K, V> clear() => empty<K, V>(config);

  /// Look up the value of [key], or add a new value if it isn't there.
  ///
  /// Returns the modified map, and sets the [value] associated to [key],
  /// if there is one. Otherwise calls [ifAbsent] to get a new value,
  /// associates [key] to that value, and then sets the new [value].
  ///
  /// ```dart
  /// IMap<String, int> scores = {"Bob": 36}.lock;
  ///
  /// Item<int> item = Item();
  /// for (String key in ["Bob", "Rohan", "Sophia"]) {
  ///   item = Item();
  ///   scores = scores.putIfAbsent(key, () => key.length, value: item);
  ///   print(value);    // 36, 5, 6
  /// }
  ///
  /// scores["Bob"];     // 36
  /// scores["Rohan"];   //  5
  /// scores["Sophia"];  //  6
  /// ```
  ///
  /// Calling [ifAbsent] must not add or remove keys from the map.
  ///
  IMap<K, V> putIfAbsent(K key, V Function() ifAbsent, {Item<V> value}) {
    // TODO: Still need to implement efficiently.
    Map<K, V> map = unlock;
    var result = map.putIfAbsent(key, ifAbsent);
    if (value != null) value.set(result);
    return IMap._unsafeFromMap(map, config: config);
  }

  /// Updates the value for the provided [key].
  ///
  /// Returns the modified map and sets the new [value] of the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// It"s an error if the key is not present and [ifAbsent] is not provided.
  ///
  IMap<K, V> update(K key, V Function(V value) update, {V Function() ifAbsent, Item<V> value}) {
    // TODO: Still need to implement efficiently.
    Map<K, V> map = unlock;
    var result = map.update(key, update, ifAbsent: ifAbsent);
    if (value != null) value.set(result);
    return IMap._unsafeFromMap(map, config: config);
  }

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  IMap<K, V> updateAll(V Function(K key, V value) update) {
    return IMap._unsafeFromMap(unlock..updateAll(update), config: config);
  }
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

@visibleForOverriding
abstract class M<K, V> {
  //

  /// The [M] class provides the default fallback methods of `Iterable`, but
  /// ideally all of its methods are implemented in all of its subclasses.
  /// Note these fallback methods need to calculate the flushed map, but
  /// because that"s immutable, we cache it.
  Map<K, V> _flushed;

  /// Returns the flushed map (flushes it only once).
  /// It is an error to use the flushed map outside of the [M] class.
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

  Iterable<MapEntry<K, V>> get entries;

  Iterable<K> get keys => _getFlushed.keys;

  Iterable<V> get values => _getFlushed.values;

  Iterator<MapEntry<K, V>> get iterator => _getFlushed.entries.iterator;

  int get length;

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

  /// Adds all key/value pairs of [imap] to this map.
  ///
  /// If a key of [imap] is already in this map, its value is overwritten
  /// (the old value is discarded).
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in imap.
  M<K, V> addAll(IMap<K, V> imap) => MAddAll<K, V>.unsafe(this, imap._m);

  M<K, V> addMap(Map<K, V> map) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.of(map)));

  M<K, V> addEntries(Iterable<MapEntry<K, V>> entries) =>
      MAddAll<K, V>.unsafe(this, MFlat<K, V>.unsafe(Map<K, V>.fromEntries(entries)));

  /// TODO: FALTA FAZER!!!
  M<K, V> remove(K key) {
    return !containsKey(key) ? this : MFlat<K, V>.unsafe(Map<K, V>.of(_getFlushed)..remove(key));
  }

  /// Removes all entries of this map that satisfy the given [predicate].
  ///
  M<K, V> removeWhere(bool Function(K key, V value) predicate) {
    Map<K, V> oldMap = unlock;
    int oldLength = oldMap.length;
    Map<K, V> newMap = oldMap..removeWhere(predicate);
    return (newMap.length == oldLength) ? this : MFlat<K, V>.unsafe(newMap);
  }

  /// Provides a view of this map as having [RK] keys and [RV] instances.
  /// May return M<RK, RV> or Map<RK, RV>.
  Object cast<RK, RV>() => (RK == K && RV == V) ? this : _getFlushed.cast<RK, RV>();

  /// Returns true if there is no key/value pair in the map.
  bool get isEmpty => _getFlushed.isEmpty;

  /// Returns true if there is at least one key/value pair in the map.
  bool get isNotEmpty => !isEmpty;

  V operator [](K key);

  /// Returns true if this map contains the given [key] with the given [value].
  bool contains(K key, V value) {
    var _value = _getFlushed[key];
    return (_value == null) ? _flushed.containsKey(key) : (_value == value);
  }

  /// Returns true if this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  bool containsKey(K key) => _getFlushed.containsKey(key);

  /// Returns true if this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  bool containsValue(V value) => _getFlushed.containsKey(value);

  bool containsEntry(MapEntry<K, V> entry) => contains(entry.key, entry.value);

  bool any(bool Function(K key, V value) test) =>
      _getFlushed.entries.any((entry) => test(entry.key, entry.value));

  bool anyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.any(test);

  bool everyEntry(bool Function(MapEntry<K, V>) test) => _getFlushed.entries.every(test);

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

  Map<RK, RV> map<RK, RV>(MapEntry<RK, RV> Function(K key, V value) mapper) =>
      _getFlushed.map(mapper);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
