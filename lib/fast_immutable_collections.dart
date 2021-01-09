/// Data objects for working with immutable collections in Dart and Flutter.
/// {@category Collections, Immutable, Flutter}
library fast_immutable_collections;

// Base:
export "src/base/immutable_collection.dart";
export "src/base/configs.dart";
export "src/base/sort.dart";
export "src/base/map_entry_equality.dart";
export "src/base/iterable_extension.dart";
export "src/base/other_extensions.dart";

// IList:
export "src/ilist/ilist.dart";
export "src/ilist/list_extension.dart";
export "src/ilist/from_ilist_mixin.dart";
export "src/ilist/ilist_of_2.dart";
export "src/ilist/from_iterable_ilist_mixin.dart";
export "src/ilist/modifiable_list_from_ilist.dart";
export "src/ilist/unmodifiable_list_from_ilist.dart";
export "src/ilist/reversed_list_view.dart";

// IMap:
export "src/imap/imap.dart";
export "src/imap/map_extension.dart";
export "src/imap/entry.dart";
export "src/imap/modifiable_map_from_imap.dart";
export "src/imap/unmodifiable_map_from_imap.dart";

// IMapOfSets:
export "src/imap_of_sets/imap_of_sets.dart";

// ISet:
export "src/iset/iset.dart";
export "src/iset/set_extension.dart";
export "src/iset/modifiable_set_from_iset.dart";
export "src/iset/unmodifiable_set_from_iset.dart";
export "src/iset/from_iset_mixin.dart";
export "src/iset/from_iterable_iset_mixin.dart";

// ListSet and ListMap:
export "src/list_set/list_set.dart";
export "src/list_map/list_map.dart";
