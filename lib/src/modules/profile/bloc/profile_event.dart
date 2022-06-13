
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

//Is this one really neccessary?
class ProfileUpdated extends ProfileEvent{ //should this rather be fetchedprofile

  @override
  String toString() => 'Profile Update';

}

class ProfileLoad extends ProfileEvent {
  @visibleForTesting
  const ProfileLoad(/*this.profile*/);

  //final Profile profile;

  @override
  List<Object> get props => [/*profile*/];
}

class UserLoad extends ProfileEvent {
  @visibleForTesting
  const UserLoad(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

//Momentan können zur Bearbeitung des Profils 2 Methoden aufgerufen werden, die das Bearbeitete Ojekt übernehmen und an das repository weiterleiten
//Alternativ wäre für jede Mgl Änderung eine spezielle Methode denkbar, die nur die erforderlichen Daten vermittelt, um das Volumen zu senken.

class ProfileUpsertFact extends ProfileEvent{
  //Gleicher key kann mehrmals vorkommen. sowie in culture, middle east and western geht. muss hier dann mit index gearbeitet werden?
  //soll jeder fact eine id kriegen? ... ich denke das wird mit reingenommen. Jeder fact in der liste hat eine eigene auf den nutzer bezogenene id, anhand der führt man änderungen duch.
  final KeyValue kv;

  ProfileUpsertFact({ required this.kv});

  List<Object> get props => [ kv];

}
//Sollen hier die Objekte übergeben werden oder ist das skaliert zu rechenaufwendig, oder sollen ausführlichere Methoden geschrieben werde, die dann z.b speziefizieren, dass die intensität für eine bestimmte id auf einen bestimmten wert gebracht wird?
//An dieser Stelle sollte eine Überarbeitung zu einem späteren Zeitpunkt erfolgen.

class ProfileUpsertInterest extends ProfileEvent{
  //final Interest interest;

  //ProfileUpsertInterest({required this.interest});

  final String interestId;

  ProfileUpsertInterest({required this.interestId});

  List<Object> get props => [interestId];
}

class ProfileDeleteFact extends ProfileEvent{
  final KeyValue fact;

  ProfileDeleteFact({required this.fact});

  List<Object> get props => [fact];
}

class ProfileDeleteInterest extends ProfileEvent{
  final Interest interest;

  ProfileDeleteInterest({required this.interest});

  List<Object> get props => [interest];
}
//////////////////////////////////

//EDIT OPERATORS
class AddOrModifyInterest extends ProfileEvent{
  final String interestId;
  final int intensityDelta;

  AddOrModifyInterest({required this.interestId, required this.intensityDelta});

  List<Object> get props => [interestId, intensityDelta];
}

class ChangeInterestIntensity extends ProfileEvent{
  final String interestId;
  final int intensity;

  ChangeInterestIntensity({required this.interestId, required this.intensity});

  List<Object> get props => [interestId, intensity];
}

class DeleteInterest extends ProfileEvent{
  final String interestId;

  DeleteInterest({required this.interestId});

  List<Object> get props => [interestId];
}

class AddFact extends ProfileEvent{
  //final String id;
  //final String key;
  //final String value;
  final KeyValue keyValue;

  AddFact(/*this.id,*/ {required this.keyValue});

  List<Object> get props => [keyValue];

}

class UpsertFact extends ProfileEvent{
  //final String id;
  //final String key;
  //final String value;
  final KeyValue keyValue;

  UpsertFact(/*this.id,*/ {required this.keyValue});

  List<Object> get props => [keyValue];

}

/*
//Maybe kein Change fact but rather delete and add new fact
class ChangeFact extends ProfileEvent{
  //final String id;
  //final String key;
  //final String value;
  final KeyValue keyValue;
  final String newValue;

  AddFact(/*this.id,*/ {required this.keyValue, required this.newValue});

  List<Object> get props => [keyValue, newValue];

}*/

class DeleteFact extends ProfileEvent{
  final String factId;

  DeleteFact({required this.factId});

  List<Object> get props => [factId];
}

//

class ChangeUsername extends ProfileEvent{
  final String newUsername;

  ChangeUsername({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}

class ChangePassword extends ProfileEvent{
  final String oldPassword;
  final String newPassword;

  ChangePassword({required this.oldPassword, required this.newPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class DeleteUser extends ProfileEvent{
  final String userId;

  DeleteUser({required this.userId});

  @override
  List<Object> get props => [userId];
}