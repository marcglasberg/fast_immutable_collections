import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ilist_model.g.dart';

@JsonSerializable()
class IListWrapper {
  final IList<String> iList;

  IListWrapper(this.iList);

  factory IListWrapper.fromJson(Map<String, dynamic> json) =>
      _$IListWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$IListWrapperToJson(this);
}

@JsonSerializable()
class IMapWrapper {
  final IMap<String, String> iMap;

  IMapWrapper(this.iMap);

  factory IMapWrapper.fromJson(Map<String, dynamic> json) =>
      _$IMapWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$IMapWrapperToJson(this);
}

@JsonSerializable()
class ISetWrapper {
  final ISet<String> iSet;

  ISetWrapper(this.iSet);

  factory ISetWrapper.fromJson(Map<String, dynamic> json) =>
      _$ISetWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ISetWrapperToJson(this);
}
