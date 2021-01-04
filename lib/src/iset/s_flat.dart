import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

class SFlat<T> extends S<T> {
  final Set<T> _set;

  static S<T> empty<T>() => SFlat.unsafe(<T>{});

  SFlat(Iterable<T> iterable)
      : assert(iterable != null),
        _set = Set.of(iterable);

  SFlat.unsafe(this._set) : assert(_set != null);

  @override
  Set<T> get getFlushed => _set;

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  Iterable<T> get iter => _set;

  @override
  T get anyItem => _set.first;

  @override
  bool contains(Object element) => _set.contains(element);

  @override
  int get length => _set.length;

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T get single => _set.single;

  bool deepSetEquals_toIterable(Iterable<T> other) {
    if (other == null) return false;
    Set<T> set = (other is Set<T>) ? other : Set<T>.of(other);
    return const SetEquality(MapEntryEquality()).equals(_set, set);
  }

  bool deepSetEquals(SFlat<T> other) =>
      (other == null) ? false : const SetEquality(MapEntryEquality()).equals(_set, other._set);

  int deepSetHashcode() => const SetEquality(MapEntryEquality()).hash(_set);
}
