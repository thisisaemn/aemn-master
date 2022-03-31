import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_repository/src/models/models.dart';
import 'package:interest_repository/interest_repository.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends Equatable{
  //final List<Map<String, Object>>
  final String id;
  final String username;
  final String partition;

  final List<KeyValue>  facts;
  final List<Interest>  interests;

  const Profile ({required this.id, required this.username, required this.partition, required this.facts, required this.interests});

  static const generic = Profile(id: '00000000', username: "genz", partition: '=00000000', facts: [KeyValue(id: "00000000",key: "species", value: "human"),], interests: [Interest(interestModel: InterestModel(id: "00000000", partition: "=00000000", icon: "2342", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")]), intensity: 1000)]);

  @override
  List<Object> get props => [id, partition, username,facts, interests];

  /*
  factory Profile.fromJson(dynamic json) {
    final profileData = json['profile'];
    return Profile(
      uuid: profileData['_id'],
      username: profileData['username'],
      partition: profileData['_partition'],
      //https://stackoverflow.com/questions/51053954/how-to-deserialize-a-list-of-objects-from-json-in-flutter
      facts: List<KeyValue>.from(json.decode(profileData['facts']).map((model)=> KeyValue.fromJson(model))),
      interests: List<Interest>.from(json.decode(profileData['interests']).map((model)=> Interest.fromJson(model))), //Interest.fromJson(),
    );
  }*/

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

}