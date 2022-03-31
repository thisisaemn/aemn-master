import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keyvalue.g.dart';

@JsonSerializable()
class KeyValue extends Equatable{
  final String id;
  final String key;
  final String value;

  const KeyValue ({required this.id, required this.key, required this.value});

  static const generic = KeyValue(id: "00000000", key: 'species', value: 'human');

  KeyValue get duplicate{
    return KeyValue(id: id, key: key, value: value);
  }

  @override
  List<Object> get props => [id, key, value];

  /*
  static KeyValue fromJson(dynamic json) {
    final keyValueData = json;
    return KeyValue(
      id: keyValueData["id"],
      key: keyValueData["key"],
      value: keyValueData["value"],
    );
  }*/

  factory KeyValue.fromJson(Map<String, dynamic> json) => _$KeyValueFromJson(json);
  Map<String, dynamic> toJson() => _$KeyValueToJson(this);

}