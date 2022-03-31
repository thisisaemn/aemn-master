part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends NavigationEvent {
  @override
  String toString() => 'AppStarted';
}

class NavigationRequested extends NavigationEvent {
  /*final int index;*/
  final NavigationDestinations destination;
  final Session? session;

  NavigationRequested({/*required this.index, */required this.destination, this.session, });

  @override
  List<Object> get props => [/*index, */destination];

  @override
  String toString() => 'PageTapped: $destination';
}


///ONLY THIS EVENT NEEDED ACCORDING TO https://bloclibrary.dev/#/fluttertodostutorial?id=tab-bloc

class TabUpdated extends NavigationEvent {
  final NavigationDestinations tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'TabUpdated { tab: $tab }';
}

