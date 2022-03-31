import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:interest_repository/interest_repository.dart';

import 'models.dart';

part 'swipe_suggestion.g.dart';

@JsonSerializable()
class SwipeSuggestion extends Equatable{
  final String id;
  final String partition;
  final List<Tag> tags;
  final String src;
  int reaction = 0;


  SwipeSuggestion ({required this.id,required this.partition, required this.tags, required this.src, required this.reaction});

  static SwipeSuggestion generic = SwipeSuggestion(id: '00000000', partition: '=00000000', tags: [Tag(id: "000000000", name: "aemn")], src: 'lib/src/assets/images/aemn-logo-bare.png', reaction: 0);

  @override
  List<Object> get props => [id, tags, src, reaction];

  factory SwipeSuggestion.fromJson(Map<String, dynamic> json) => _$SwipeSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SwipeSuggestionToJson(this);


}