// Tests for IMap keys with json_serializable. See issues #39, #58 and #82:
//   https://github.com/marcglasberg/fast_immutable_collections/issues/39
//   https://github.com/marcglasberg/fast_immutable_collections/issues/58
//   https://github.com/marcglasberg/fast_immutable_collections/issues/82
//
// The models are in `lib/src/model/imap_keys_model.dart`. Whenever json_serializable supports
// a key type for a regular [Map], the model also has a regular [Map] field, used as reference:
// the [IMap] must produce exactly the same JSON as the [Map], and must read it back.
//
// When all tests in this file pass, the 3 issues are solved.

import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_serializable_e2e_test/src/model/imap_keys_model.dart';
import 'package:test/test.dart';

void main() {
  // ---------------------------------------------------------------------------------------------

  group('Key types which already work, and must keep working:', () {
    keyTypeTests<StringKeys>(
      'String keys',
      create: () => StringKeys(
        map: {'a': 1, 'b': 2},
        iMap: {'a': 1, 'b': 2}.lock,
      ),
      json: '{"a":1,"b":2}',
      toJson: (obj) => obj.toJson(),
      fromJson: StringKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<IntKeys>(
      'int keys',
      create: () => IntKeys(
        map: {1: 'a', -2: 'b'},
        iMap: {1: 'a', -2: 'b'}.lock,
      ),
      json: '{"1":"a","-2":"b"}',
      toJson: (obj) => obj.toJson(),
      fromJson: IntKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    // json_serializable does not support double keys for a regular Map.
    keyTypeTests<DoubleKeys>(
      'double keys',
      create: () => DoubleKeys(iMap: {1.5: 'a', -2.25: 'b'}.lock),
      json: '{"1.5":"a","-2.25":"b"}',
      toJson: (obj) => obj.toJson(),
      fromJson: DoubleKeys.fromJson,
      getIMap: (obj) => obj.iMap,
    );

    // json_serializable does not support bool keys for a regular Map.
    keyTypeTests<BoolKeys>(
      'bool keys',
      create: () => BoolKeys(iMap: {true: 'yes', false: 'no'}.lock),
      json: '{"true":"yes","false":"no"}',
      toJson: (obj) => obj.toJson(),
      fromJson: BoolKeys.fromJson,
      getIMap: (obj) => obj.iMap,
    );
  });

  // ---------------------------------------------------------------------------------------------

  group('Issue #39: Enum keys:', () {
    test('The exact code from the issue', () {
      final original = EnumKeys(
        map: const {Color.red: true},
        iMap: const IMapConst({Color.red: true}),
      );

      final result = EnumKeys.fromJson(
          jsonDecode(jsonEncode(original)) as Map<String, dynamic>);

      expect(result.iMap, original.iMap);
    });

    keyTypeTests<EnumKeys>(
      'Enum keys',
      create: () => EnumKeys(
        map: {Color.red: true, Color.blue: false},
        iMap: {Color.red: true, Color.blue: false}.lock,
      ),
      json: '{"red":true,"blue":false}',
      toJson: (obj) => obj.toJson(),
      fromJson: EnumKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<JsonValueEnumKeys>(
      'Enum keys with @JsonValue',
      create: () => JsonValueEnumKeys(
        map: {Status.active: 1, Status.inactive: 2},
        iMap: {Status.active: 1, Status.inactive: 2}.lock,
      ),
      json: '{"is-active":1,"is-inactive":2}',
      toJson: (obj) => obj.toJson(),
      fromJson: JsonValueEnumKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<RenamedEnumKeys>(
      'Enum keys with @JsonEnum(fieldRename)',
      create: () => RenamedEnumKeys(
        map: {Priority.veryHigh: 1, Priority.low: 2},
        iMap: {Priority.veryHigh: 1, Priority.low: 2}.lock,
      ),
      json: '{"very_high":1,"low":2}',
      toJson: (obj) => obj.toJson(),
      fromJson: RenamedEnumKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<NullableEnumKeys>(
      'Enum keys in a nullable field (not null)',
      create: () => NullableEnumKeys(
        map: {Color.green: 1},
        iMap: {Color.green: 1}.lock,
      ),
      json: '{"green":1}',
      toJson: (obj) => obj.toJson(),
      fromJson: NullableEnumKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    test('Enum keys in a nullable field (null)', () {
      final json = NullableEnumKeys().toJson();
      expect(json, {'map': null, 'iMap': null});

      final result = NullableEnumKeys.fromJson(viaJsonString(json));
      expect(result.map, isNull);
      expect(result.iMap, isNull);
    });

    test('Empty map with enum keys', () {
      final original = EnumKeys(map: {}, iMap: IMap());
      expect(jsonEncode(original), '{"map":{},"iMap":{}}');

      final result = EnumKeys.fromJson(viaJsonString(original.toJson()));
      expect(result.iMap, IMap<Color, bool>());
    });

    test('An unknown enum key throws the same error as a regular Map', () {
      // The regular Map throws an ArgumentError (from json_serializable's `$enumDecode`).
      expect(
          () => EnumKeys.fromJson(viaJsonString({
                'map': {'purple': true},
                'iMap': <String, dynamic>{},
              })),
          throwsArgumentError);

      // The IMap should throw the same error.
      expect(
          () => EnumKeys.fromJson(viaJsonString({
                'map': <String, dynamic>{},
                'iMap': {'purple': true},
              })),
          throwsArgumentError);
    });
  });

  // ---------------------------------------------------------------------------------------------

  group('Issue #58: DateTime, BigInt and Uri keys:', () {
    test('The exact code from the issue', () {
      final testMaps = Issue58TestMaps(
        iMap: {DateTime(2023, 6, 25): 'IMap<DateTime,String>'}.lock,
        map: {DateTime(2023, 6, 25): 'Map<DateTime,String>'},
        iEnumMap: {Color.red: 'IMap<Enum,String>'}.lock,
        enumMap: {Color.red: 'Map<Enum,String>'},
      );

      // Without going through a JSON string.
      final Map<String, dynamic> json = testMaps.toJson();
      final fromJsonTestMap = Issue58TestMaps.fromJson(json);
      expect(fromJsonTestMap.map, testMaps.map);
      expect(fromJsonTestMap.enumMap, testMaps.enumMap);
      expect(fromJsonTestMap.iMap, testMaps.iMap);
      expect(fromJsonTestMap.iEnumMap, testMaps.iEnumMap);

      // Going through a JSON string.
      final fromJsonString = Issue58TestMaps.fromJson(viaJsonString(json));
      expect(fromJsonString.iMap, testMaps.iMap);
      expect(fromJsonString.iEnumMap, testMaps.iEnumMap);
    });

    keyTypeTests<DateTimeKeys>(
      'DateTime keys',
      create: () => DateTimeKeys(
        map: {DateTime.utc(2023, 6, 25): 'a', DateTime(2024, 1, 2, 3, 4, 5): 'b'},
        iMap: {DateTime.utc(2023, 6, 25): 'a', DateTime(2024, 1, 2, 3, 4, 5): 'b'}.lock,
      ),
      json: '{"2023-06-25T00:00:00.000Z":"a","2024-01-02T03:04:05.000":"b"}',
      toJson: (obj) => obj.toJson(),
      fromJson: DateTimeKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<BigIntKeys>(
      'BigInt keys',
      create: () => BigIntKeys(
        map: {BigInt.parse('123456789012345678901234567890'): 'a', BigInt.from(-1): 'b'},
        iMap: {BigInt.parse('123456789012345678901234567890'): 'a', BigInt.from(-1): 'b'}.lock,
      ),
      json: '{"123456789012345678901234567890":"a","-1":"b"}',
      toJson: (obj) => obj.toJson(),
      fromJson: BigIntKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );

    keyTypeTests<UriKeys>(
      'Uri keys',
      create: () => UriKeys(
        map: {Uri.parse('https://example.com/a?b=c'): 'a', Uri.parse('mailto:x@y.com'): 'b'},
        iMap: {Uri.parse('https://example.com/a?b=c'): 'a', Uri.parse('mailto:x@y.com'): 'b'}
            .lock,
      ),
      json: '{"https://example.com/a?b=c":"a","mailto:x@y.com":"b"}',
      toJson: (obj) => obj.toJson(),
      fromJson: UriKeys.fromJson,
      getIMap: (obj) => obj.iMap,
      getMap: (obj) => obj.map,
    );
  });

  // ---------------------------------------------------------------------------------------------

  group('Issue #82: Custom key types:', () {
    keyTypeTests<ConverterKeys>(
      'Custom keys with a JsonConverter (the class from the issue)',
      create: () => ConverterKeys(iMap: {const MapPoint(3, 4): 1, const MapPoint(-1, 0): 2}.lock),
      json: '{"3x4":1,"-1x0":2}',
      toJson: (obj) => obj.toJson(),
      fromJson: ConverterKeys.fromJson,
      getIMap: (obj) => obj.iMap,
    );

    keyTypeTests<FromJsonKeys>(
      'Custom keys with their own fromJson/toJson',
      create: () => FromJsonKeys(iMap: {const UserId(1): 'Alice', const UserId(42): 'Bob'}.lock),
      json: '{"user-1":"Alice","user-42":"Bob"}',
      toJson: (obj) => obj.toJson(),
      fromJson: FromJsonKeys.fromJson,
      getIMap: (obj) => obj.iMap,
    );
  });

  // ---------------------------------------------------------------------------------------------

  group('Nested collections with non-String keys:', () {
    keyTypeTests<NestedKeys>(
      'IMap<Color, IList<DateTime>>',
      create: () => NestedKeys(
        enumToList: {
          Color.red: [DateTime.utc(2023, 6, 25)].lock,
          Color.blue: <DateTime>[].lock,
        }.lock,
        dateToMap: IMap(),
      ),
      field: 'enumToList',
      otherFields: {'dateToMap': <String, dynamic>{}},
      json: '{"red":["2023-06-25T00:00:00.000Z"],"blue":[]}',
      toJson: (obj) => obj.toJson(),
      fromJson: NestedKeys.fromJson,
      getIMap: (obj) => obj.enumToList,
    );

    keyTypeTests<NestedKeys>(
      'IMap<DateTime, IMap<Color, int>>',
      create: () => NestedKeys(
        enumToList: IMap(),
        dateToMap: {
          DateTime.utc(2023, 6, 25): {Color.green: 1, Color.blue: 2}.lock,
        }.lock,
      ),
      field: 'dateToMap',
      otherFields: {'enumToList': <String, dynamic>{}},
      json: '{"2023-06-25T00:00:00.000Z":{"green":1,"blue":2}}',
      toJson: (obj) => obj.toJson(),
      fromJson: NestedKeys.fromJson,
      getIMap: (obj) => obj.dateToMap,
    );
  });
}

/// Encodes to a JSON string and decodes it back, exactly like a real network round-trip.
Map<String, dynamic> viaJsonString(Object? json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

/// Creates the tests for one IMap key type:
///
/// 1. `toJson` produces the expected [json] (and the same JSON as the regular Map, if any).
/// 2. `fromJson` reads the expected [json], coming from a JSON string.
/// 3. Round-trip: `fromJson(toJson(obj))` gives back the original IMap.
///
/// The IMap is in the JSON [field] (and the regular Map, if any, in the `map` field).
/// Other fields the model needs to read the JSON may be given in [otherFields].
///
void keyTypeTests<T>(
  String description, {
  required T Function() create,
  required String json,
  required Map<String, dynamic> Function(T) toJson,
  required T Function(Map<String, dynamic>) fromJson,
  required IMap? Function(T) getIMap,
  Map? Function(T)? getMap,
  String field = 'iMap',
  Map<String, dynamic> otherFields = const {},
}) {
  group('$description:', () {
    test('toJson', () {
      final Map<String, dynamic> result = toJson(create());

      expect(jsonEncode(result[field]), json);

      // The IMap must produce exactly the same JSON as the regular Map.
      if (getMap != null) expect(result[field], result['map']);
    });

    test('fromJson (from a JSON string)', () {
      final T result = fromJson({
        ...otherFields,
        field: jsonDecode(json),
        if (getMap != null) 'map': jsonDecode(json),
      });

      // Sanity check: The regular Map reads the JSON.
      if (getMap != null) expect(getMap(result), getMap(create()));

      expect(getIMap(result), getIMap(create()));
    });

    test('Round-trip', () {
      final T original = create();
      final T result = fromJson(viaJsonString(toJson(original)));

      // Sanity check: The regular Map does the round-trip.
      if (getMap != null) expect(getMap(result), getMap(original));

      expect(getIMap(result), getIMap(original));
    });
  });
}
