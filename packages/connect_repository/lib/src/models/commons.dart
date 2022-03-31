import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:connect_repository/connect_repository.dart';

part 'commons.g.dart';

@JsonSerializable()
class Commons extends Equatable{
  final String id;
  final String partition;

  final List<KeyValue>  facts;
  final List<Interest>  interests;

  final List<Trigger> triggers;


  const Commons ({required this.id, required this.partition, required this.facts, required this.interests, required this.triggers});

  static const generic = Commons(id: '00000000', partition: '=00000000', facts: [KeyValue(id: "00000000",key: "species", value: "human"),], interests: [Interest(interestModel: InterestModel(id: "00000000", partition: "=00000000", icon: "2342", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")]), intensity: 1000)], triggers: [Trigger(id: "id" , mainContent: "How's the weather?", mainContentLink: '',facts: [KeyValue(id: "00000000",key: "species", value: "human"),], interests: [Interest(interestModel: InterestModel(id: "00000000", partition: "=00000000", icon: "2342", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")]), intensity: 1000)])]);

  @override
  List<Object> get props => [id, partition, facts, interests, triggers];

  factory Commons.fromJson(Map<String, dynamic> json) => _$CommonsFromJson(json);
  Map<String, dynamic> toJson() => _$CommonsToJson(this);

}