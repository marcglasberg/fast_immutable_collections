// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "../ilist/ilist.dart";
import "../iset/iset.dart";

/// See also: [FicIterableExtension]
extension FicIteratorExtension<T> on Iterator<T> {
  //
  /// Convert this iterator into an [Iterable].
  Iterable<T> toIterable() sync* {
    while (moveNext()) {
      yield current;
    }
  }

  /// Convert this iterator into a [List].
  List<T> toList({bool growable = true}) => List.of(toIterable(), growable: growable);

  /// Convert this iterator into a [Set].
  Set<T> toSet() => Set.of(toIterable());

  /// Convert this iterator into an [IList].
  IList<T> toIList() {
    return IList(toIterable());
  }

  /// Convert this iterator into an [ISet].
  ISet<T> toISet() => ISet(toIterable());
}
