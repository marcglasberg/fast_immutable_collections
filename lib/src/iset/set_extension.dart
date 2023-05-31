// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:collection/collection.dart";

import "iset.dart";

/// See also: [FicListExtension]
extension FicSetExtension<T> on Set<T> {
  /// Locks the set, returning an *immutable* set ([ISet]).
  ISet<T> get lock => ISet<T>(this);

  /// Locks the set, returning an *immutable* set ([ISet]).
  ///
  /// **This is unsafe: Use it at your own peril**.
  ///
  /// This constructor is fast, since it makes no defensive copies of the set.
  /// However, you should only use this with a new set you"ve created yourself,
  /// when you are sure no external copies exist. If the original set is modified,
  /// it will break the [ISet] and any other derived sets in unpredictable ways.
  ///
  /// Note you can optionally disallow unsafe constructors in the global configuration
  /// by doing: `ImmutableCollection.disallowUnsafeConstructors = true` (and then optionally
  /// preventing further configuration changes by calling `lockConfig()`).
  ///
  /// See also: [ImmutableCollection]
  ISet<T> get lockUnsafe => ISet<T>.unsafe(this, config: ISet.defaultConfig);

  /// If the item doesn't exist in the set, add it and return `true`.
  /// Otherwise, if the item already exists in the set, remove it and return `false`.
  bool toggle(T item) {
    final result = contains(item);
    if (result)
      remove(item);
    else
      add(item);
    return !result;
  }

  /// Removes all `null`s from the [Set].
  ///
  /// See also: [whereNotNull] in [FicIterableExtension] for a lazy version.
  ///
  void removeNulls() {
    removeWhere((element) => element == null);
  }

  /// Given this set and [other], returns:
  ///
  /// 1) Items of this set which are NOT in [other] (difference this - other), in this set"s order.
  /// 2) Items of [other] which are NOT in this set (difference other - this), in [other]"s order.
  /// 3) Items of this set which are also in [other], in this set"s order.
  /// 4) Items of this set which are also in [other], in [other]"s order.
  ///
  DiffAndIntersectResult<T, G> diffAndIntersect<G>(
    Set<G> other, {
    bool diffThisMinusOther = true,
    bool diffOtherMinusThis = true,
    bool intersectThisWithOther = true,
    bool intersectOtherWithThis = true,
  }) {
    final List<T>? _diffThisMinusOther = diffThisMinusOther ? [] : null;
    final List<G>? _diffOtherMinusThis = diffOtherMinusThis ? [] : null;
    final List<T>? _intersectThisWithOther = intersectThisWithOther ? [] : null;
    final List<T>? _intersectOtherWithThis = intersectOtherWithThis ? [] : null;

    if (diffThisMinusOther || intersectThisWithOther)
      for (final element in this) {
        if (other.contains(element)) {
          _intersectThisWithOther?.add(element);
        } else
          _diffThisMinusOther?.add(element);
      }

    if (diffOtherMinusThis || intersectOtherWithThis)
      for (final element in other) {
        if (contains(element))
          _intersectOtherWithThis?.add(element as T);
        else
          _diffOtherMinusThis?.add(element);
      }

    return DiffAndIntersectResult(
      diffThisMinusOther: _diffThisMinusOther,
      diffOtherMinusThis: _diffOtherMinusThis,
      intersectThisWithOther: _intersectThisWithOther,
      intersectOtherWithThis: _intersectOtherWithThis,
    );
  }
}

class DiffAndIntersectResult<T, G> {
  final List<T>? diffThisMinusOther;
  final List<G>? diffOtherMinusThis;
  final List<T>? intersectThisWithOther;
  final List<T>? intersectOtherWithThis;

  DiffAndIntersectResult({
    this.diffThisMinusOther,
    this.diffOtherMinusThis,
    this.intersectThisWithOther,
    this.intersectOtherWithThis,
  });

  @override
  String toString() => "DiffAndIntersectResult{\n"
      "diffThisMinusOther: $diffThisMinusOther,\n"
      "diffOtherMinusThis: $diffOtherMinusThis,\n"
      "intersectThisWithOther: $intersectThisWithOther,\n"
      "intersectOtherWithThis: $intersectOtherWithThis\n"
      "}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiffAndIntersectResult &&
          const ListEquality().equals(diffThisMinusOther, other.diffThisMinusOther) &&
          const ListEquality().equals(diffOtherMinusThis, other.diffOtherMinusThis) &&
          const ListEquality().equals(intersectThisWithOther, other.intersectThisWithOther) &&
          const ListEquality().equals(intersectOtherWithThis, other.intersectOtherWithThis);

  @override
  int get hashCode =>
      const ListEquality().hash(diffThisMinusOther) ^
      const ListEquality().hash(diffOtherMinusThis) ^
      const ListEquality().hash(intersectThisWithOther) ^
      const ListEquality().hash(intersectOtherWithThis);
}
