// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ilist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IListWrapper _$IListWrapperFromJson(Map<String, dynamic> json) => IListWrapper(
      IList<String>.fromJson(json['iList'], (value) => value as String),
    );

Map<String, dynamic> _$IListWrapperToJson(IListWrapper instance) => <String, dynamic>{
      'iList': instance.iList.toJson(
        (value) => value,
      ),
    };

IListWrapper2 _$IListWrapper2FromJson(Map<String, dynamic> json) => IListWrapper2(
      IList<TestEnum>.fromJson(json['iList'], (value) => value as TestEnum),
    );

Map<String, dynamic> _$IListWrapper2ToJson(IListWrapper2 instance) => <String, dynamic>{
      'iList': instance.iList.toJson(
        (value) => value,
      ),
    };

IMapWrapper _$IMapWrapperFromJson(Map<String, dynamic> json) => IMapWrapper(
      IMap<String, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => value as String, (value) => value as String),
    );

Map<String, dynamic> _$IMapWrapperToJson(IMapWrapper instance) => <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

IMapWrapper2 _$IMapWrapper2FromJson(Map<String, dynamic> json) => IMapWrapper2(
      IMap<int, String>.fromJson(json['iMap'] as Map<String, dynamic>, (value) => value as int,
          (value) => value as String),
    );

Map<String, dynamic> _$IMapWrapper2ToJson(IMapWrapper2 instance) => <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

IMapWrapper3 _$IMapWrapper3FromJson(Map<String, dynamic> json) => IMapWrapper3(
      IMap<TestEnum, String>.fromJson(json['iMap'] as Map<String, dynamic>,
          (value) => value as TestEnum, (value) => value as String),
    );

Map<String, dynamic> _$IMapWrapper3ToJson(IMapWrapper3 instance) => <String, dynamic>{
      'iMap': instance.iMap.toJson(
        (value) => value,
        (value) => value,
      ),
    };

ISetWrapper _$ISetWrapperFromJson(Map<String, dynamic> json) => ISetWrapper(
      ISet<String>.fromJson(json['iSet'], (value) => value as String),
    );

Map<String, dynamic> _$ISetWrapperToJson(ISetWrapper instance) => <String, dynamic>{
      'iSet': instance.iSet.toJson(
        (value) => value,
      ),
    };
