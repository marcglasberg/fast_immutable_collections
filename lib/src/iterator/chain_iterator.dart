// Developed by Marcelo Glasberg (2021) https://glasberg.dev and https://github.com/marcglasberg
// and Philippe Fanaro https://github.com/psygo
// For more info, see: https://pub.dartlang.org/packages/fast_immutable_collections

/// A node in a chain of nodes, like the ones created by `add` and `addAll`.
/// Each node points to the node [below] it, and has its own items, which come
/// after the items of the nodes below it.
abstract interface class ChainNode {
  /// The node below this one, or `null` if this is the bottom node of the chain.
  ChainNode? get below;

  /// The number of items of this node only (not counting the nodes below it).
  int get ownLength;
}

/// Receives the own items of a [ChainNode] (not counting the nodes below it),
/// as a list, a single item, or an iterable.
abstract interface class ChainItemsReceiver<T> {
  void receiveList(List<T> list);

  void receiveItem(T item);

  void receiveIterable(Iterable<T> iterable);
}

/// Sends the own items of the [node] to the [receiver].
///
/// Note: The [receiver] is a `ChainItemsReceiver<Object?>` because the node may
/// be of a more specific type than the nodes above it (like `int` below `int?`).
typedef ChainSender = void Function(ChainNode node, ChainItemsReceiver<Object?> receiver);

/// Goes through the nodes of a chain from the bottom node up.
///
/// The difficulty is that each node points only to the node below it. To avoid
/// remembering all the nodes of the chain, we split it in halves: we remember
/// where the upper half starts, and continue splitting the lower half, until it
/// has at most [_maxSegmentLength] nodes. We go through those few nodes by
/// walking down from the top of the segment to each one. Then we continue with
/// the last upper half we remembered, and so on.
///
/// This way we remember at most log2(n) nodes at the same time, for a chain of
/// n nodes, and each node is walked over about log2(n) times. Also, this
/// doesn't use recursion, so it works for chains of any length.
class ChainNodes {
  static const int _maxSegmentLength = 8;

  // The segments of nodes we still have to go through, as a stack:
  // the top node of each segment, and how many nodes it has.
  List<ChainNode?>? _segmentTops;
  List<int>? _segmentLengths;
  int _segmentCount = 0;

  // The segment we are going through: its top node, and how many of its
  // nodes are left (we go through them from the bottom up).
  late ChainNode _top;
  int _remaining = 0;

  ChainNodes(ChainNode top) {
    int length = 1;
    for (ChainNode? node = top.below; node != null; node = node.below) length++;
    _split(top, length);
  }

  /// Returns the next node (going up), or `null` if there are no more nodes.
  ChainNode? next() {
    if (_remaining == 0) {
      if (_segmentCount == 0) return null;
      _segmentCount--;
      final ChainNode top = _segmentTops![_segmentCount]!;
      _segmentTops![_segmentCount] = null;
      _split(top, _segmentLengths![_segmentCount]);
    }
    _remaining--;
    ChainNode node = _top;
    for (int i = 0; i < _remaining; i++) node = node.below!;
    return node;
  }

  /// Prepares to go through the segment of [length] nodes that starts at [top]
  /// (going down). Remembers the upper halves for later, until the remaining
  /// lower part has at most [_maxSegmentLength] nodes.
  void _split(ChainNode top, int length) {
    while (length > _maxSegmentLength) {
      // The first split is the longest, and each split halves the length,
      // so the stack never needs more than `length.bitLength` positions.
      final List<ChainNode?> tops = _segmentTops ??= List.filled(length.bitLength, null);
      final List<int> lengths = _segmentLengths ??= List.filled(length.bitLength, 0);
      final int upperLength = length ~/ 2;
      tops[_segmentCount] = top;
      lengths[_segmentCount++] = upperLength;
      for (int i = 0; i < upperLength; i++) top = top.below!;
      length -= upperLength;
    }
    _top = top;
    _remaining = length;
  }
}

/// Iterates the items of a chain of [ChainNode]s, from the bottom node up.
///
/// The usual way would be to nest one iterator per node, but then each item
/// goes through the iterators of all the nodes above it, which is slow for
/// long chains. Instead, this iterator reads each item only once, directly
/// from the node that has it. See [ChainNodes].
class ChainIterator<T> implements Iterator<T>, ChainItemsReceiver<T> {
  static const int _beforeFirst = 0, _hasCurrent = 1, _finished = 2;

  final ChainNodes _nodes;
  final ChainSender _send;

  // The own items of the current node, as a list, a single item, or an iterator.
  List<T>? _list;
  int _index = 0;
  bool _hasItem = false;
  T? _item;
  Iterator<T>? _iterator;

