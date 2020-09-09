/// To run this, you can simply use:
///
/// ```sh
/// dart docs/different_fixed_list_initializations.dart
/// ```

/// For more, check out the [`List` docs][list_docs].
/// 
/// The `UnmodifiableListMixin` and `FixedLengthListMixin` are actually
/// abstract classes, not mixins. They are both inside
/// [`sdk/lib/internal/list.dart`][list_internal].
/// 
/// Note that the only way of working with an empty `const` `List` is by using 
/// `const []`, which uses the `UnmodifiableListMixin` in the background.
/// 
/// | List Constructor | Underlying Implementation |
/// |------------------|---------------------------|
/// | `const`          | `UnmodifiableListMixin`   |
/// | `default`        | `FixedLengthMixin`        |
/// | `empty`          | `FixedLengthMixin`        |
/// | `filled`         | `FixedLengthMixin`        |
/// | `from`           | `FixedLengthMixin`        |
/// | `generate`       | `FixedLengthMixin`        |
/// | `of`             | `FixedLengthMixin`        |
/// | `unmodifiable`   | `UnmodifiableListMixin`   |
void main() {
  <String, List<int>>{
    'const': const [],
    'default': List(0),
    'empty': List.empty(growable: false),
    'filled': List.filled(0, null, growable: false),
    'from': List.from([], growable: false),
    'generate': List.generate(0, (_) => null, growable: false),
    'of': List.of([], growable: false),
    'unmodifiable': List.unmodifiable([]),
  }.forEach((String listName, List<int> list) {
    try {
      list.add(1);
    } on UnsupportedError catch(e) {
      print('$listName | ${e.message}');
    }
  });
}

/// [list_docs]: https://api.dart.dev/stable/2.9.3/dart-core/List-class.html
/// [list_internal]: https://github.com/dart-lang/sdk/blob/
/// d44457f79d087b52a0468609d44013e5fd9f09f0/sdk/lib/internal/list.dart
