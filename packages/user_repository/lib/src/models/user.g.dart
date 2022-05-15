// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String,
      partition: json['_partition'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      box: (json['box'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      sessions:
          (json['sessions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      '_partition': instance.partition,
      'email': instance.email,
      'username': instance.username,
      'sessions': instance.sessions,
      'box': instance.box,
    };
