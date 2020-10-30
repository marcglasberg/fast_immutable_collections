import "package:meta/meta.dart";

import "../ilist/ilist.dart";
import "../iset/iset.dart";
import "hash.dart";

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// In your app initialization you may want to lock the configuration.
void lockConfig() => _isConfigLocked = true;

bool _isConfigLocked = false;

/// While `identical(collection1, collection2)` will compare the identity of the collection
/// itself, `same(collection1, collection2)` will compare its internal state by identity.
/// Note `same` is practically as fast as `identical`, but will give less false negatives.
/// So it is almost always recommended to use `same` instead of `identical`.
///
bool sameCollection<C extends ImmutableCollection>(C c1, C c2) {
  if (c1 == null && c2 == null) return true;
  if (c1 == null || c2 == null) return false;
  return c1.same(c2);
}

/// Global configuration that specifies if unsafe constructors can be used or not.
set disallowUnsafeConstructors(bool value) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _disallowUnsafeConstructors = value ?? false;
}

bool get disallowUnsafeConstructors => _disallowUnsafeConstructors;

bool _disallowUnsafeConstructors = false;

// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> implements CanBeEmpty {
  //
  static int compare(Object a, Object b) => a is Comparable && b is Comparable ? a.compareTo(b) : 0;

  /// Will return true only if the collection items are equal to the iterable items.
  /// If the collection is ordered, it will also check if the items are in the same order.
  /// This may be slow for very large collection, since it compares each item, one by one.
  /// If you can compare ordered and unordered collections, it will throw a `StateError`.
  bool equalItems(Iterable other);

  /// Will return true only if the collections items are equal, and the collection
  /// configurations are equal. If the collection is ordered, it will also check
  /// if the items are in the same order. This may be slow for very large collections, since
  /// it compares each item, one by one.
  bool equalItemsAndConfig(C other);

  /// Will return true only if the collections internals are the same instances
  /// (comparing by identity). This will be fast even for very large collections,
  /// since it doesn't  compare each item.
  /// Note: This is not the same as `identical(col1, col2)` since it doesn't
  /// compare the collection instances themselves, but their internal state.
  /// Comparing the internal state is better, because it will return true more often.
  bool same(C other);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// Your own classes can implement this so they may use [CanBeEmptyExtension].
abstract class CanBeEmpty {
  bool get isEmpty;

  bool get isNotEmpty;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension CanBeEmptyExtension on CanBeEmpty {
  bool get isNullOrEmpty => (this == null) || isEmpty;

  bool get isNotNullOrEmpty => (this != null) && isNotEmpty;

  bool get isEmptyButNotNull => (this != null) && isEmpty;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

class Item<T> {
  T _value;

  T get value => _value;

  Item();

  void set(T value) {
    if (_value != null) throw StateError("Value can't be set.");
    _value = value;
  }

  @override
  String toString() => _value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IList] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IList] equals operator (`==`) compares all items, ordered.
@immutable
class ConfigList {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  const ConfigList({this.isDeepEquals = true});