  late T _current;
  int _state = _beforeFirst;

  ChainIterator(ChainNode top, this._send) : _nodes = ChainNodes(top);

  @override
  void receiveList(List<T> list) {
    _list = list;
    _index = 0;
  }

  @override
  void receiveItem(T item) {
    _item = item;
    _hasItem = true;
  }

  @override
  void receiveIterable(Iterable<T> iterable) => _iterator = iterable.iterator;

  @override
  T get current {
    if (_state == _hasCurrent) return _current;
    throw StateError((_state == _beforeFirst)
        ? "No current value available. Call moveNext() first."
        : "No move values available.");
  }

  @override
  bool moveNext() {
    if (_state == _finished) return false;
    while (true) {
      final List<T>? list = _list;
      if (list != null) {
        if (_index < list.length) {
          _current = list[_index++];
          _state = _hasCurrent;
          return true;
        }
        _list = null;
      }
      //
      else if (_hasItem) {
        _hasItem = false;
        _current = _item as T;
        _item = null;
        _state = _hasCurrent;
        return true;
      }
      //
      else {
        final Iterator<T>? iterator = _iterator;
        if (iterator != null) {
          if (iterator.moveNext()) {
            _current = iterator.current;
            _state = _hasCurrent;
            return true;
          }
          _iterator = null;
        }
      }

      final ChainNode? node = _nodes.next();
      if (node == null) {
        _state = _finished;
        return false;
      }
      _send(node, this);
    }
  }
}

/// The items of a chain of [ChainNode]s, from the bottom node up.
///
/// It's created in constant time, without recursion, and its methods work for
/// chains of any length. Methods like [forEach], [toList] and [contains] use
/// the own items of each node directly (for example, a list), which is faster
/// than iterating. Methods like [first], [last] and [elementAt] first find the
/// node that has the item, using the [ChainNode.ownLength] of the nodes.
class ChainIterable<T> extends Iterable<T> {
  final ChainNode _top;
  final ChainSender _send;

  /// Whether each node has [ChainNode.ownLength] items in this iterable.
  /// This is false after [where], which removes items.
  final bool _hasOwnLengths;

  ChainIterable(this._top, this._send) : _hasOwnLengths = true;

  ChainIterable._(this._top, this._send, this._hasOwnLengths);

  @override
  Iterator<T> get iterator => ChainIterator<T>(_top, _send);

  /// Sends the items of all nodes to the [receiver], from the bottom node up,
  /// until the receiver is done.
  void _sendAll(_Receiver<T> receiver) {
    final ChainNodes nodes = ChainNodes(_top);
    for (ChainNode? node = nodes.next(); node != null; node = nodes.next()) {
      _send(node, receiver);
      if (receiver.isDone) return;
    }
  }

  @override
  int get length {
    if (!_hasOwnLengths) {
      final _LengthReceiver<T> receiver = _LengthReceiver<T>();
      _sendAll(receiver);
      return receiver.length;
    }
    int length = 0;
    for (ChainNode? node = _top; node != null; node = node.below) length += node.ownLength;
    return length;
  }

  @override
  bool get isEmpty {
    if (!_hasOwnLengths) return !iterator.moveNext();
    for (ChainNode? node = _top; node != null; node = node.below) {
      if (node.ownLength != 0) return false;
    }
    return true;
  }

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  T get first {
    if (!_hasOwnLengths) return super.first;
    ChainNode? lowest;
    for (ChainNode? node = _top; node != null; node = node.below) {
      if (node.ownLength != 0) lowest = node;
    }
    if (lowest == null) throw StateError("No element");
    return _itemOf(lowest, 0);
  }

  @override
  T get last {
    if (!_hasOwnLengths) return super.last;
    for (ChainNode? node = _top; node != null; node = node.below) {
      final int ownLength = node.ownLength;
      if (ownLength != 0) return _itemOf(node, ownLength - 1);
    }
    throw StateError("No element");
  }

  /// Any item, which is the fastest to get: the first item of the top node
  /// that has items.
  T get anyItem {
    if (!_hasOwnLengths) return first;
    for (ChainNode? node = _top; node != null; node = node.below) {
      if (node.ownLength != 0) return _itemOf(node, 0);
    }
    throw StateError("No element");
  }

  @override
  T get single {
    if (!_hasOwnLengths) return super.single;
    final int length = this.length;
    if (length == 1) return first;
    throw StateError((length == 0) ? "No element" : "Too many elements");
  }

  @override
  T elementAt(int index) {
    if (!_hasOwnLengths) return super.elementAt(index);
    RangeError.checkNotNegative(index, "index");
    final int length = this.length;
    if (index >= length) throw IndexError.withLength(index, length, indexable: this);
    int end = length;
    for (ChainNode? node = _top; node != null; node = node.below) {
      final int start = end - node.ownLength;
      if (index >= start) return _itemOf(node, index - start);
      end = start;
    }
    throw StateError("Unreachable");
  }

