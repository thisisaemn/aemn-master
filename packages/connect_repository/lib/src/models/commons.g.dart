// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commons _$CommonsFromJson(Map<String, dynamic> json) => Commons(
      id: json['_id'] as String,
      partition: json['_partition'] as String,
      facts: (json['facts'] as List<dynamic>)
          .map((e) => KeyValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      interests: (json['interests'] as List<dynamic>)
          .map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(),
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => Trigger.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommonsToJson(Commons instance) => <String, dynamic>{
      '_id': instance.id,
      '_partition': instance.partition,
      'facts': instance.facts,
      'interests': instance.interests,
      'triggers': instance.triggers,
    };
