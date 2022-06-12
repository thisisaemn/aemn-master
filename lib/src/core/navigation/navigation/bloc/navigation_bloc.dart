import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// import 'package:aemn/src/modules/home/repositories/home_repository.dart';
import 'package:aemn/src/modules/profile/repositories/profile_repository.dart';
import 'package:swipe_repository/swipe_repository.dart';

import 'package:user_repository/src/user_repository.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({required this.userRepository,})
      : assert(userRepository != null),
        super(/*HomeDestinationLoaded()*/DestinationLoaded(currentDestination: NavigationDestinations.home)){
    //on<PageLoading>(_onPageLoading);
    on<AppStarted>(_onAppStarted);
    on<NavigationRequested>(_onNavigationRequested);
  }

  //final HomeRepository homeRepository;

  final UserRepository userRepository;
  //final SwipeRepository swipeRepository;
  //int currentIndex = 1;
  NavigationDestinations currentDestination = NavigationDestinations.home;
  List<NavigationDestinations> destinationsHistory = [];

  void _onAppStarted(NavigationEvent event, Emitter<NavigationState> emit){
    this.add(NavigationRequested(/*index: this.currentIndex, */destination: this.currentDestination));
   // emit(HomeDestinationLoaded());
    emit(DestinationLoaded(currentDestination: NavigationDestinations.home));
  }

  Future<void> _onNavigationRequested(NavigationRequested event, Emitter<NavigationState> emit) async {
    //this.currentIndex = event.index;
    this.currentDestination = event.destination;//Destinations.values.firstWhere((e) => e.toString() == 'Destinations.' + event.destination);
    destinationsHistory.add(this.currentDestination);
    //emit(CurrentIndexChanged(currentIndex: this.currentIndex));

    if(this.currentDestination == NavigationDestinations.back){
      print(destinationsHistory);
      bool go = true;
      for(int i=destinationsHistory.length-1; i>=0; i--){
        if(go && destinationsHistory[i] == NavigationDestinations.back){
          destinationsHistory.removeAt(i);
          i--;
        }
        if(destinationsHistory[i] != NavigationDestinations.back){
          go = false;
        }
      }


      if(destinationsHistory.length > 0){
        destinationsHistory.removeLast();
        currentDestination = destinationsHistory[destinationsHistory.length-1];
      }else{
        currentDestination = NavigationDestinations.home;
      }

      print(currentDestination);
    }//BACK ... but idk if this is clean.

    emit(CurrentDestinationChanged(currentDestination: this.currentDestination));

    if (event.session != null){
      emit(DestinationLoading(currentDestination: this.currentDestination, session: event.session));
    }else{
      emit(DestinationLoading(currentDestination: this.currentDestination));
    }


    //await userRepository.getUser();
    //await userRepository.getProfile();

  // emit(DestinationLoaded(currentDestination: currentDestination));

    /*
    if (this.currentDestination == NavigationDestinations.home) {
      //String data = await _getFirstPageData();
      //await userRepository.getUser();
      emit(DestinationLoaded(currentDestination: NavigationDestinations.home));
      //emit(HomeDestinationLoaded());
    } //HOME

    if (this.currentDestination == NavigationDestinations.profile) {
      //int data = await _getSecondPageData();
      //emit(ProfileDestinationLoaded());
    } //Profile

    if (this.currentDestination == NavigationDestinations.swipe) {
      //String data = (await _getThirdPageData()) ?? '';
      emit(SwipeDestinationLoaded());
    }//Swipe

    if (this.currentDestination == NavigationDestinations.settings) {
      //String data = (await _getThirdPageData()) ?? '';
      emit(SettingsDestinationLoaded());
    }//Settings

    if(this.currentDestination == NavigationDestinations.editProfile){
      emit(EditProfileDestinationLoaded());
    }//EditProfile

    if(this.currentDestination == NavigationDestinations.searchInterests){
      emit(SearchInterestsDestinationLoaded());
    }//Search //Should this be generated on each tap or should it be created once

    if(this.currentDestination == NavigationDestinations.searchMembers){
      emit(SearchProfilesDestinationLoaded());
    }

    if(this.currentDestination == NavigationDestinations.session){
      emit(SessionDestinationLoaded());
    }//Coppled

    if(this.currentDestination == NavigationDestinations.show){
      emit(ShowIdDestinationLoaded()); //Not correct
    }//Scan //Should this be generated on each tap or should it be created once

    if(this.currentDestination == NavigationDestinations.scan){
      emit(ScanIdDestinationLoaded()); //not correct
    }//Show //Should this be generated on each tap or should it be created once
*/

  }


  // AppTab currentTab = AppTab.home;
/*
  @override
  Stream<TabNavigationState> mapEventToState(
      TabNavigationEvent event) async* {
    if (event is AppStarted) {
      this.add(PageTapped(index: this.currentIndex));
    }
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();


      if (this.currentIndex == 1) {
        //String data = await _getFirstPageData();
        yield FirstPageLoaded(text: 'data');
      } //HOME

      if (this.currentIndex == 2) {
        int data = await _getSecondPageData();
        yield SecondPageLoaded(number: data);
      } //Profile

      if (this.currentIndex == 0) {
        String data = (await _getThirdPageData())!;
        yield ThirdPageLoaded(text: data);
      }//Swipe
    }
  }*/
/*
  Future<String> _getFirstPageData() async {
    String data = homeRepository.data;
    if (data == null) {
      await homeRepository.fetchData();
      data = homeRepository.data;
    }
    return data;
  }*/

  Future<int> _getSecondPageData() async {
    //int data = userRepository.data;
    //if (data == null) {
    //await userRepository.fetchData();
    //data = userRepository.data;
    //}
    //return data;
    return 0;
  }

  Future<String?> _getThirdPageData() async {
    /*
    String data = swipeRepository.data;
    if (data == null) {
      await swipeRepository.fetchData();
      data = swipeRepository.data;
    }
    return data;*/
    return null;
  }
}
