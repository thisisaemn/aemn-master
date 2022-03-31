// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Interest _$InterestFromJson(Map<String, dynamic> json) => Interest(
      interestModel:
          InterestModel.fromJson(json['interestModel'] as Map<String, dynamic>),
      intensity: json['intensity'] as int,
    );

Map<String, dynamic> _$InterestToJson(Interest instance) => <String, dynamic>{
      'interestModel': instance.interestModel,
      'intensity': instance.intensity,
    };
