import "package:flutter_test/flutter_test.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";

void main() {
  /////////////////////////////////////////////////////////////////////////////

  test("MapEntryEquality.equals", () {
    const MapEntry<String, int> mapEntry1 = MapEntry("a", 1);
    const MapEntry<String, int> mapEntry2 = MapEntry("a", 2);
    const MapEntry<String, int> mapEntry3 = MapEntry("a", 1);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry1), isTrue);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry2), isFalse);
    expect(MapEntryEquality().equals(mapEntry1, mapEntry3), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("MapEntryEquality.hash", () {
    // 1) Regular usage
    const MapEntry<String, int> mapEntry1 = MapEntry("a", 1);
    const MapEntry<String, int> mapEntry2 = MapEntry("a", 2);
    const MapEntry<String, int> mapEntry3 = MapEntry("a", 1);
    expect(mapEntry1 == mapEntry2, isFalse);
    expect(mapEntry1 == mapEntry3, isTrue);
    expect(mapEntry1.hashCode, isNot(mapEntry2.hashCode));
    expect(mapEntry1.hashCode, mapEntry3.hashCode);

    // 2) of a different type of object
    expect(MapEntryEquality().hash(1), 1.hashCode);
    expect(MapEntryEquality().hash("a"), "a".hashCode);
  });

  /////////////////////////////////////////////////////////////////////////////

  test("MapEntryEquality.isValidKey", () {
    expect(MapEntryEquality().isValidKey(1), isTrue);
  });

  /////////////////////////////////////////////////////////////////////////////
}
