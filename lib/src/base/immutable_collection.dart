import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

// /////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> implements CanBeEmpty {
  //
  /// In your app initialization, call this if you want to lock the
  /// configuration, so that no one can change it anymore.
  ///
  /// These are the setters which you can use to configure and then lock:
  /// 1. `ImmutableCollection.autoFlush`
  /// 2. `ImmutableCollection.disallowUnsafeConstructors`
  /// 3. `IList.defaultConfig`
  /// 4. `IList.flushFactor`
  /// 5. `IList.asyncAutoflush`
  /// 6. `ISet.defaultConfig`
  /// 7. `ISet.flushFactor`
  /// 8. `ISet.asyncAutoflush`
  /// 9. `IMap.defaultConfig`
  /// 10. `IMap.flushFactor`
  /// 11. `IMap.asyncAutoflush`
  /// 12. `IMapOfSets.defaultConfig`
  static void lockConfig() => _isConfigLocked = true;

  static bool get isConfigLocked => _isConfigLocked;

  static bool get autoFlush => _autoFlush;

  static bool get disallowUnsafeConstructors => _disallowUnsafeConstructors;

  static bool _isConfigLocked = false;

  static bool _autoFlush = true;

  static int _asyncCounter = 1;

  static bool _disallowUnsafeConstructors = false;

  static bool _asyncCounterMarkedForIncrement = false;

  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _asyncCounter = 1;
    autoFlush = true;
    disallowUnsafeConstructors = false;
    IList.resetAllConfigurations();
    ISet.resetAllConfigurations();
    IMap.resetAllConfigurations();
  }

  /// Global configuration that specifies if the collections should flush
  /// automatically. The default is true.
  static set autoFlush(bool value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _autoFlush = value ?? true;
  }

  /// Global configuration that specifies if unsafe constructors can be used
  /// or not. The default is false.
  static set disallowUnsafeConstructors(bool value) {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _disallowUnsafeConstructors = value ?? false;
  }

  /// Internal use only.
  @visibleForTesting
  static bool get asyncCounterMarkedForIncrement => _asyncCounterMarkedForIncrement;

  /// Internal use only.
  static int get asyncCounter => _asyncCounter;

  /// Internal use only.
  static void markAsyncCounterToIncrement() {
    if (_asyncCounterMarkedForIncrement) return;
    _asyncCounterMarkedForIncrement = true;

    Future(() {
      // Increments, but resets at some point.
      _asyncCounter++;
      if (_asyncCounter == 10000) _asyncCounter = 1;
      _asyncCounterMarkedForIncrement = false;
    });
  }

  /// Flushes this collection, if necessary. Chainable method.
  /// If collection list is already flushed, don't do anything.
  C get flush;

  /// Whether this collection is already flushed or not.
  bool get isFlushed;

  /// Will return true only if the collection items are equal to the iterable
  /// items. If the collection is ordered, it will also check if the items are
  /// in the same order. This may be slow for very large collection, since it
  /// compares each item, one by one. If you can compare ordered and unordered
  /// collections, it will throw a `StateError`.
  bool equalItems(Iterable other);

  /// Will return true only if the collections items are equal, and the
  /// collection configurations are equal. If the collection is ordered, it
  /// will also check if the items are in the same order. This may be slow for
  /// very large collections, since it compares each item, one by one.
  bool equalItemsAndConfig(C other);

  /// Will return true only if the collections internals are the same instances
  /// (comparing by identity). This will be fast even for very large
  /// collections, since it doesn't  compare each item.
  /// Note: This is not the same as `identical(col1, col2)` since it doesn't
  /// compare the collection instances themselves, but their internal state.
  /// Comparing the internal state is better, because it will return true more
  /// often.
  bool same(C other);
}

// /////////////////////////////////////////////////////////////////////////////

/// While `identical(collection1, collection2)` will compare the identity of the
/// collection itself, `same(collection1, collection2)` will compare its
/// internal state by identity. Note `same` is practically as fast as
/// `identical`, but will give less false negatives. So it is almost always
/// recommended to use `same` instead of `identical`.
///
bool sameCollection<C extends ImmutableCollection>(C c1, C c2) {
  if (c1 == null && c2 == null) return true;
  if (c1 == null || c2 == null) return false;
  return c1.same(c2);
}

// /////////////////////////////////////////////////////////////////////////////

/// Your own classes can implement this so they may use [CanBeEmptyExtension].
abstract class CanBeEmpty {
  bool get isEmpty;

  bool get isNotEmpty;
}

// /////////////////////////////////////////////////////////////////////////////

extension CanBeEmptyExtension on CanBeEmpty {
  bool get isNullOrEmpty => (this == null) || isEmpty;

  bool get isNotNullOrEmpty => (this != null) && isNotEmpty;

  bool get isEmptyButNotNull => (this != null) && isEmpty;
}

// /////////////////////////////////////////////////////////////////////////////

extension BooleanExtension on bool {
  /// true > false
  /// Zero: This instance and value are equal (both true or both false).
  /// Greater than zero: This instance is true and value is false.
  /// Less than zero: This instance is false and value is true.
  int compareTo(bool other) => (this == other)
      ? 0
      : this
          ? 1
          : -1;
}

// /////////////////////////////////////////////////////////////////////////////

class Output<T> {
  T _value;

  T get value => _value;

  Output();

  void set(T value) {
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

// /////////////////////////////////////////////////////////////////////////////

extension IterableToImmutableExtension<T> on Iterable<T> {
  //
  /// Locks the iterable, returning an *immutable* list ([IList]).
  IList<T> get lockAsList => IList<T>(this);

  /// Locks the iterable, returning an *immutable* set ([ISet]).
  ISet<T> get lockAsSet => ISet<T>(this);
}

// /////////////////////////////////////////////////////////////////////////////

extension IteratorExtension<T> on Iterator<T> {
  //
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  Set<T> toSet() => Set.of(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////

extension MapIteratorExtension<K, V> on Iterator<MapEntry<K, V>> {
  //
  Iterable<MapEntry<K, V>> toIterable() sync* {
    while (moveNext()) yield current;
  }

  Map<K, V> toMap() => Map.fromEntries(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////
