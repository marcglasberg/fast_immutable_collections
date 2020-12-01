import "dart:collection";

import "package:meta/meta.dart";

import "../base/immutable_collection.dart";
import "iset.dart";
import "iset_extension.dart";

/// The [UnmodifiableSetView] is a relatively safe, unmodifiable [Set] that is built from an
/// [ISet] or another [Set]. The construction of the [UnmodifiableSetView] is very fast,
/// since it makes no copies of the given set items, but just uses it directly.
///
/// If you try to use methods that modify the [UnmodifiableSetView], like [add],
/// it will throw an [UnsupportedError].
///
/// If you create it from an [ISet], it is also very fast to lock the [UnmodifiableSetView]
/// back into an [ISet].
///
/// <br>
///
/// ## How does it compare to [Set.unmodifiable]?
///
/// [Set.unmodifiable] is slow, but it's always safe, because *it is not a view*, and
/// actually creates a new set. On the other hand, [UnmodifiableSetView] is fast, but if
/// you create it from a regular [Set] and then modify that original [Set], you will also
/// be modifying the view. Also note, if you create an [UnmodifiableSetView] from an [ISet],
/// then it's totally safe because the original [ISet] can't be modified &mdash; unless of course,
/// again, you've created it from a [ISet.unsafe] constructor.
///
/// See also: [ModifiableSetView]
@immutable
class UnmodifiableSetView<T> with SetMixin<T> implements Set<T>, CanBeEmpty {
  final ISet<T> _iSet;
  final Set<T> _set;

  /// Create an unmodifiable [Set] view of type [UnmodifiableSetView], from an [iset].
  UnmodifiableSetView(ISet<T> iset)
      : _iSet = iset ?? ISet.empty<T>(),
        _set = null;

  /// Create an unmodifiable [Set] view of type [UnmodifiableSetView], from another [Set].
  UnmodifiableSetView.fromSet(Set<T> set)
      : _iSet = null,
        _set = set;

  @override
  bool add(T value) => throw UnsupportedError("Set is unmodifiable.");

  @override
  bool contains(Object element) => _iSet?.contains(element) ?? _set.contains(element);

  @override
  T lookup(Object element) =>
      _iSet != null && _iSet.contains(element) || _set != null && _set.contains(element)
          ? element as T
          : null;

  @override
  bool remove(Object value) => throw UnsupportedError("Set is unmodifiable.");

  @override
  Iterator<T> get iterator => _set?.iterator ?? _iSet.iterator;

  @override
  Set<T> toSet() => _set ?? _iSet.toSet();

  @override
  int get length => _iSet?.length ?? _set.length;

  ISet<T> get lock => _iSet ?? _set.lock;
}
