// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/fast_immutable_collections.dart";

abstract class ImmutableCollection<C> implements CanBeEmpty {
  //
  const ImmutableCollection();

  /// In your app initialization, call [lockConfig] if you want to lock the
  /// configuration, so that no one can change it anymore.
  ///
  /// These are setters which you can use to configure and then lock:
  ///
  /// 1. `ImmutableCollection.autoFlush`
  /// 2. `ImmutableCollection.disallowUnsafeConstructors`
  /// 3. `IList.defaultConfig`
  /// 4. `IList.flushFactor`
  /// 5. `ISet.defaultConfig`
  /// 6. `ISet.flushFactor`
  /// 7. `IMap.defaultConfig`
  /// 8. `IMap.flushFactor`
  /// 9. `IMapOfSets.defaultConfig`
  static void lockConfig() => _isConfigLocked = true;

  static bool get isConfigLocked => _isConfigLocked;

  static bool get autoFlush => _autoFlush;

  static bool get disallowUnsafeConstructors => _disallowUnsafeConstructors;

  static bool _isConfigLocked = false;

  static bool _autoFlush = true;

  static bool _disallowUnsafeConstructors = false;

  static bool _prettyPrint = true;

  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _autoFlush = true;
    _disallowUnsafeConstructors = false;
    _prettyPrint = true;
    IList.resetAllConfigurations();
    ISet.resetAllConfigurations();
    IMap.resetAllConfigurations();
  }

  /// Global configuration that specifies if the collections should flush
  /// automatically. The default is `true`.
  static set autoFlush(bool value) {
    if (_autoFlush == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _autoFlush = value;
  }

  /// Global configuration that specifies if **unsafe constructors** can be used
  /// or not. The default is `false`.
  static set disallowUnsafeConstructors(bool value) {
    if (_disallowUnsafeConstructors == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _disallowUnsafeConstructors = value;
  }

  static bool get prettyPrint => _prettyPrint;

  /// Global configuration that specifies if the collections should print with "pretty print".
  static set prettyPrint(bool value) {
    if (_prettyPrint == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _prettyPrint = value;
  }

  /// Flushes this collection, if necessary. Chainable method.
  /// If collection list is already flushed, don't do anything.
  C get flush;

  /// Whether this collection is already flushed or not.
  bool get isFlushed;

  /// Will return `true` only if the collection items are equal to the iterable
  /// items. If the collection is ordered, it will also check if the items are
  /// in the same order. This may be slow for very large collection, since it
  /// compares each item, one by one. If you try to compare ordered and unordered
  /// collections, it will throw a [StateError].
  bool equalItems(Iterable other);

  /// Will return `true` only if the collections items are equal, and the
  /// collection configurations are equal. If the collection is ordered, it
  /// will also check if the items are in the same order. This may be slow for
  /// very large collections, since it compares each item, one by one.
  bool equalItemsAndConfig(C other);

  /// Will return `true` only if the collections internals are the same instances
  /// (comparing by identity). This will be fast even for very large
  /// collections, since it doesn't  compare each item.
  ///
  /// Note: This is not the same as `identical(col1, col2)` since it doesn't
  /// compare the collection instances themselves, but their internal state.
  /// Comparing the internal state is better, because it's also fast but will
  /// return `true` more often.
  bool same(C other);

  @override
  String toString([bool? prettyPrint]);
}

/// While `identical(collection1, collection2)` will compare the collections by
/// identity, `areSameImmutableCollection(collection1, collection2)` will
/// compare them by type, and then by their internal state. Note this is
/// practically as fast as `identical`, but will give **less false negatives**.
/// So it is almost always recommended to use `areSameImmutableCollection`
/// instead of `identical`.
///
bool areSameImmutableCollection(ImmutableCollection? c1, ImmutableCollection? c2) {
  if (identical(c1, c2)) return true;
  if (c1 == null || c2 == null) return false;

  if (c1.runtimeType == c2.runtimeType) {
    return c1.same(c2);
  } else
    return false;
}

/// Will return `true` only if the collections are of the same type, and their
/// items are equal by calling the collection's [equalItems] method. This may be
/// slow for very large collection, since it compares each item, one by one.
/// Note this will **not** compare the collection configuration.
///
bool areImmutableCollectionsWithEqualItems(ImmutableCollection? c1, ImmutableCollection? c2) {
  if (identical(c1, c2)) return true;
  if (c1 is IList && c2 is IList) return (c1).equalItems(c2);
  if (c1 is ISet && c2 is ISet) return (c1).equalItems(c2);
  if (c1 is IMap && c2 is IMap) return (c1).equalItemsToIMap(c2);
  if (c1 is IMapOfSets && c2 is IMapOfSets) return (c1).equalItemsToIMapOfSets(c2);
  return false;
}

/// Your own classes can implement this so they may use [CanBeEmptyExtension].
abstract class CanBeEmpty {
  bool get isEmpty;

  bool get isNotEmpty;
}

/// Meant to be used when you wish to save a value that's going to be tossed
/// out of an immutable collection.
///
/// For an example, see [IList.removeAt()].
///
class Output<T> {
  T? _value;

  T? get value => _value;

  Output();

  void save(T? value) {
    if (_value != null) throw StateError("Value can't be set.");
    _value = value;
  }

  @override
  String toString() => _value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Output && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
