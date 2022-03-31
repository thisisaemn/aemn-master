import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

//import 'package:user_repository/src/models/models.dart';
import 'models.dart';
import 'package:interest_repository/interest_repository.dart';

part 'interest.g.dart';

@JsonSerializable()
class Interest extends Equatable{
  final InterestModel interestModel;

  final int intensity;

  const Interest ({required this.interestModel, required this.intensity});


  static const generic = Interest(interestModel: InterestModel(id: "", partition: "=00000000", icon: "60491", name: "aemn", tags: [Tag(id: "", name: "aemn")]), intensity: 1000);

  Interest get duplicate{
    return Interest(interestModel: InterestModel(id: interestModel.id, partition: interestModel.partition, icon: interestModel.icon, name: interestModel.name, tags: interestModel.tags), intensity: intensity);
  }

  Interest duplicateWithChangedIntensity(int newIntensity){
    return Interest(interestModel: InterestModel(id: interestModel.id, partition: interestModel.partition, icon: interestModel.icon, name: interestModel.name, tags: interestModel.tags), intensity: newIntensity);
  }

  @override
  List<Object> get props => [interestModel, intensity];

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

  factory Interest.fromJson(Map<String, dynamic> json) => _$InterestFromJson(json);
  Map<String, dynamic> toJson() => _$InterestToJson(this);

}