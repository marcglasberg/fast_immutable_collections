/// Data objects for working with immutable collections in Dart and Flutter.
/// {@category Collections, Immutable, Flutter}
library fast_immutable_collections;

export "src/base/immutable_collection.dart";
export "src/base/configs.dart";
export "src/base/sort_by.dart";

// IList:
export "src/ilist/ilist.dart";
export "src/ilist/ilist_extension.dart";
export "src/ilist/from_ilist_mixin.dart";
export "src/ilist/ilist_of_2.dart";
export "src/ilist/from_iterable_ilist_mixin.dart";
export "src/ilist/modifiable_list_view.dart";
export "src/ilist/unmodifiable_list_view.dart";

// IMap:
export "src/imap/imap.dart";
export "src/imap/imap_extension.dart";
export "src/imap/entry.dart";
export "src/imap/modifiable_map_view.dart";
export "src/imap/unmodifiable_map_view.dart";

// IMapOfSets:
export "src/imap_of_sets/imap_of_sets.dart";

// ISet:
export "src/iset/iset.dart";
export "src/iset/iset_extension.dart";
export "src/iset/modifiable_set_view.dart";
export "src/iset/unmodifiable_set_view.dart";
