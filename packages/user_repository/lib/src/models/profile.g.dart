// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['_id'] as String,
      username: json['username'] as String,
      partition: json['_partition'] as String,
      facts: (json['facts'] as List<dynamic>)
          .map((e) => KeyValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      interests: (json['interests'] as List<dynamic>)
          .map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'partition': instance.partition,
      'facts': instance.facts,
      'interests': instance.interests,
    };
