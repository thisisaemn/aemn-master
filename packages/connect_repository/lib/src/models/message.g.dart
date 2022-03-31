// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['_id'] as String,
      subject: json['subject'] as String,
      content: json['content'] as String,
      meta: MetaInformation.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      '_id': instance.id,
      'subject': instance.subject,
      'content': instance.content,
      'meta': instance.meta,
    };
