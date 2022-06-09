
part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable{
  const SearchEvent();

  @override
  List<Object> get props => [];

}

class SearchInterestsKey extends SearchEvent {
  final String? key;
  final bool isInitialSearch;

  SearchInterestsKey({required this.key, required this.isInitialSearch});

  @override
  String toString() => 'Searching $key in search bloc.';

  @override
  List<Object> get props => [isInitialSearch];
}

class SearchMembersKey extends SearchEvent {
  final String? key;
  final bool isInitialSearch;

  SearchMembersKey({required this.key, required this.isInitialSearch});

  @override
  String toString() => 'Searching $key in search bloc.';
}

class ResetInterestsSearchResults extends SearchEvent {

}