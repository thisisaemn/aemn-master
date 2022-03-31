// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metaInformation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaInformation _$MetaInformationFromJson(Map<String, dynamic> json) =>
    MetaInformation(
      senderId: json['senderId'] as String,
      senderUsername: json['senderUsername'] as String,
      receiverId: json['receiverId'] as String,
      receiverUsername: json['receiverUsername'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$MetaInformationToJson(MetaInformation instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderUsername': instance.senderUsername,
      'receiverId': instance.receiverId,
      'receiverUsername': instance.receiverUsername,
      'sessionId': instance.sessionId,
    };
