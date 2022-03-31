// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['_id'] as String,
      partition: json['_partition'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      commons: Commons.fromJson(json['commons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      '_id': instance.id,
      '_partition': instance.partition,
      'members': instance.members,
      'commons': instance.commons,
    };
