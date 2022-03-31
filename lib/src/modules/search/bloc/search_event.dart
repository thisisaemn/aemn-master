
part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable{
  const SearchEvent();

  @override
  List<Object> get props => [];

}

class SearchInterestsKey extends SearchEvent {
  final String? key;

  SearchInterestsKey({required this.key});

  @override
  String toString() => 'Searching $key in search bloc.';
}

class SearchMembersKey extends SearchEvent {
  final String? key;

  SearchMembersKey({required this.key});

  @override
  String toString() => 'Searching $key in search bloc.';
}