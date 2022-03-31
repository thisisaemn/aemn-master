import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swipe_repository/swipe_repository.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc({required this.swipeRepository, required this.userRepository}) : assert(swipeRepository != null), super(Loading()){
    on<LoadSwipes>(_onLoadSwipes);
    on<AddFavor>(_onAddFavor);
    on<ReduceFavor>(_onReduceFavor);
  }

  final InterestRepository interestRepository = InterestRepository();
  final UserRepository userRepository;

  Future<void> _onLoadSwipes(LoadSwipes event, Emitter<SwipeState> emit) async {
    //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
    emit(Loading());


    //SwipeSuggestion? ss = await _tryGetSwipeSuggestion(bias: event.bias);

    List<SwipeSuggestion>? results = await _tryGetSwipeSuggestions(bias: null);
    /*if(ss!=null){
      results = [ss];
    }*/
    if(results != null){
      //this.add(ProfileLoad());
      swipes = results;
      emit(Loaded());

    }else{
      emit(LoadingFailed());
      //Failed to lúpsert dialog, check ur connection or smth of that sort.
      swipes = [];
    }
  }

  Future<void> _onAddFavor(AddFavor event, Emitter<SwipeState> emit) async {
    //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
    emit(ReactionToSwipeSent());
    emit(ReactingToSwipe());
    bool success = await _tryAddFavor(tags: event.tags);

    if(success != null){
      emit(ReactedToSwipe());

    }else{
      emit(ReactionToSwipeFailed());
    }
  }

  Future<void> _onReduceFavor(ReduceFavor event, Emitter<SwipeState> emit) async {
    //Stream<InterestModel> results = await _tryGetInterestsSearchResults(event.key);
    emit(ReactionToSwipeSent());
    emit(ReactingToSwipe());
    bool success = await _tryReduceFavor(tags: event.tags);

    if(success != null){
      emit(ReactedToSwipe());

    }else{
      emit(ReactionToSwipeFailed());
    }
  }


  List<SwipeSuggestion> swipes = [];

  final SwipeRepository swipeRepository;



  Future<SwipeSuggestion?> _tryGetSwipeSuggestion({required List<Tag>? bias}) async {
    try {
      //final profile = await interestRepository.getProfile();
      List<SwipeSuggestion> results = [];
      SwipeSuggestion? result;
      if(bias != null){
        if(bias.length > 0){
          //generate biased interests Tags, projection of interests
          result = await swipeRepository.getTagsImageFromPexels(tags: bias);
        }else{
          //generate random interests Tags, projection of interests
        }
      }
      //
      return result;
      //return null;
    } on Exception {
      return null; //Should null be possible
    }
  }

  Future<List<SwipeSuggestion>?> _tryGetSwipeSuggestions({required List<Tag>? bias}) async {
    try {
      //final profile = await interestRepository.getProfile();
      List<SwipeSuggestion>? results = [];
      SwipeSuggestion? result;
      if(bias != null && bias.length > 0){
        results = await swipeRepository.getRandomSwipes(); //getBiasedSwipes()
      }else{
        results = await swipeRepository.getRandomSwipes();
      }
      //
      return results;
      //return null;
    } on Exception {
      return null; //Should null be possible
    }
  }

  Future<bool> _tryAddFavor({required List<Tag> tags}) async {
    try {
      //final profile = await interestRepository.getProfile();
      var result;
      for (var tag in tags) {
        result = await userRepository.addOrModifyProfile(interestId: tag.id, intensityDelta: 20);
      }

      return result;
    } on Exception {
      return false; //Should null be possible
    }
  }

  Future<bool> _tryReduceFavor({required List<Tag> tags}) async {
    try {
      var result;
      for (var tag in tags) {
        result = await userRepository.addOrModifyProfile(interestId: tag.id, intensityDelta: -20);
      }

      return result;
    } on Exception {
      return false; //Should null be possible
    }
  }




}
