import "package:collection/collection.dart";
import "package:fast_immutable_collections/src/base/hash.dart";

/// This works for any object, not only map entries, but `MapEntry` gets special
/// treatment. We consider two map-entries equal when their respective key and
/// values are equal.
class MapEntryEquality<E> implements Equality<E> {
  const MapEntryEquality();

  @override
  bool equals(Object obj1, Object obj2) => //
      (obj1 is MapEntry && obj2 is MapEntry) //
          ? obj1.key == obj2.key && obj1.value == obj2.value
          : obj1 == obj2;

  @override
  int hash(Object obj) => //
      (obj is MapEntry) //
          ? hashObj2(obj.key, obj.value)
          : obj.hashCode;

  @override
  bool isValidKey(Object o) => true;
}
