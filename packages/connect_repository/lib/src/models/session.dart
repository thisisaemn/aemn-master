import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:connect_repository/connect_repository.dart';

part 'session.g.dart';


@JsonSerializable()
class Session extends Equatable{
  final String id;
  final String partition;


  final List<Member>  members;

  final Commons commons;

  const Session({required this.id, required this.partition, required this.members, required this.commons});

  static const generic = Session(id: "00000000", partition: "=00000000",  members: [Member(id: "00000000", username: "aemn", active: false)], commons: Commons.generic);

  @override
  List<Object> get props => [id, partition, members, commons];

  /*
  static Weather fromJson(dynamic json) {
    final consolidatedWeather = json['consolidated_weather'][0];
    return Weather(
      condition: _mapStringToWeatherCondition(
          consolidatedWeather['weather_state_abbr']),
      formattedCondition: consolidatedWeather['weather_state_name'],
      minTemp: consolidatedWeather['min_temp'] as double,
      temp: consolidatedWeather['the_temp'] as double,
      maxTemp: consolidatedWeather['max_temp'] as double,
      locationId: json['woeid'] as int,
      created: consolidatedWeather['created'],
      lastUpdated: DateTime.now(),
      location: json['title'],
    );
  }*/
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);


}




//src https://bloclibrary.dev/#/flutterweathertutorial