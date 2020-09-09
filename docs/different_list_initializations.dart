/// To run this, you can simply use:
///
/// ```sh
/// dart docs/different_list_initializations.dart
/// ```

/// For more, check out the [`List` docs][list_docs].
/// The `UnmodifiableListMixin` and `FixedLengthListMixin` are actually
/// abstract classes, not mixins. They are both inside
/// [`sdk/lib/internal/list.dart`][list_internal]
void main() {
  final List<int> emptyOfList = List.of([]); // `List<int>`
  const List<int> constList = []; // `List<int>`
  final List<int> ungrowableList = List.of([], growable: false); // `List<int>`
  final List<int> unmodifiableList = List.unmodifiable([]); // `List<int>`
  final List<int> fixedLengthList = List(1); // `List<int>`

  emptyOfList.add(1); // No errors.

  try {
    constList.add(1); // `UnmodifiableListMixin.add`
  } on UnsupportedError catch (_) {
    // Cannot add to an unmodifiable list
  }

  try {
    ungrowableList.add(1); // `FixedLengthListMixin.add`
  } on UnsupportedError catch (_) {
    // Cannot add to a fixed-length list
  }

  try {
    unmodifiableList.add(1); // `UnmodifiableListMixin.add`
  } on UnsupportedError catch (_) {
    // Cannot add to an unmodifiable list
  }

  try {
    fixedLengthList.add(1); // `FixedLengthListMixin.add`
  } on UnsupportedError catch (_) {
    // Cannot add to a fixed-length list
  }
}

/// [list_docs]: https://api.dart.dev/stable/2.9.3/dart-core/List-class.html
/// [list_internal]: https://github.com/dart-lang/sdk/blob/
/// d44457f79d087b52a0468609d44013e5fd9f09f0/sdk/lib/internal/list.dart