  /// Returns the item at [index] of the own items of the [node].
  T _itemOf(ChainNode node, int index) {
    final _ElementAtReceiver<T> receiver = _ElementAtReceiver<T>(index);
    _send(node, receiver);
    return receiver.item as T;
  }

  @override
  bool contains(Object? element) {
    final _ContainsReceiver<T> receiver = _ContainsReceiver<T>(element);
    for (ChainNode? node = _top; node != null; node = node.below) {
      _send(node, receiver);
      if (receiver.isDone) return true;
    }
    return false;
  }

  @override
  void forEach(void Function(T element) action) => _sendAll(_ForEachReceiver<T>(action));

  @override
  bool any(bool Function(T element) test) {
    final _AnyReceiver<T> receiver = _AnyReceiver<T>(test);
    _sendAll(receiver);
    return receiver.isDone;
  }

  @override
  bool every(bool Function(T element) test) => !any((T element) => !test(element));

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) {
    R value = initialValue;
    forEach((T element) => value = combine(value, element));
    return value;
  }

  @override
  List<T> toList({bool growable = true}) {
    if (!growable && _hasOwnLengths) return _toFixedLengthList();
    final _ToListReceiver<T> receiver = _ToListReceiver<T>();
    _sendAll(receiver);
    final List<T> result = receiver.result ?? <T>[];
    return growable ? result : List<T>.of(result, growable: false);
  }

  /// Creates a fixed-length list with the final length, and fills it walking
  /// down the chain, each node writing its own items directly into their final
  /// positions. This avoids creating a growable list and then copying it.
  ///
  /// If the bottom node has a list, the result is created with `List.generate`,
  /// copying that list in a single pass. That's faster than `List.filled`
  /// followed by `setRange`, which writes all positions twice.
  List<T> _toFixedLengthList() {
    int length = 0;
    ChainNode bottom = _top;
    for (ChainNode? node = _top; node != null; node = node.below) {
      length += node.ownLength;
      bottom = node;
    }
    if (length == 0) return List<T>.empty();

    final _FixedLengthListReceiver<T> receiver = _FixedLengthListReceiver<T>(length);

    final _BottomListReceiver<T> bottomReceiver = _BottomListReceiver<T>();
    _send(bottom, bottomReceiver);
    final List<T>? bottomList = bottomReceiver.list;
    final bool isBottomCopied = (bottomList != null) && bottomList.isNotEmpty;
    if (isBottomCopied) {
      final int bottomLength = bottomList.length;
      final T filler = bottomList[0]; // Any item works, since these positions are overwritten.
      receiver.result = List<T>.generate(
          length, (int index) => (index < bottomLength) ? bottomList[index] : filler,
          growable: false);
    }

    int end = length;
    for (ChainNode? node = _top; node != null; node = node.below) {
      if (isBottomCopied && identical(node, bottom)) break;
      final int ownLength = node.ownLength;
      if (ownLength == 0) continue;
      end -= ownLength;
      receiver.start = end;
      _send(node, receiver);
    }
    return receiver.result!;
  }

  @override
  Set<T> toSet() {
    final Set<T> result = <T>{};
    forEach(result.add);
    return result;
  }

  @override
  String join([String separator = ""]) {
    final StringBuffer buffer = StringBuffer();
    bool isFirst = true;
    forEach((T element) {
      if (!isFirst) buffer.write(separator);
      isFirst = false;
      buffer.write(element);
    });
    return buffer.toString();
  }

  @override
  Iterable<T> where(bool Function(T element) test) => ChainIterable<T>._(
        _top,
        (ChainNode node, ChainItemsReceiver<Object?> receiver) =>
            _send(node, _WhereReceiver<T>(receiver, test)),
        false,
      );

  @override
  Iterable<R> map<R>(R Function(T element) toElement) => ChainIterable<R>._(
        _top,
        (ChainNode node, ChainItemsReceiver<Object?> receiver) =>
            _send(node, _MapReceiver<T, R>(receiver, toElement)),
        _hasOwnLengths,
      );
}

/// A receiver that may be done before receiving the items of all nodes.
abstract class _Receiver<T> implements ChainItemsReceiver<T> {
  bool isDone = false;
}

class _LengthReceiver<T> extends _Receiver<T> {
  int length = 0;

  @override
  void receiveList(List<T> list) => length += list.length;

  @override
  void receiveItem(T item) => length++;

  @override
  void receiveIterable(Iterable<T> iterable) => length += iterable.length;
}

