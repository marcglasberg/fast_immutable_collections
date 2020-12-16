import "dart:collection";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:meta/meta.dart";

// /////////////////////////////////////////////////////////////////////////////

abstract class ImmutableCollection<C> implements CanBeEmpty {
  //
  /// In your app initialization, call [lockConfig] if you want to lock the
  /// configuration, so that no one can change it anymore.
  ///
  /// These are setters which you can use to configure and then lock:
  ///
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

  static bool _disallowUnsafeConstructors = false;

  static int _asyncCounter = 1;

  static bool _asyncCounterMarkedForIncrement = false;

  static bool _prettyPrint = true;

  static void resetAllConfigurations() {
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _autoFlush = true;
    _disallowUnsafeConstructors = false;
    _asyncCounter = 1;
    _asyncCounterMarkedForIncrement = false;
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
    _autoFlush = value ?? true;
  }

  /// Global configuration that specifies if **unsafe constructors** can be used
  /// or not. The default is `false`.
  static set disallowUnsafeConstructors(bool value) {
    if (_disallowUnsafeConstructors == value) return;
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

  static bool get prettyPrint => _prettyPrint;

  /// Global configuration that specifies if the collections should print with "pretty print".
  static set prettyPrint(bool value) {
    if (_prettyPrint == value) return;
    if (ImmutableCollection.isConfigLocked)
      throw StateError("Can't change the configuration of immutable collections.");
    _prettyPrint = value ?? true;
  }

  /// Flushes this collection, if necessary. Chainable method.
  /// If collection list is already flushed, don't do anything.
  C get flush;

  /// Whether this collection is already flushed or not.
  bool get isFlushed;

  /// Will return `true` only if the collection items are equal to the iterable
  /// items. If the collection is ordered, it will also check if the items are
  /// in the same order. This may be slow for very large collection, since it
  /// compares each item, one by one. If you can/try to compare ordered and unordered
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
  /// Comparing the internal state is better, because it will return `true` more
  /// often.
  bool same(C other);

  @override
  String toString([bool prettyPrint]);
}

// /////////////////////////////////////////////////////////////////////////////

/// While `identical(collection1, collection2)` will compare the identity of the
/// collection itself, `same(collection1, collection2)` will compare its
/// internal state by identity. Note `same` is practically as fast as
/// `identical`, but will give **less false negatives**. So it is almost always
/// recommended to use `same` instead of `identical`.
///
bool sameCollection<C extends ImmutableCollection>(C c1, C c2) {
  if (c1 == null && c2 == null) return true;
  if (c1 == null || c2 == null) return false;
  return identical(c1, c2) || c1.same(c2);
}

// /////////////////////////////////////////////////////////////////////////////

/// Your own classes can implement this so they may use [CanBeEmptyExtension].
abstract class CanBeEmpty {
  bool get isEmpty;

  bool get isNotEmpty;
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [CanBeEmpty]
extension CanBeEmptyExtension on CanBeEmpty {
  bool get isNullOrEmpty => (this == null) || isEmpty;

  bool get isNotNullOrEmpty => (this != null) && isNotEmpty;

  bool get isEmptyButNotNull => (this != null) && isEmpty;
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [compareObject], [ComparableExtension], [ComparatorExtension], [sortBy], [sortLike]
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

/// Meant to be used when you wish to save a value that's going to be tossed out of an immutable
/// collection.
///
/// See also, for example: [IList] or the `IList.removeAt()` method.
class Output<T> {
  T _value;

  T get value => _value;

  Output();

  void save(T value) {
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

/// See also: [IListExtension], [ISetExtension]
extension IterableToImmutableExtension<T> on Iterable<T> {
  //
  /// Locks the iterable, returning an *immutable* list ([IList]).
  IList<T> get lockAsList => IList<T>(this);

  /// Locks the iterable, returning an *immutable* set ([ISet]).
  ISet<T> get lockAsSet => ISet<T>(this);

  bool get isNullOrEmpty => this == null || isEmpty;

  bool get isNotNullOrEmpty => this != null && isNotEmpty;

  /// Compare all iterable items, in order, using [identical].
  /// Return true if they are the same, in the same order.
  ///
  /// Note: since this is an extension, it works with nulls:
  /// ```dart
  /// Iterable iterable1 = null;
  /// Iterable iterable2 = null;
  /// iterable1.deepIdenticalEquals(iterable2) == true;
  /// ```
  ///
  bool deepIdenticalEquals(Iterable other) {
    if (identical(this, other)) return true;
    if (this == null || other == null) return false;

    if ((this is List) && (other is List) && (length != other.length)) return false;

    var iterator1 = iterator;
    var iterator2 = other.iterator;
    while (iterator1.moveNext() && iterator2.moveNext()) {
      if (!identical(iterator1.current, iterator2.current)) return false;
    }

    return (iterator1.moveNext() || iterator2.moveNext()) ? false : true;
  }

  Set<T> findDuplicates() {
    final Set<T> duplicates = HashSet<T>();
    final Set<T> auxSet = HashSet<T>();
    for (T elements in this) {
      if (!auxSet.add(elements)) duplicates.add(elements);
    }
    return duplicates;
  }

  Iterable<T> removeNulls() sync* {
    for (T item in this) {
      if (item != null) yield item;
    }
  }

  /// Removes all duplicates, leaving only the distinct items.
  /// Optionally, you can provide a [id] function to compare the items.
  Iterable<T> removeDuplicates([dynamic Function(T item) id]) sync* {
    if (id != null) {
      Set<dynamic> ids = {};
      for (T item in this) {
        var _id = id(item);
        if (!ids.contains(_id)) yield item;
        ids.add(_id);
      }
    } else {
      Set<T> items = {};
      for (T item in this) {
        if (!items.contains(item)) yield item;
        items.add(item);
      }
    }
  }

  Iterable<T> removeNullAndDuplicates() sync* {
    Set<T> items = {};
    for (T item in this) {
      if (item != null && !items.contains(item)) yield item;
      items.add(item);
    }
  }

  /// Return a list with the same items as this [Iterable], where the list items appear
  /// in the same order as [order]. The items which don't exist in [order] will be put
  /// in the end, in any order.
  ///
  /// Note: Not very efficient at the moment. Please use for a small number of items.
  ///
  List<T> orderAs(List<T> order) {
    Set<T> originalSet = Set.of(order);
    Set<T> newSet = (this is Set<T>) ? (this as Set<T>) : Set.of(this);
    Set<T> intersection = originalSet.intersection(newSet);
    Set<T> difference = newSet.difference(originalSet);
    List<T> result = order.where((element) => intersection.contains(element)).toList();
    result.addAll(difference);
    return result;
  }
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [IterableToImmutableExtension]
extension IteratorExtension<T> on Iterator<T> {
  //
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  Set<T> toSet() => Set.of(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////

/// See also: [IterableToImmutableExtension], [IteratorExtension]
extension MapIteratorExtension<K, V> on Iterator<MapEntry<K, V>> {
  //
  Iterable<MapEntry<K, V>> toIterable() sync* {
    while (moveNext()) yield current;
  }

  Map<K, V> toMap() => Map.fromEntries(toIterable());
}

// /////////////////////////////////////////////////////////////////////////////
