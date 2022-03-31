import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:connect_repository/connect_repository.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable{
  final String id;
  final String subject;
  final String content;
  final MetaInformation meta;

  const Message ({required this.id, required this.subject, required this.content, required this.meta});

  @override
  List<Object> get props => [id, subject, content, meta];

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);


}

