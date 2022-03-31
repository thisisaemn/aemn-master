// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwipeSuggestion _$SwipeSuggestionFromJson(Map<String, dynamic> json) {
  return SwipeSuggestion(
    id: json['id'] as String,
    partition: json['partition'] as String,
    tags: (json['tags'] as List<dynamic>)
        .map((e) => Tag.fromJson(e as Map<String, dynamic>))
        .toList(),
    src: json['src'] as String,
    reaction: json['src'] as int
  );
}

Map<String, dynamic> _$SwipeSuggestionToJson(SwipeSuggestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partition': instance.partition,
      'tags': instance.tags,
      'src': instance.src,
      'reaction': instance.reaction
    };
