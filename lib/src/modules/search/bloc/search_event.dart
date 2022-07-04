
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
  final List<KeyValue>? options;

  SearchInterestsKey({required this.key, required this.isInitialSearch, this.options});

  @override
  String toString() => 'Searching $key in search bloc.';

  @override
  List<Object> get props => [isInitialSearch];
}



class SearchMembersKey extends SearchEvent {
  final String? key;
  final bool isInitialSearch;
  final List<KeyValue>? options;

  SearchMembersKey({required this.key, required this.isInitialSearch, this.options});

  @override
  String toString() => 'Searching $key in search bloc.';
}

class ResetInterestsSearchResults extends SearchEvent {

}

class SetSearchInterestsKeyOptions extends SearchEvent {

  final List<KeyValue> options;

  SetSearchInterestsKeyOptions({required this.options});

  @override
  List<Object> get props => [options];
}

class SetSearchMembersKeyOptions extends SearchEvent {

  final List<KeyValue> options;

  SetSearchMembersKeyOptions({required this.options});

  @override
  List<Object> get props => [options];
}