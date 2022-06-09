
part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchRequestSent extends SearchState{}

class SearchFailed extends SearchState{

}
class Searching extends SearchState {}

class SearchResultsReturned extends SearchState{}

class SearchingInterests extends Searching {}

class SearchingMoreInterests extends Searching {}

class ResettingSearchResults extends SearchState{

}

class FailedResettingSearchResults extends SearchState{

}

class ResettedSearchResults extends SearchState{

}