class _ElementAtReceiver<T> extends _Receiver<T> {
  final int index;
  Object? item;

  _ElementAtReceiver(this.index);

  @override
  void receiveList(List<T> list) => item = list[index];

  @override
  void receiveItem(T item) => this.item = item;

  @override
  void receiveIterable(Iterable<T> iterable) => item = iterable.elementAt(index);
}

class _ContainsReceiver<T> extends _Receiver<T> {
  final Object? element;

  _ContainsReceiver(this.element);

  @override
  void receiveList(List<T> list) => isDone = list.contains(element);

  @override
  void receiveItem(T item) => isDone = (item == element);

  @override
  void receiveIterable(Iterable<T> iterable) => isDone = iterable.contains(element);
}

class _ForEachReceiver<T> extends _Receiver<T> {
  final void Function(T element) action;

  _ForEachReceiver(this.action);

  @override
  void receiveList(List<T> list) => list.forEach(action);

  @override
  void receiveItem(T item) => action(item);

  @override
  void receiveIterable(Iterable<T> iterable) => iterable.forEach(action);
}

class _AnyReceiver<T> extends _Receiver<T> {
  final bool Function(T element) test;

  _AnyReceiver(this.test);

  @override
  void receiveList(List<T> list) => isDone = list.any(test);

  @override
  void receiveItem(T item) => isDone = test(item);

  @override
  void receiveIterable(Iterable<T> iterable) => isDone = iterable.any(test);
}

class _ToListReceiver<T> extends _Receiver<T> {
  List<T>? result;

  @override
  void receiveList(List<T> list) {
    final List<T>? result = this.result;
    if (result == null)
      this.result = List<T>.of(list);
    else
      result.addAll(list);
  }

  @override
  void receiveItem(T item) => (result ??= <T>[]).add(item);

  @override
  void receiveIterable(Iterable<T> iterable) {
    final List<T>? result = this.result;
    if (result == null)
      this.result = List<T>.of(iterable);
    else
      result.addAll(iterable);
  }
}

/// Writes the own items of a node into the [result], starting at index [start].
///
/// The [result] is created when the first item arrives, using that item as the
/// initial value of all positions (they are all overwritten). This way we don't
/// need to read an extra item, which could call a function given to `map` one
/// extra time.
class _FixedLengthListReceiver<T> extends _Receiver<T> {
  final int length;
  int start = 0;
  List<T>? result;

  _FixedLengthListReceiver(this.length);

  @override
  void receiveList(List<T> list) {
    if (list.isEmpty) return;
    (result ??= List<T>.filled(length, list[0])).setRange(start, start + list.length, list);
  }

  @override
  void receiveItem(T item) => (result ??= List<T>.filled(length, item))[start] = item;

  /// Note: We don't use `setRange` here, because for an iterable which is not a
  /// list it first copies the iterable into a new list.
  @override
  void receiveIterable(Iterable<T> iterable) {
    int index = start;
    for (final T item in iterable) {
      (result ??= List<T>.filled(length, item))[index++] = item;
    }
  }
}

/// Keeps the own items of the bottom node, if they were sent as a list.
class _BottomListReceiver<T> extends _Receiver<T> {
  List<T>? list;

  @override
  void receiveList(List<T> list) => this.list = list;

  @override
  void receiveItem(T item) {}

  @override
  void receiveIterable(Iterable<T> iterable) {}
}

/// Sends to the [receiver] only the items that satisfy the [test].
class _WhereReceiver<T> implements ChainItemsReceiver<T> {
  final ChainItemsReceiver<Object?> receiver;
  final bool Function(T element) test;

  _WhereReceiver(this.receiver, this.test);

  @override
  void receiveList(List<T> list) => receiver.receiveIterable(list.where(test));

  @override
  void receiveItem(T item) {
    if (test(item)) receiver.receiveItem(item);
  }

  @override
  void receiveIterable(Iterable<T> iterable) => receiver.receiveIterable(iterable.where(test));
}

/// Sends to the [receiver] the items transformed by [toElement].
///
/// Note: `map<R>` must have an explicit type, otherwise it's inferred from the
/// context as `map<Object?>`, since the [receiver] receives `Object?` items.
class _MapReceiver<T, R> implements ChainItemsReceiver<T> {
  final ChainItemsReceiver<Object?> receiver;
  final R Function(T element) toElement;

  _MapReceiver(this.receiver, this.toElement);

  @override
  void receiveList(List<T> list) => receiver.receiveIterable(list.map<R>(toElement));

  @override
  void receiveItem(T item) => receiver.receiveItem(toElement(item));

  @override
  void receiveIterable(Iterable<T> iterable) =>
      receiver.receiveIterable(iterable.map<R>(toElement));
}
