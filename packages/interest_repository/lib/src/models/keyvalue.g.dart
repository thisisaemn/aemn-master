// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyvalue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyValue _$KeyValueFromJson(Map<String, dynamic> json) {
  return KeyValue(
    id: json['_id'] as String,
    key: json['key'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$KeyValueToJson(KeyValue instance) => <String, dynamic>{
      '_id': instance.id,
      'key': instance.key,
      'value': instance.value,
    };
