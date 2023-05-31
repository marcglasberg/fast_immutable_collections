// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:collection/collection.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import 'package:fast_immutable_collections/src/iset/iset.dart';

class SFlat<T> extends S<T> {
  final ListSet<T> _set;

  static S<T> empty<T>() => SFlat.unsafe(ListSet<T>.empty());

  /// **Safe**. Note: This will sort according to the configuration.
  SFlat(Iterable<T> iterable, {ConfigSet? config})
      : _set = ListSet.of(iterable, sort: (config ?? ISet.defaultConfig).sort);

  /// **Unsafe**. Note: Does not sort.
  SFlat.unsafe(Set<T> set) : _set = ListSet.unsafeView(set);

  @override
  ListSet<T> getFlushed(ConfigSet? config) => _set;

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  Iterable<T> get iter => _set;

  @override
  T get anyItem => _set.first;

  @override
  bool contains(covariant T? element) => _set.contains(element);

  @override
  bool containsAll(Iterable<T> element) => _set.containsAll(element);

  @override
  T? lookup(Object? object) => _set.lookup(object);

  @override
  Set<T> difference(Set<T> other) => _set.difference(other);

  @override
  Set<T> intersection(Set<T> other) => _set.intersection(other);

  @override
  Set<T> union(Set<T> other) => _set.union(other);

  @override
  int get length => _set.length;

  @override
  T get first => _set.first;

  @override
  T get last => _set.last;

  @override
  T get single => _set.single;

  @override
  T operator [](int index) => _set[index];

  bool deepSetEqualsToIterable(Iterable? other) {
    if (other == null) return false;
    final Set set = (other is Set) ? other : Set<dynamic>.of(other);
    return const SetEquality<dynamic>(MapEntryEquality<dynamic>()).equals(_set, set);
  }

  bool deepSetEquals(SFlat? other) =>
      (other != null) &&
      const SetEquality<dynamic>(MapEntryEquality<dynamic>()).equals(_set, other._set);

  int deepSetHashcode() => const SetEquality<dynamic>(MapEntryEquality<dynamic>()).hash(_set);
}
