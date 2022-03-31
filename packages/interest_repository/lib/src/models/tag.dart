import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag extends Equatable{
  final String id;
  final String name;

  const Tag ({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];


  /*
  static Tag fromJson(dynamic json) {
    final interestData = json;
    return Tag(
      id: interestData["_id"],
      name: interestData["name"],
    );
  }*/

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

}