  ConfigList copyWith({bool isDeepEquals}) {
    var config = ConfigList(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigList && runtimeType == other.runtimeType && isDeepEquals == other.isDeepEquals;

  @override
  int get hashCode => isDeepEquals.hashCode;

  @override
  String toString() => "ConfigList{isDeepEquals: $isDeepEquals}";
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
set defaultConfigList(ConfigList config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigList = config ?? const ConfigList(isDeepEquals: true);
}

ConfigList get defaultConfigList => _defaultConfigList;

ConfigList _defaultConfigList = const ConfigList(isDeepEquals: true);

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// The set configuration.
/// - If [isDeepEquals] is `false`, the [ISet] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [ISet] equals operator (`==`) compares all items, unordered.
/// - If the [compare] function is defined, sorted outputs will use it as a comparator.
@immutable
class ConfigSet {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If true, will sort the list output of items.
  final bool autoSort;

  const ConfigSet({
    this.isDeepEquals = true,
    this.autoSort = true,
  });

  ConfigSet copyWith({
    bool isDeepEquals,
    bool autoSort,
  }) {
    var config = ConfigSet(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      autoSort: autoSort ?? this.autoSort,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigSet &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          autoSort == other.autoSort;

  @override
  int get hashCode => hash2(isDeepEquals, autoSort);

  @override
  String toString() => "ConfigSet{"
      "isDeepEquals: $isDeepEquals, "
      "autoSort: $autoSort}";
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set defaultConfigSet(ConfigSet config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigSet = config ?? const ConfigSet(isDeepEquals: true, autoSort: true);
}

ConfigSet get defaultConfigSet => _defaultConfigSet;

ConfigSet _defaultConfigSet = const ConfigSet(isDeepEquals: true, autoSort: true);

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IMap] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IMap] equals operator (`==`) compares all entries, ordered.
/// - If [autoSortKeys] is `true` (the default), will sort the list output of keys.
/// - If [autoSortValues] is `true` (the default), will sort the list output of values.
@immutable
class ConfigMap {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If `true` (the default), will sort the list output of keys.
  final bool autoSortKeys;

  /// If `true` (the default), will sort the list output of values.
  final bool autoSortValues;

  const ConfigMap({
    this.isDeepEquals = true,
    this.autoSortKeys = true,
    this.autoSortValues = true,
  });

  ConfigMap copyWith({
    bool isDeepEquals,
    bool autoSortKeys,
    bool autoSortValues,
  }) {
    var config = ConfigMap(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      autoSortKeys: autoSortKeys ?? this.autoSortKeys,
      autoSortValues: autoSortValues ?? this.autoSortValues,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigMap &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          autoSortKeys == other.autoSortKeys &&
          autoSortValues == other.autoSortValues;

  @override
  int get hashCode => hash3(isDeepEquals, autoSortKeys, autoSortValues);

  @override
  String toString() => "ConfigMap{"
      "isDeepEquals: $isDeepEquals, "
      "autoSortKeys: $autoSortKeys, "
      "autoSortValues: $autoSortValues}";
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set defaultConfigMap(ConfigMap config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigMap =
      config ?? const ConfigMap(isDeepEquals: true, autoSortKeys: true, autoSortValues: true);
}

ConfigMap get defaultConfigMap => _defaultConfigMap;

ConfigMap _defaultConfigMap =
    const ConfigMap(isDeepEquals: true, autoSortKeys: true, autoSortValues: true);

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IMap] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IMap] equals operator (`==`) compares all entries, ordered.
/// - If [autoSortKeys] is `true` (the default), will sort the list output of keys.
/// - If [autoSortValues] is `true` (the default), will sort the list output of values.
@immutable
class ConfigMapOfSets {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If `true` (the default), will sort the list output of keys.
  final bool autoSortKeys;

  /// If `true` (the default), will sort the list output of values.
  final bool autoSortValues;

  const ConfigMapOfSets({
    this.isDeepEquals = true,
    this.autoSortKeys = true,
    this.autoSortValues = true,
  });

  ConfigMap get asConfigMap => ConfigMap(
      isDeepEquals: isDeepEquals, autoSortKeys: autoSortValues, autoSortValues: autoSortValues);

  ConfigSet get asConfigSet => ConfigSet(isDeepEquals: isDeepEquals, autoSort: autoSortValues);

  ConfigMapOfSets copyWith({
    bool isDeepEquals,
    bool autoSortKeys,
    bool autoSortValues,
  }) {
    var config = ConfigMapOfSets(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      autoSortKeys: autoSortKeys ?? this.autoSortKeys,
      autoSortValues: autoSortValues ?? this.autoSortValues,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigMapOfSets &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          autoSortKeys == other.autoSortKeys &&
          autoSortValues == other.autoSortValues;

  @override
  int get hashCode => hash3(isDeepEquals, autoSortKeys, autoSortValues);

  @override
  String toString() => "ConfigMapOfSets{"
      "isDeepEquals: $isDeepEquals, "
      "autoSortKeys: $autoSortKeys, "
      "autoSortValues: $autoSortValues}";
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set defaultConfigMapOfSets(ConfigMapOfSets config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigMapOfSets =
      config ?? const ConfigMapOfSets(isDeepEquals: true, autoSortKeys: true, autoSortValues: true);
}

ConfigMapOfSets get defaultConfigMapOfSets => _defaultConfigMapOfSets;

ConfigMapOfSets _defaultConfigMapOfSets =
    const ConfigMapOfSets(isDeepEquals: true, autoSortKeys: true, autoSortValues: true);

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension IterableToImmutableExtension<T> on Iterable<T> {
  //
  /// Locks the iterable, returning an *immutable* list ([IList]).
  IList<T> get lockAsList => IList<T>(this);

  /// Locks the iterable, returning an *immutable* set ([ISet]).
  ISet<T> get lockAsSet => ISet<T>(this);
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension IteratorExtension<T> on Iterator<T> {
  //
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  Set<T> toSet() => Set.of(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

extension MapIteratorExtension<K, V> on Iterator<MapEntry<K, V>> {
  //
  Iterable<MapEntry<K, V>> toIterable() sync* {
    while (moveNext()) yield current;
  }

  Map<K, V> toMap() => Map.fromEntries(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
