import 'package:equatable/equatable.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'trigger.g.dart';

@JsonSerializable()
class Trigger extends Equatable{
  final String id;
  final List<KeyValue>  facts;
  final List<Interest>  interests;
  final String mainContent;
  final String mainContentLink;

  const Trigger ({required this.id,required this.facts, required this.interests, required this.mainContent, required this.mainContentLink});

  @override
  List<Object> get props => [id, facts, interests, mainContent, mainContentLink];

  factory Trigger.fromJson(Map<String, dynamic> json) => _$TriggerFromJson(json);
  Map<String, dynamic> toJson() => _$TriggerToJson(this);


}

//or should this be called triggers?