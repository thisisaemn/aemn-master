
import 'dart:async';

import 'package:aemn/src/modules/connect/connect.dart';
import 'package:bloc/bloc.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:interest_repository/interest_repository.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:connect_repository/connect_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.userRepository, required this.interestRepository, required this.connectRepository}) : super(SearchInitial()){
    on<SearchInterestsKey>(_onSearchInterestsKey);
    on<SearchMembersKey>(_onSearchMembersKey);
    on<ResetInterestsSearchResults>(_onResetInterestsSearchResults);
  }

  final InterestRepository interestRepository;
  final UserRepository userRepository;
  final ConnectRepository connectRepository;


  //Look into the interest repository for further information on pagen
  int pagen = 0;


  List<KeyValue> searchInterestsOptions = [];
  List<KeyValue> searchMembersOptions = [];

  Future<void> _onSearchInterestsKey(SearchInterestsKey event, Emitter<SearchState> emit) async {
    //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
    emit(SearchRequestSent());
    emit(Searching());
    String searchKey = event.key ?? "";
    String lastId = "000000000000000000000000";
    if(resultsInterests.length>0 && !event.isInitialSearch){
      lastId = resultsInterests[resultsInterests.length-1].id;
    }
    print(resultsInterests);
    print(lastId);

    if(event.isInitialSearch){
      pagen = 0;
    }

    List<InterestModel>? results = await _tryGetInterestsSearchResults(key: searchKey, lastId: lastId, options: searchInterestsOptions);
    if(results != null){
      //this.add(ProfileLoad());
      if(results.length >0) {
        pagen++;
        if (event.isInitialSearch) {
          resultsInterests = results;
        } else {
          resultsInterests.addAll(results);
        }
      }else{

      }

      emit(SearchResultsReturned());

    }else{
      emit(SearchFailed());
      //Failed to lúpsert dialog, check ur connection or smth of that sort.
      resultsInterests = [];
    }
  }

  Future<void> _onSearchMembersKey(SearchMembersKey event, Emitter<SearchState> emit) async {
    //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
    emit(SearchRequestSent()); //Should states for different searches be different?
    emit(Searching());
    String searchKey = event.key ?? "";
    String lastId = "000000000000000000000000";


    if(resultsMembers.length>0 && !event.isInitialSearch){
      lastId = resultsInterests.last.id;//resultsInterests[resultsInterests.length-1].id;
    }

    List<Member>? results = await _tryGetMembersSearchResults(key: searchKey , lastId: lastId, options: searchMembersOptions);
    if(results != null){
      //this.add(ProfileLoad());
      resultsMembers = results;
      emit(SearchResultsReturned());
    }else{
      emit(SearchFailed());
      //Failed to lúpsert dialog, check ur connection or smth of that sort.
      resultsMembers = [];
    }
  }

  StreamController<InterestModel> interestsResultsStreamController = StreamController<InterestModel>();
  //Stream<InterestModel> resultsInterests; //= interestsResultsStreamController.stream; //[InterestModel.generic]; //Should the default be smth like search history ot suggestions or smth like that
  List<InterestModel> resultsInterests = [];
  List<Member> resultsMembers = [];
  //List<User>/<Profile> resultUser = [];

  /*
  @override
  Stream<SearchState> mapEventToState(
      SearchEvent event,
      ) async* {
    if(event is SearchInterestsKey){
      //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
      List<InterestModel>? results = await _tryGetInterestsSearchResults(event.key);
      if(results != null){
        //this.add(ProfileLoad());
        resultsInterests = results;
      }else{
        //Failed to lúpsert dialog, check ur connection or smth of that sort.

      }

    }
  }
   */


  Future<void> _onResetInterestsSearchResults(SearchEvent ResetInterestSearchResults, Emitter<SearchState> emit) async {
    emit(ResettingSearchResults());

    resultsInterests = [];

    emit(ResettedSearchResults());

    // emit(FailedResettingSearchResults());
  }



  ///////// Repo calls ///////

  //Future<Stream<InterestModel>> _tryGetInterestsSearchResults(String key) async {
  Future<List<InterestModel>?> _tryGetInterestsSearchResults({required String key, required String lastId, required List<KeyValue> options}) async {
    try {
      //final profile = await interestRepository.getProfile();
      final result = await interestRepository.searchInterests(key: key, lastId: lastId, options: options) ;
      return result;
    } on Exception {
      return null; //Should null be possible
    }
  }

  Future<List<Member>?> _tryGetMembersSearchResults({required String key, required String lastId, required List<KeyValue> options}) async {
    try {
      //final profile = await interestRepository.getProfile();
      final result = await connectRepository.searchMembers(key: key, lastId: lastId, options: options);
      return result;
    } on Exception {
      return null; //Should null be possible
    }
  }

}
