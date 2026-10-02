// Models used to test IMap keys with json_serializable.
// See issues #39, #58 and #82:
//   https://github.com/marcglasberg/fast_immutable_collections/issues/39
//   https://github.com/marcglasberg/fast_immutable_collections/issues/58
//   https://github.com/marcglasberg/fast_immutable_collections/issues/82
//
// Whenever json_serializable supports a key type for a regular [Map], the model has both a
// `map` field and an `iMap` field with the same key and value types. The regular [Map] is the
// reference: the [IMap] should produce exactly the same JSON, and read it back.
//
// json_serializable supports these [Map] key types: String, int, BigInt, DateTime, Uri, enums
// (and Object/dynamic). It does NOT support double, bool, or custom types as [Map] keys, so for
// those the model has only the `iMap` field.

import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';

part 'imap_keys_model.g.dart';

// ---------------------------------------------------------------------------------------------
// Enums.

enum Color { red, green, blue }

/// Enum with custom JSON values. The JSON key must be the [JsonValue], not the enum [Enum.name].
enum Status {
  @JsonValue('is-active')
  active,
  @JsonValue('is-inactive')
  inactive,
}

/// Enum with renamed JSON values. The JSON key must be the snake case name.
@JsonEnum(fieldRename: FieldRename.snake)
enum Priority { veryHigh, high, low }

// ---------------------------------------------------------------------------------------------
// Custom key types.

/// The `Point<int>` from issue #82, serialized as "XxY" (for example, "3x4").
typedef MapPoint = Point<int>;

MapPoint parseMapPoint(String text) {
  final parts = text.split('x');
  return MapPoint(int.parse(parts[0]), int.parse(parts[1]));
}

class MapPointJsonConverter extends JsonConverter<MapPoint, String> {
  const MapPointJsonConverter();

  @override
  MapPoint fromJson(String json) => parseMapPoint(json);

  @override
  String toJson(MapPoint object) => '${object.x}x${object.y}';
}

/// A key class with its own `fromJson` and `toJson`, which json_serializable uses directly.
class UserId {
  final int value;

  const UserId(this.value);

  factory UserId.fromJson(String json) => UserId(int.parse(json.substring('user-'.length)));

  String toJson() => 'user-$value';

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'UserId($value)';
}

// ---------------------------------------------------------------------------------------------
// Key types which already work, and must keep working.

@JsonSerializable()
class StringKeys {
  final Map<String, int> map;
  final IMap<String, int> iMap;

  StringKeys({required this.map, required this.iMap});

  factory StringKeys.fromJson(Map<String, dynamic> json) => _$StringKeysFromJson(json);

  Map<String, dynamic> toJson() => _$StringKeysToJson(this);
}

@JsonSerializable()
class IntKeys {
  final Map<int, String> map;
  final IMap<int, String> iMap;

  IntKeys({required this.map, required this.iMap});

  factory IntKeys.fromJson(Map<String, dynamic> json) => _$IntKeysFromJson(json);

  Map<String, dynamic> toJson() => _$IntKeysToJson(this);
}

@JsonSerializable()
class DoubleKeys {
  final IMap<double, String> iMap;

  DoubleKeys({required this.iMap});

  factory DoubleKeys.fromJson(Map<String, dynamic> json) => _$DoubleKeysFromJson(json);

  Map<String, dynamic> toJson() => _$DoubleKeysToJson(this);
}

@JsonSerializable()
class BoolKeys {
  final IMap<bool, String> iMap;

  BoolKeys({required this.iMap});

  factory BoolKeys.fromJson(Map<String, dynamic> json) => _$BoolKeysFromJson(json);

  Map<String, dynamic> toJson() => _$BoolKeysToJson(this);
}

// ---------------------------------------------------------------------------------------------
// Issue #39: Enum keys.

@JsonSerializable()
class EnumKeys {
  final Map<Color, bool> map;
  final IMap<Color, bool> iMap;

  EnumKeys({required this.map, required this.iMap});

  factory EnumKeys.fromJson(Map<String, dynamic> json) => _$EnumKeysFromJson(json);

  Map<String, dynamic> toJson() => _$EnumKeysToJson(this);
}

@JsonSerializable()
class JsonValueEnumKeys {
  final Map<Status, int> map;
  final IMap<Status, int> iMap;

  JsonValueEnumKeys({required this.map, required this.iMap});

  factory JsonValueEnumKeys.fromJson(Map<String, dynamic> json) =>
      _$JsonValueEnumKeysFromJson(json);

