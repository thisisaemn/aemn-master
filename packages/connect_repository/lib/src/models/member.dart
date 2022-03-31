import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member extends Equatable{
  final String id;
  final String username;
  final bool active;

  const Member ({required this.id, required this.username, required this.active});

  @override
  List<Object> get props => [id, username, active];

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);


}