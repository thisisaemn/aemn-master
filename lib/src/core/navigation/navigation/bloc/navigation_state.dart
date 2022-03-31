part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  final NavigationDestinations currentDestination;
  const NavigationState({required this.currentDestination});

  @override
  List<Object> get props => [currentDestination];

  get session => session;
}

/*
class NavigationInitial extends NavigationState {
  NavigationInitial() : super();

  @override
  List<Object> get props => [];
}*/

/*
class CurrentIndexChanged extends NavigationState {
  final int currentDestination;

  CurrentIndexChanged({required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to ';
}*/

class CurrentDestinationChanged extends NavigationState {
  final NavigationDestinations currentDestination;
  final Session? session;

  CurrentDestinationChanged({required this.currentDestination, this.session}) : super(currentDestination: currentDestination);

 /* @override
  String toString() => 'CurrentIndexChanged to $currentDestination ';*/

  @override
  List<Object> get props => [currentDestination];

}

class DestinationLoading extends NavigationState {
  final NavigationDestinations currentDestination;
  final Session? session;

  DestinationLoading({required this.currentDestination, this.session}) : super(currentDestination: currentDestination);
  @override
  String toString() => 'PageLoading';

  @override
  List<Object> get props => [currentDestination];
}

class DestinationLoaded extends NavigationState {
  final NavigationDestinations currentDestination;
  final Session? session;

  DestinationLoaded({required this.currentDestination, this.session}) : super(currentDestination: currentDestination);
  @override
  String toString() => 'PageLoading';

  @override
  List<Object> get props => [currentDestination];
}

/*

class HomeDestinationLoaded extends NavigationState {
  //final String text;

  HomeDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ProfileDestinationLoaded extends NavigationState {
  //final String text;

  ProfileDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class EditProfileDestinationLoaded extends NavigationState {
  //final String text;

  EditProfileDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class SettingsDestinationLoaded extends NavigationState {
  //final String text;

  SettingsDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class SwipeDestinationLoaded extends NavigationState {
  //final String text;

  SwipeDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Swipe Loaded with data: ';
}



class SearchInterestsDestinationLoaded extends NavigationState {
  //final String text;

  SearchInterestsDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class SearchProfilesDestinationLoaded extends NavigationState {
  //final String text;

  SearchProfilesDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'search profile Loaded with data: ';
}

class SessionDestinationLoaded extends NavigationState {
  //final String text;

  SessionDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Session with data: ';
}

class ConnectDestinationLoaded extends NavigationState {
  //final String text;

  ConnectDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ScanIdDestinationLoaded extends NavigationState {
  //final String text;

  ScanIdDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ShowIdDestinationLoaded extends NavigationState {
  //final String text;

  ShowIdDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

*/










/*
class HomeDestinationLoading extends NavigationState {
  //final String text;

  HomeDestinationLoading(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ProfileDestinationLoading extends NavigationState {
  //final String text;

  ProfileDestinationLoading(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class EditProfileDestinationLoading extends NavigationState {
  //final String text;

  EditProfileDestinationLoading(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class SettingsDestinationLoading extends NavigationState {
  //final String text;

  SettingsDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Profile Loaded with data: ';
}

class SwipeDestinationLoaded extends NavigationState {
  //final String text;

  SwipeDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Swipe Loaded with data: ';
}



class SearchInterestsDestinationLoaded extends NavigationState {
  //final String text;

  SearchInterestsDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class SearchProfilesDestinationLoaded extends NavigationState {
  //final String text;

  SearchProfilesDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'search profile Loaded with data: ';
}

class SessionDestinationLoaded extends NavigationState {
  //final String text;

  SessionDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'Session with data: ';
}

class ConnectDestinationLoaded extends NavigationState {
  //final String text;

  ConnectDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ScanIdDestinationLoaded extends NavigationState {
  //final String text;

  ScanIdDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}

class ShowIdDestinationLoaded extends NavigationState {
  //final String text;

  ShowIdDestinationLoaded(); //{required this.text});

  @override
  String toString() => 'HomeLoaded with data: ';
}
*/