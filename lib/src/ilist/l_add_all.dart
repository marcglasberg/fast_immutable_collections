// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

import "package:fast_immutable_collections/src/iterator/iterator_add_all.dart";

import "ilist.dart";

/// First we have the items in [_l] and then the items in [_listOrL].
///
class LAddAll<T> extends L<T> {
  //
  final L<T> _l;

  // Will always store this as `List` or [L].
  final Iterable<T> _listOrL;

  /// **Safe**.
  /// Note: If you need to pass an [IList], pass its [L] instead.
  LAddAll(this._l, Iterable<T> items)
      : assert(items is! IList),
        _listOrL = (items is L<T>) ? items : List<T>.of(items, growable: false);

  @override
  bool get isEmpty => _l.isEmpty && _listOrL.isEmpty;

  @override
  Iterator<T> get iterator => IteratorAddAll(_l.iterator, _listOrL.iterator);

  @override
  Iterable<T> get iter => _l.followedBy(_listOrL);

  @override
  bool contains(covariant T? element) => _l.contains(element) || _listOrL.contains(element);

  @override
  T operator [](int index) {
    final length1 = _l.length;
    final length2 = _listOrL.length;
    final length = length1 + length2;

    if (index < 0 || index >= length) {
      return throw RangeError.range(index, 0, length - 1, "index");
    } else {
      return index < length1
          ? _l[index]
          : (_listOrL is List<T>)
              ? _listOrL[index - length1]
              : (_listOrL as L<T>)[index - length1];
    }
  }

  @override
  int get length => _l.length + _listOrL.length;

  @override
  T get first => _l.isNotEmpty ? _l.first : _listOrL.first;

  @override
  T get last => _listOrL.isNotEmpty ? _listOrL.last : _l.last;

  @override
  T get single => _l.isNotEmpty ? _l.single : _listOrL.single;
}