  Map<String, dynamic> toJson() => _$JsonValueEnumKeysToJson(this);
}

@JsonSerializable()
class RenamedEnumKeys {
  final Map<Priority, int> map;
  final IMap<Priority, int> iMap;

  RenamedEnumKeys({required this.map, required this.iMap});

  factory RenamedEnumKeys.fromJson(Map<String, dynamic> json) => _$RenamedEnumKeysFromJson(json);

  Map<String, dynamic> toJson() => _$RenamedEnumKeysToJson(this);
}

/// Nullable [IMap] field, with enum keys.
@JsonSerializable()
class NullableEnumKeys {
  final Map<Color, int>? map;
  final IMap<Color, int>? iMap;

  NullableEnumKeys({this.map, this.iMap});

  factory NullableEnumKeys.fromJson(Map<String, dynamic> json) =>
      _$NullableEnumKeysFromJson(json);

  Map<String, dynamic> toJson() => _$NullableEnumKeysToJson(this);
}

// ---------------------------------------------------------------------------------------------
// Issue #58: DateTime, BigInt and Uri keys.

@JsonSerializable()
class DateTimeKeys {
  final Map<DateTime, String> map;
  final IMap<DateTime, String> iMap;

  DateTimeKeys({required this.map, required this.iMap});

  factory DateTimeKeys.fromJson(Map<String, dynamic> json) => _$DateTimeKeysFromJson(json);

  Map<String, dynamic> toJson() => _$DateTimeKeysToJson(this);
}

@JsonSerializable()
class BigIntKeys {
  final Map<BigInt, String> map;
  final IMap<BigInt, String> iMap;

  BigIntKeys({required this.map, required this.iMap});

  factory BigIntKeys.fromJson(Map<String, dynamic> json) => _$BigIntKeysFromJson(json);

  Map<String, dynamic> toJson() => _$BigIntKeysToJson(this);
}

@JsonSerializable()
class UriKeys {
  final Map<Uri, String> map;
  final IMap<Uri, String> iMap;

  UriKeys({required this.map, required this.iMap});

  factory UriKeys.fromJson(Map<String, dynamic> json) => _$UriKeysFromJson(json);

  Map<String, dynamic> toJson() => _$UriKeysToJson(this);
}

/// The exact class from issue #58: IMap and Map, with DateTime and enum keys.
@JsonSerializable()
class Issue58TestMaps {
  final IMap<DateTime, String> iMap;
  final IMap<Color, String> iEnumMap;
  final Map<DateTime, String> map;
  final Map<Color, String> enumMap;

  Issue58TestMaps({
    required this.iMap,
    required this.map,
    required this.iEnumMap,
    required this.enumMap,
  });

  factory Issue58TestMaps.fromJson(Map<String, dynamic> json) => _$Issue58TestMapsFromJson(json);

  Map<String, dynamic> toJson() => _$Issue58TestMapsToJson(this);
}

// ---------------------------------------------------------------------------------------------
// Issue #82: Custom key types.

/// The class from issue #82: a custom key type, with a [JsonConverter].
@JsonSerializable(converters: [MapPointJsonConverter()])
class ConverterKeys {
  final IMap<MapPoint, int> iMap;

  ConverterKeys({required this.iMap});

  factory ConverterKeys.fromJson(Map<String, dynamic> json) => _$ConverterKeysFromJson(json);

  Map<String, dynamic> toJson() => _$ConverterKeysToJson(this);
}

/// A custom key type, with its own `fromJson` and `toJson`.
@JsonSerializable()
class FromJsonKeys {
  final IMap<UserId, String> iMap;

  FromJsonKeys({required this.iMap});

  factory FromJsonKeys.fromJson(Map<String, dynamic> json) => _$FromJsonKeysFromJson(json);

  Map<String, dynamic> toJson() => _$FromJsonKeysToJson(this);
}

// ---------------------------------------------------------------------------------------------
// Nested collections, where the inner keys are also not strings.

@JsonSerializable()
class NestedKeys {
  final IMap<Color, IList<DateTime>> enumToList;
  final IMap<DateTime, IMap<Color, int>> dateToMap;

  NestedKeys({required this.enumToList, required this.dateToMap});

  factory NestedKeys.fromJson(Map<String, dynamic> json) => _$NestedKeysFromJson(json);

  Map<String, dynamic> toJson() => _$NestedKeysToJson(this);
}
