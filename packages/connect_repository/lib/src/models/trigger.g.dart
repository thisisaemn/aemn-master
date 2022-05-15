// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trigger _$TriggerFromJson(Map<String, dynamic> json) => Trigger(
      id: json['_id'] as String,
      facts: (json['facts'] as List<dynamic>)
          .map((e) => KeyValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      interests: (json['interests'] as List<dynamic>)
          .map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainContent: json['mainContent'] as String,
      mainContentLink: json['mainContentLink'] as String,
    );

Map<String, dynamic> _$TriggerToJson(Trigger instance) => <String, dynamic>{
      'id': instance.id,
      'facts': instance.facts,
      'interests': instance.interests,
      'mainContent': instance.mainContent,
      'mainContentLink': instance.mainContentLink,
    };
