
part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchRequestSent extends SearchState{}

class SearchFailed extends SearchState{

}
class Searching extends SearchState {}

class SearchResultsReturned extends SearchState{}
