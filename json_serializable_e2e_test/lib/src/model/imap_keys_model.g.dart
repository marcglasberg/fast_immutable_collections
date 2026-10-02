// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imap_keys_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringKeys _$StringKeysFromJson(Map<String, dynamic> json) => StringKeys(
      map: Map<String, int>.from(json['map'] as Map),
      iMap: IMap<String, int>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => value as String, (value) => (value as num).toInt()),
    );

Map<String, dynamic> _$StringKeysToJson(StringKeys instance) =>
    <String, dynamic>{
      'map': instance.map,
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

IntKeys _$IntKeysFromJson(Map<String, dynamic> json) => IntKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
      iMap: IMap<int, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => (value as num).toInt(), (value) => value as String),
    );

Map<String, dynamic> _$IntKeysToJson(IntKeys instance) => <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(k.toString(), e)),
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

DoubleKeys _$DoubleKeysFromJson(Map<String, dynamic> json) => DoubleKeys(
      iMap: IMap<double, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => (value as num).toDouble(), (value) => value as String),
    );

Map<String, dynamic> _$DoubleKeysToJson(DoubleKeys instance) =>
    <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

BoolKeys _$BoolKeysFromJson(Map<String, dynamic> json) => BoolKeys(
      iMap: IMap<bool, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => value as bool, (value) => value as String),
    );

Map<String, dynamic> _$BoolKeysToJson(BoolKeys instance) => <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

EnumKeys _$EnumKeysFromJson(Map<String, dynamic> json) => EnumKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ColorEnumMap, k), e as bool),
      ),
      iMap: IMap<Color, bool>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => $enumDecode(_$ColorEnumMap, value),
          (value) => value as bool),
    );

Map<String, dynamic> _$EnumKeysToJson(EnumKeys instance) => <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(_$ColorEnumMap[k]!, e)),
      'iMap': instance.iMap.toJson(
        (value) => _$ColorEnumMap[value]!,
        (value) => value,
      ),
    };

const _$ColorEnumMap = {
  Color.red: 'red',
  Color.green: 'green',
  Color.blue: 'blue',
};

JsonValueEnumKeys _$JsonValueEnumKeysFromJson(Map<String, dynamic> json) =>
    JsonValueEnumKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$StatusEnumMap, k), (e as num).toInt()),
      ),
      iMap: IMap<Status, int>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => $enumDecode(_$StatusEnumMap, value),
          (value) => (value as num).toInt()),
    );

Map<String, dynamic> _$JsonValueEnumKeysToJson(JsonValueEnumKeys instance) =>
    <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(_$StatusEnumMap[k]!, e)),
      'iMap': instance.iMap.toJson(
        (value) => _$StatusEnumMap[value]!,
        (value) => value,
      ),
    };

const _$StatusEnumMap = {
  Status.active: 'is-active',
  Status.inactive: 'is-inactive',
};

RenamedEnumKeys _$RenamedEnumKeysFromJson(Map<String, dynamic> json) =>
    RenamedEnumKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$PriorityEnumMap, k), (e as num).toInt()),
      ),
      iMap: IMap<Priority, int>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => $enumDecode(_$PriorityEnumMap, value),
          (value) => (value as num).toInt()),
    );

Map<String, dynamic> _$RenamedEnumKeysToJson(RenamedEnumKeys instance) =>
    <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(_$PriorityEnumMap[k]!, e)),
      'iMap': instance.iMap.toJson(
        (value) => _$PriorityEnumMap[value]!,
        (value) => value,
      ),
    };

const _$PriorityEnumMap = {
  Priority.veryHigh: 'very_high',
  Priority.high: 'high',
  Priority.low: 'low',
};

NullableEnumKeys _$NullableEnumKeysFromJson(Map<String, dynamic> json) =>
    NullableEnumKeys(
      map: (json['map'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$ColorEnumMap, k), (e as num).toInt()),
      ),
      iMap: json['iMap'] == null
          ? null
          : IMap<Color, int>.fromJson(
              json['iMap'] as Map<String, dynamic>,
              (value) => $enumDecode(_$ColorEnumMap, value),
              (value) => (value as num).toInt()),
    );

Map<String, dynamic> _$NullableEnumKeysToJson(NullableEnumKeys instance) =>
    <String, dynamic>{
      'map': instance.map?.map((k, e) => MapEntry(_$ColorEnumMap[k]!, e)),
      'iMap': instance.iMap?.toJson(
        (value) => _$ColorEnumMap[value]!,
        (value) => value,
      ),
    };

DateTimeKeys _$DateTimeKeysFromJson(Map<String, dynamic> json) => DateTimeKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(DateTime.parse(k), e as String),
      ),
      iMap: IMap<DateTime, String>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => DateTime.parse(value as String),
          (value) => value as String),
    );

