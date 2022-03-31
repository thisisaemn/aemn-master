// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestModel _$InterestModelFromJson(Map<String, dynamic> json) {
  return InterestModel(
    id: json['_id'] as String,
    partition: json['_partition'] as String,
    icon: json['icon'] as String,
    name: json['name'] as String,
    tags: (json['tags'] as List<dynamic>)
        .map((e) => Tag.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$InterestModelToJson(InterestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partition': instance.partition,
      'icon': instance.icon,
      'name': instance.name,
      'tags': instance.tags,
    };
