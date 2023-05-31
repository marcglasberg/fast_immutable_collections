import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ilist_model.g.dart';

@JsonSerializable()
class IListWrapper {
  final IList<String> iList;

  IListWrapper(this.iList);

  factory IListWrapper.fromJson(Map<String, dynamic> json) => _$IListWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$IListWrapperToJson(this);
}

@JsonSerializable()
class IListWrapper2 {
  final IList<TestEnum> iList;

  IListWrapper2(this.iList);

  factory IListWrapper2.fromJson(Map<String, dynamic> json) => _$IListWrapper2FromJson(json);

  Map<String, dynamic> toJson() => _$IListWrapper2ToJson(this);
}

@JsonSerializable()
class IMapWrapper {
  final IMap<String, String> iMap;

  IMapWrapper(this.iMap);

  factory IMapWrapper.fromJson(Map<String, dynamic> json) => _$IMapWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$IMapWrapperToJson(this);
}

@JsonSerializable()
class IMapWrapper2 {
  final IMap<int, String> iMap;

  IMapWrapper2(this.iMap);

  factory IMapWrapper2.fromJson(Map<String, dynamic> json) => _$IMapWrapper2FromJson(json);

  Map<String, dynamic> toJson() => _$IMapWrapper2ToJson(this);
}

@JsonSerializable()
class IMapWrapper3 {
  final IMap<TestEnum, String> iMap;

  IMapWrapper3(this.iMap);

  factory IMapWrapper3.fromJson(Map<String, dynamic> json) => _$IMapWrapper3FromJson(json);

  Map<String, dynamic> toJson() => _$IMapWrapper3ToJson(this);
}

@JsonSerializable()
class ISetWrapper {
  final ISet<String> iSet;

  ISetWrapper(this.iSet);

  factory ISetWrapper.fromJson(Map<String, dynamic> json) => _$ISetWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ISetWrapperToJson(this);
}

enum TestEnum { valA, valB, valC }