Map<String, dynamic> _$DateTimeKeysToJson(DateTimeKeys instance) =>
    <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(k.toIso8601String(), e)),
      'iMap': instance.iMap.toJson(
        (value) => value.toIso8601String(),
        (value) => value,
      ),
    };

BigIntKeys _$BigIntKeysFromJson(Map<String, dynamic> json) => BigIntKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(BigInt.parse(k), e as String),
      ),
      iMap: IMap<BigInt, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => BigInt.parse(value as String), (value) => value as String),
    );

Map<String, dynamic> _$BigIntKeysToJson(BigIntKeys instance) =>
    <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(k.toString(), e)),
      'iMap': instance.iMap.toJson(
        (value) => value.toString(),
        (value) => value,
      ),
    };

UriKeys _$UriKeysFromJson(Map<String, dynamic> json) => UriKeys(
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(Uri.parse(k), e as String),
      ),
      iMap: IMap<Uri, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => Uri.parse(value as String), (value) => value as String),
    );

Map<String, dynamic> _$UriKeysToJson(UriKeys instance) => <String, dynamic>{
      'map': instance.map.map((k, e) => MapEntry(k.toString(), e)),
      'iMap': instance.iMap.toJson(
        (value) => value.toString(),
        (value) => value,
      ),
    };

Issue58TestMaps _$Issue58TestMapsFromJson(Map<String, dynamic> json) =>
    Issue58TestMaps(
      iMap: IMap<DateTime, String>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => DateTime.parse(value as String),
          (value) => value as String),
      map: (json['map'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(DateTime.parse(k), e as String),
      ),
      iEnumMap: IMap<Color, String>.fromJson(
          json['iEnumMap'] as Map<String, dynamic>,
          (value) => $enumDecode(_$ColorEnumMap, value),
          (value) => value as String),
      enumMap: (json['enumMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ColorEnumMap, k), e as String),
      ),
    );

Map<String, dynamic> _$Issue58TestMapsToJson(Issue58TestMaps instance) =>
    <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value.toIso8601String(),
        (value) => value,
      ),
      'iEnumMap': instance.iEnumMap.toJson(
        (value) => _$ColorEnumMap[value]!,
        (value) => value,
      ),
      'map': instance.map.map((k, e) => MapEntry(k.toIso8601String(), e)),
      'enumMap':
          instance.enumMap.map((k, e) => MapEntry(_$ColorEnumMap[k]!, e)),
    };

ConverterKeys _$ConverterKeysFromJson(Map<String, dynamic> json) =>
    ConverterKeys(
      iMap: IMap<Point<int>, int>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => const MapPointJsonConverter().fromJson(value as String),
          (value) => (value as num).toInt()),
    );

Map<String, dynamic> _$ConverterKeysToJson(ConverterKeys instance) =>
    <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => const MapPointJsonConverter().toJson(value),
        (value) => value,
      ),
    };

FromJsonKeys _$FromJsonKeysFromJson(Map<String, dynamic> json) => FromJsonKeys(
      iMap: IMap<UserId, String>.fromJson(
          json['iMap'] as Map<String, dynamic>,
          (value) => UserId.fromJson(value as String),
          (value) => value as String),
    );

Map<String, dynamic> _$FromJsonKeysToJson(FromJsonKeys instance) =>
    <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

NestedKeys _$NestedKeysFromJson(Map<String, dynamic> json) => NestedKeys(
      enumToList: IMap<Color, IList<DateTime>>.fromJson(
          json['enumToList'] as Map<String, dynamic>,
          (value) => $enumDecode(_$ColorEnumMap, value),
          (value) => IList<DateTime>.fromJson(
              value, (value) => DateTime.parse(value as String))),
      dateToMap: IMap<DateTime, IMap<Color, int>>.fromJson(
          json['dateToMap'] as Map<String, dynamic>,
          (value) => DateTime.parse(value as String),
          (value) => IMap<Color, int>.fromJson(
              value as Map<String, dynamic>,
              (value) => $enumDecode(_$ColorEnumMap, value),
              (value) => (value as num).toInt())),
    );

Map<String, dynamic> _$NestedKeysToJson(NestedKeys instance) =>
    <String, dynamic>{
      'enumToList': instance.enumToList.toJson(
        (value) => _$ColorEnumMap[value]!,
        (value) => value.toJson(
          (value) => value.toIso8601String(),
        ),
      ),
      'dateToMap': instance.dateToMap.toJson(
        (value) => value.toIso8601String(),
        (value) => value.toJson(
          (value) => _$ColorEnumMap[value]!,
          (value) => value,
        ),
      ),
    };
