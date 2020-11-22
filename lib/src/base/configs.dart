import "package:meta/meta.dart";

import "../ilist/ilist.dart";
import "../iset/iset.dart";
import "hash.dart";

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
      other is ConfigList &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals;

  @override
  int get hashCode => isDeepEquals.hashCode;

  @override
  String toString() => "ConfigList{isDeepEquals: $isDeepEquals}";
}

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
  final bool sort;

  const ConfigSet({
    this.isDeepEquals = true,
    this.sort = true,
  });

  ConfigSet copyWith({
    bool isDeepEquals,
    bool sort,
  }) {
    var config = ConfigSet(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      sort: sort ?? this.sort,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigSet &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          sort == other.sort;

  @override
  int get hashCode => hash2(isDeepEquals, sort);

  @override
  String toString() => "ConfigSet{"
      "isDeepEquals: $isDeepEquals, "
      "sort: $sort}";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IMap] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IMap] equals operator (`==`) compares all entries, ordered.
/// - If [sortKeys] is `true` (the default), will sort the list output of keys.
/// - If [sortValues] is `true` (the default), will sort the list output of values.
@immutable
class ConfigMap {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If `true` (the default), will sort the list output of keys.
  final bool sortKeys;

  /// If `true` (the default), will sort the list output of values.
  final bool sortValues;

  const ConfigMap({
    this.isDeepEquals = true,
    this.sortKeys = true,
    this.sortValues = true,
  });

  ConfigMap copyWith({
    bool isDeepEquals,
    bool sortKeys,
    bool sortValues,
  }) {
    var config = ConfigMap(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      sortKeys: sortKeys ?? this.sortKeys,
      sortValues: sortValues ?? this.sortValues,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigMap &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          sortKeys == other.sortKeys &&
          sortValues == other.sortValues;

  @override
  int get hashCode => hash3(isDeepEquals, sortKeys, sortValues);

  @override
  String toString() => "ConfigMap{"
      "isDeepEquals: $isDeepEquals, "
      "sortKeys: $sortKeys, "
      "sortValues: $sortValues}";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////

/// - If [isDeepEquals] is `false`, the [IMap] equals operator (`==`) compares by identity.
/// - If [isDeepEquals] is `true` (the default), the [IMap] equals operator (`==`) compares all entries, ordered.
/// - If [sortKeys] is `true` (the default), will sort the list output of keys.
/// - If [sortValues] is `true` (the default), will sort the list output of values.
@immutable
class ConfigMapOfSets {
  //
  /// If `false`, the equals operator (`==`) compares by identity.
  /// If `true` (the default), the equals operator (`==`) compares all items, ordered.
  final bool isDeepEquals;

  /// If `true` (the default), will sort the list output of keys.
  final bool sortKeys;

  /// If `true` (the default), will sort the list output of values.
  final bool sortValues;

  /// If `true` (the default), sets which become empty are automatically
  /// removed, together with their keys.
  /// If `false`, empty sets and their keys are kept.
  final bool removeEmptySets;

  const ConfigMapOfSets({
    this.isDeepEquals = true,
    this.sortKeys = true,
    this.sortValues = true,
    this.removeEmptySets = true,
  });

  ConfigMap get asConfigMap => ConfigMap(
      isDeepEquals: isDeepEquals, sortKeys: sortValues, sortValues: sortValues);

  ConfigSet get asConfigSet =>
      ConfigSet(isDeepEquals: isDeepEquals, sort: sortValues);

  ConfigMapOfSets copyWith({
    bool isDeepEquals,
    bool sortKeys,
    bool sortValues,
    bool removeEmptySets,
  }) {
    var config = ConfigMapOfSets(
      isDeepEquals: isDeepEquals ?? this.isDeepEquals,
      sortKeys: sortKeys ?? this.sortKeys,
      sortValues: sortValues ?? this.sortValues,
      removeEmptySets: removeEmptySets ?? this.removeEmptySets,
    );
    return (config == this) ? this : config;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigMapOfSets &&
          runtimeType == other.runtimeType &&
          isDeepEquals == other.isDeepEquals &&
          sortKeys == other.sortKeys &&
          sortValues == other.sortValues &&
          removeEmptySets == other.removeEmptySets;

  @override
  int get hashCode => hash4(isDeepEquals, sortKeys, sortValues, removeEmptySets);

  @override
  String toString() => "ConfigMapOfSets{"
      "isDeepEquals: $isDeepEquals, "
      "sortKeys: $sortKeys, "
      "sortValues: $sortValues, "
      "removeEmptySets: $removeEmptySets}";
}

// /////////////////////////////////////////////////////////////////////////////////////////////////
