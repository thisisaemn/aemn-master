import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metaInformation.g.dart';

@JsonSerializable()
class MetaInformation extends Equatable{
  final String? senderId;
  final String? senderUsername;
  final String? receiverId;
  final String? receiverUsername;
  final String? sessionId;
  final String? sessionName;


  const MetaInformation ({required this.senderId, required this.senderUsername, required this.receiverId, required this.receiverUsername, required this.sessionId, required this.sessionName});

  @override
  List<Object> get props => [senderId != null, senderUsername != null, receiverId != null, receiverUsername != null, sessionId != null];

  factory MetaInformation.fromJson(Map<String, dynamic> json) => _$MetaInformationFromJson(json);
  Map<String, dynamic> toJson() => _$MetaInformationToJson(this);


}