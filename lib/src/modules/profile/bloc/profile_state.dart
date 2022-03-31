
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {

}

class ProfileLoaded extends ProfileState{
  //final String username;

  //ProfileLoaded({@required this.username});

  @override
  String toString() => 'ProfileLoaded';
}

class ProfileLoading extends ProfileState{
  @override
  String toString() => 'ProfileLoading';
}

class ProfileLoadingFailed extends ProfileState{
  //final String username;

  //ProfileLoaded({@required this.username});

  @override
  String toString() => 'ProfileLoaded';
}

class Loading extends ProfileState {

}

class Loaded extends ProfileState {

}

class LoadingFailed extends ProfileState {

}


/*
class ProfileEditing extends ProfileState {


  @override
  String toString() => 'Editing Profile';
}


class ProfileShowing extends ProfileState {


  @override
  String toString() => 'Showing Profile';
}

*/


