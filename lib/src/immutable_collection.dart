import 'package:meta/meta.dart';

// /////////////////////////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> implements CanBeEmpty {
  bool equals(C other);

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

/// In your app initialization you may want to lock the configuration.
void lockConfig() => _isConfigLocked = true;

bool _isConfigLocked = false;

int _compare<T>(T item1, T item2) =>
    (item1 is Comparable) && (item2 is Comparable) ? item1.compareTo(item2) : 0;

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IList] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IList] equals operator (`==`) compares all items, ordered.
@immutable
class ConfigList {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  ConfigList({this.isDeepEquals = true});

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
  String toString() => 'ConfigList{isDeepEquals: $isDeepEquals}';
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
set defaultConfigList(ConfigList config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigList = config ?? ConfigList(isDeepEquals: true);
}

ConfigList get defaultConfigList => _defaultConfigList;

ConfigList _defaultConfigList = ConfigList(
  isDeepEquals: true,
);

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

  /// If given, will be used to sort list of values.
  final int Function(Object, Object) compare;

  ConfigSet({this.isDeepEquals = true, this.compare});

  ConfigSet copyWith({
    bool isDeepEquals,
    int Function(Object, Object) compare,
  }) {
    var config = ConfigSet(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      compare: compare ?? this.compare,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigSet &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          compare == other.compare;

  @override
  int get hashCode => isDeepEquals.hashCode ^ compare.hashCode;

  @override
  String toString() => 'ConfigSet{'
      'isDeepEquals: $isDeepEquals, '
      'compare: $compare}';
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set defaultConfigSet(ConfigSet config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigSet = config ?? ConfigSet(isDeepEquals: true);
}

ConfigSet get defaultConfigSet => _defaultConfigSet;

ConfigSet _defaultConfigSet = ConfigSet(
  isDeepEquals: true,
  compare: _compare,
);

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IMap] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IMap] equals operator (`==`) compares all entries, ordered.
/// - If the [compareKey] function is defined, sorted key outputs will use it as a comparator.
/// - If the [compareValue] function is defined, sorted value outputs will use it as a comparator.
@immutable
class ConfigMap {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If given, will be used to sort list of keys or lists of entries.
  final int Function(Object, Object) compareKey;

  /// If given, will be used to sort list of values.
  final int Function(Object, Object) compareValue;

  ConfigMap({this.isDeepEquals = true, this.compareKey, this.compareValue});

  ConfigMap copyWith({
    bool isDeepEquals,
    int Function(Object, Object) compareKey,
    int Function(Object, Object) compareValue,
  }) {
    var config = ConfigMap(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      compareKey: compareKey ?? this.compareKey,
      compareValue: compareValue ?? this.compareValue,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigMap &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          compareKey == other.compareKey &&
          compareValue == other.compareValue;

  @override
  int get hashCode => isDeepEquals.hashCode ^ compareKey.hashCode ^ compareValue.hashCode;

  @override
  String toString() => 'ConfigMap{'
      'isDeepEquals: $isDeepEquals, '
      'compareKey: $compareKey, '
      'compareValue: $compareValue}';
}

/// Global configuration that specifies if, by default, the immutable
/// collections use equality or identity for their [operator ==].
/// By default [isDeepEquals]==true (collections are compared by equality).
///
set defaultConfigMap(ConfigMap config) {
  if (_isConfigLocked) throw StateError("Can't change the configuration of immutable collections.");
  _defaultConfigMap = config ?? ConfigMap(isDeepEquals: true);
}

ConfigMap get defaultConfigMap => _defaultConfigMap;

ConfigMap _defaultConfigMap = ConfigMap(
  isDeepEquals: true,
  compareKey: _compare,
  compareValue: _compare,
);

// /////////////////////////////////////////////////////////////////////////////////////////////////
