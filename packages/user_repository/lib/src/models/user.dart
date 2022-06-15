import 'package:connect_repository/connect_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable{
  User ({required this.id, required this.partition, required this.email, required this.username, required this.box, required this.sessions});

  final String id;
  final String partition;

  final String email;
  final String username;

  List<KeyValue> sessions;

  List<Message> box;

  /// Anonymous user which represents an unauthenticated user.
  static var anonymous = User(id: '', partition: '', email: '', username: '', sessions: [], box: [] );

  //empty User so that there is no need to handle null Users and to always work with a concrete User object.
  //static const empty = User(id: '000000000', partition: 'user=000000000', email: 'void@mail.com', username: 'void', sessions: [], box: []);
  //static const emptyUser = true;

  /// Convenience getter to determine whether the current user is anonymous.
  bool get isAnonymous => this == User.anonymous;

  /// Convenience getter to determine whether the current user is not anonymous.
  bool get isNotAnonymous => this != User.anonymous;

  /// Convenience getter to determine whether the current user is empty.
 // bool get isEmpty => User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  //bool get isNotEmpty => !User.empty;


  @override
  List<Object> get props => [id, partition, email,username, box, sessions];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}