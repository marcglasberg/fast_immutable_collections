import "../ilist/ilist.dart";
import "../iset/iset.dart";

/// See also: [FicIterableExtension]
extension FicIteratorExtension<T> on Iterator<T> {
  //
  /// Convert this iterator into an [Iterable].
  Iterable<T> toIterable() sync* {
    while (moveNext()) yield current;
  }

  /// Convert this iterator into a [List].
  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  /// Convert this iterator into a [Set].
  Set<T> toSet() => Set.of(toIterable());

  /// Convert this iterator into an [IList].
  IList<T> toIList() => IList(toIterable());

  /// Convert this iterator into an [ISet].
  ISet<T> toISet() => ISet(toIterable());
}
