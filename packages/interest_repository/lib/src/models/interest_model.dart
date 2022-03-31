import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

//import 'package:user_repository/src/models/models.dart';
import 'models.dart';

part 'interest_model.g.dart';

@JsonSerializable()
class InterestModel extends Equatable{
  final String id;
  final String partition;

  final String icon;

  final String name;

  final List<Tag> tags;


  /*
   It doesn't. The represantor and the swipe suggestion should save the tags of the belonging interests. The interests r 'absolute'
  ///////THIS IS NOT FINAL!!!!!!! Since it's questionalable if it makes sense...
  //The Content available as Triggers
  final List<String> represantors;
  //The Content used to evaluate that interest, swipe suggestion
  final List<String> swipeSuggestions;*/

  const InterestModel({required this.id, required this.partition, required this.icon, required this.name, required this.tags});


  static const generic = InterestModel(id: "00000000", partition: "=00000000", icon: "60491", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")],);

  InterestModel get duplicate{
    return InterestModel(id: id, partition: partition, icon: icon, name: name, tags: tags, );
  }

  InterestModel duplicateWithChangedIntensity(int newIntensity){
    return InterestModel(id: id, partition: partition, icon: icon, name: name, tags: tags,);
  }

  @override
  List<Object> get props => [id, partition, icon, name, tags,];

  /*
  static Interest fromJson(dynamic json) {
    final interestData = json;
    return Interest(
        id: interestData["_id"],
        partition: interestData["_partition"],
        icon: interestData["icon"],
        name: interestData["name"],
        tags: interestData["tags"],
        intensity: interestData["intensity"] as int,
    );
  }*/

  factory InterestModel.fromJson(Map<String, dynamic> json) => _$InterestModelFromJson(json);
  Map<String, dynamic> toJson() => _$InterestModelToJson(this);

}