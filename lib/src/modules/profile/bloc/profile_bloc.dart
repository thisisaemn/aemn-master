import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';


part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc
    extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc({required this.userRepository,})
      : assert(userRepository != null),
        profile = userRepository.currentProfile,
        super(ProfileLoading()) {
    //on<ProfileUpsertFact>(_onProfileUpsertFact);
    on<ProfileLoad>(_onProfileLoad);
    //on<ProfileUpsertInterest>(_onProfileUpsertInterest);
    on<AddOrModifyInterest>(_onAddOrModifyInterest);
    on<ChangeInterestIntensity>(_onChangeInterestIntensity);
    on<DeleteInterest>(_onDeleteInterest);
    on<AddFact>(_onAddFact);
    on<UpsertFact>(_onUpsertFact);
    on<DeleteFact>(_onDeleteFact);
    on<ChangeUsername>(_onChangeUsername);
    //on<DeletedUser>(_onDeleteUser);
    //on<ChangePassword>(_onChangePassword);

    //on<>(_on);
   // _profileStatusSubscription = _userRepository.profile.listen(
        //  (status) => add(ProfileUpdated()),
   // );
    /*_userSubscription = userRepository.user.listen(
          (user) => add(UserLoad(user)),
    );*/
    /*_profileSubscription = userRepository.profile.listen(
          (profile) => add(ProfileLoad(/*profile*/)),
    );*/
  }

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<Profile> _profileSubscription;

  @override
  void initState() async {
    profile = userRepository.currentProfile;
    Profile? pProfile = await _tryGetProfile();

    if(null == pProfile){
      profile = Profile.generic;
      emit(ProfileLoadingFailed());
    }else {
      profile = pProfile;
      emit(ProfileLoaded());
    }
  }

  final UserRepository userRepository;
  //StreamSubscription<ProfileStatus> _profileStatusSubscription;
  late Profile profile; //= Profile.generic;//Profile.generic; //(uuid: '', username: 'username', partition: 'partition', facts: [], interests: []);
  late User user;

  Future<void> _onUserLoad(UserLoad event, Emitter<ProfileState> emit) async {
    user = userRepository.currentUser;
    emit(ProfileLoading()); //Different state
    User? pUser = await _tryGetUser();
    //print(profile);

    if(pUser!=null){
      //print(profile!.facts);
      user = pUser;
      emit(ProfileLoaded());
    }else{
      emit(ProfileLoadingFailed());
    }
  }

  Future<void> _onProfileLoad(ProfileLoad event, Emitter<ProfileState> emit) async {
    profile = userRepository.currentProfile;
    emit(ProfileLoading());
    Profile? pProfile = await _tryGetProfile();
    //print(profile);

    if(pProfile!=null){
      //print(profile!.facts);
      profile = pProfile;
      emit(ProfileLoaded());
    }else{
      emit(ProfileLoadingFailed());
    }
  }


  Future<void> _onChangeUsername(ChangeUsername event, Emitter<ProfileState> emit) async {
    profile = userRepository.currentProfile;
    emit(EditingUser());
    Profile? pProfile = await _tryGetProfile();
    //print(profile);

    bool success = await _tryChangeUsername(newUsername: event.newUsername);

    if(success){
      //print(profile!.facts);
      //profile = pProfile;
      emit(EditedUser());
      this.add(ProfileLoad());
    }else{
      emit(EditingUserFailed());
    }
  }


  /*
  Future<void> _onProfileUpsertInterest(ProfileUpsertInterest event, Emitter<ProfileState> emit) async {
    print('tryna upsert the interest');

    bool success = await _tryUpsertInterest(event.interestId);
    if(success){
      //ProfileLoad();


      emit(ProfileLoading());

      //OnProfileLoad Method

      profile = await _tryGetProfile();
      //print(profile);

      if(profile!=null){
        //print(profile!.facts);
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }
  }*/

  Future<void> _onAddOrModifyInterest(AddOrModifyInterest event, Emitter<ProfileState> emit) async {
    print('tryna upsert the interest');

    bool success = await _tryAddOrModifyInterest(interestId: event.interestId, intensityDelta: event.intensityDelta);
    if(success){
      //ProfileLoad();


      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }
  }


  Future<void> _onChangeInterestIntensity(ChangeInterestIntensity event, Emitter<ProfileState> emit) async {
    print("tryna change intensity of interest");

    bool success = await _tryChangeInterestIntensity(interestId: event.interestId, interestIntensity:event.intensity);
    if(success){
      //ProfileLoad();
      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }else{
      print("Trouble Loading the profile");
    }
  }

  Future<void> _onDeleteInterest(DeleteInterest event, Emitter<ProfileState> emit) async {
    print("tryna delete of interest");

    bool success = await _tryDeleteInterest(interestId: event.interestId);
    if(success){
      //ProfileLoad();
      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }else{
      print("Trouble Loading the profile");
    }
  }
/*
  void _onProfileUpsertFact(ProfileUpsertFact event, Emitter<ProfileState> emit) {
  }*/

  Future<void> _onAddFact(AddFact event, Emitter<ProfileState> emit) async {
    print("tryna add interest");

    bool success = await _tryAddFact(keyValue: event.keyValue);
    if(success){
      //ProfileLoad();
      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }else{
      print("Trouble Loading the profile");
    }
  }

  Future<void> _onDeleteFact(DeleteFact event, Emitter<ProfileState> emit) async {
    print("tryna delete fact");

    bool success = await _tryDeleteFact(factId: event.factId);
    if(success){
      //ProfileLoad();
      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }else{
      print("Trouble Loading the profile");
    }
  }

  Future<void> _onUpsertFact(UpsertFact event, Emitter<ProfileState> emit) async {
    print("profile_bloc, l 251; tryna upsert fact");


    bool success = await _tryUpsertFact(keyValue: event.keyValue);


    if(success){
      //ProfileLoad();
      emit(ProfileLoading());

      //OnProfileLoad Method

      Profile? pProfile = await _tryGetProfile();
      //print(profile);

      if(pProfile!=null){
        //print(profile!.facts);
        profile = pProfile;
        emit(ProfileLoaded());
      }else{
        emit(ProfileLoadingFailed());
      }
    }else{
      print("Trouble Loading the profile");
    }
  }


/*
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async*{
    if(event is ProfileUpsertFact){
      bool status = await _tryUpsertFact();
      if(status){
        //Reload profile
        this.add(ProfileLoad());
        //event = ProfileLoad(); // Can you do smth like this to trigger a reload of the profile?
      }else{
        //Failed to lúpsert dialog, check ur connection or smth of that sort.

      }

    }else if(event is ProfileUpsertInterest){ // is else really neccessary?
      bool status = await _tryUpsertInterest();
      if(status){
        //Reload profile
        // this.add(ProfileLoad()); //I think this is the correct way.
        //////CHANGE THIS LATER!!!
        this.add(ProfileLoad());
        //event = ProfileLoad(); // Can you do smth like this to trigger a reload of the profile?
      }else{
        //Failed to lúpsert dialog, check ur connection or smth of that sort.

      }
    }

    if(event is ProfileLoad){
      yield ProfileLoading();
      profile = await _tryGetProfile();

      if(profile!=null){
        yield ProfileLoaded();
      }else{
        yield ProfileLoadingFailed();
      }
    }
  }

 */

  Future<Profile?> _tryGetProfile() async {
    try {
      final profile = await userRepository.getProfile();
      return profile;
    } on Exception {
      return null;
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }




  Future<bool> _tryUpsertFact({required KeyValue keyValue}) async {
    try{
      //Call method in user Repository to updert fact.
      final success = userRepository.upsertFactOfProfile(keyValue: keyValue);
      return success;
    }on Exception {
      print("An Exception occured trying to upsert a fact");
      return false;
    }
  }

  Future<bool> _tryAddFact({required KeyValue keyValue}) async {
    try{
      //Call method in user Repository to updert fact.
      final success = userRepository.addFactToProfile(keyValue: keyValue);
      return success;
    }on Exception {
      print("An Exception occured trying to upsert a fact");
      return false;
    }
  }

  /*Future<bool> _tryUpdateFact({required KeyValue keyValue}) async {
    try{
      final success = userRepository.updateFact(keyValue: keyValue);
      return success;
    }on Exception{
      print("failed updating fact");
      return false;
    }
  }*/

  Future<bool> _tryDeleteFact({required String factId}) async {
    try{
      final success = userRepository.deleteFact(factId: factId);
      return success;
    }on Exception{
      print("failed updating fact");
      return false;
    }
  }

/*
  Future<bool> _tryUpsertInterest(interestId) async { //For now seperating update from add
    try{
      final success = await userRepository.addInterestToProfile(interestId: interestId);
      return success;
      //Call method in user Repository to updert interest.
    }on Exception {
      print("An Exception occured trying to upsert a interest");
      return false;
    }
  }*/

  Future<bool> _tryAddOrModifyInterest({required String interestId, required int intensityDelta}) async { //For now seperating update from add
    try{
      final success = await userRepository.addOrModifyProfile(interestId: interestId, intensityDelta: intensityDelta);
      return success;
      //Call method in user Repository to updert interest.
    }on Exception {
      print("An Exception occured trying to upsert a interest");
      return false;
    }
  }

  Future<bool> _tryChangeInterestIntensity({required String interestId,required int interestIntensity}) async {
    try{
      final success = await userRepository.changeInterestIntensity(interestId: interestId, interestIntensity: interestIntensity);
      return success;
    }on Exception {
      print("An Exception occured trying to upsert a interest");
      return false;
    }
  }

  Future<bool> _tryDeleteInterest({required String interestId}) async {
    try{
      final success = userRepository.deleteInterest(interestId: interestId);
      return success;
    }on Exception{
      print("failed updating fact");
      return false;
    }
  }


  Future<bool> _tryChangeUsername({required String newUsername}) async {
    try{
      final success = userRepository.changeUsername(newUsername: newUsername);
      return success;
    }on Exception{
      print("failed updating fact");
      return false;
    }
  }

}
