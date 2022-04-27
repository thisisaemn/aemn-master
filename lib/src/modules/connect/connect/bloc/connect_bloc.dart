import 'dart:async';

import 'package:aemn/src/modules/profile/bloc/profile_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

part 'connect_event.dart';
part 'connect_state.dart';

//This Bloc Handles the connection/sessions with other users

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc({required this.userRepository, required this.connectRepository})
      : assert(userRepository != null),
        user = userRepository.currentUser,
        super(Loading()){
    on<Load>(_onLoad);
    //on<Connect>(_onConnect);
    on<Send>(_onSend);
    on<QuitSession>(_onQuitSession);
    on<InviteToNewSession>(_onInviteToNewSession);
    on<EnterSession>(_onEnterSession);
    on<JoinSession>(_onJoinSession);
    on<GetSession>(_onGetSession);
    on<GetTrigger>(_onGetTrigger);
    /*
    _userSubscription = userRepository.user.listen(
          (user) => add(Load()),
    );
    _commonsSubscription = userRepository.commons.listen(
        (commons) => add(Load()),
    );*/
  }

  final UserRepository userRepository;
  User user;

  final ConnectRepository connectRepository;

  Trigger? trigger;

/*
  //Just for testing...
  static Message genericMsg = Message(id: '002fwe2', subject: 'Connection Request Received', content: 'Birisi would like to connect.', meta: MetaInformation(receiverId: '', senderUsername: 'birisi', receiverUsername: 'test@test.de', senderId: '', sessionId: ''));
  late List<Message> box; //= () async => await userRepository.user.last.box; //= [Message(id: '002fwe2', subject: 'Connection Request Received', content: 'Birisi would like to connect.', meta: MetaInformation(receiverId: '', senderUsername: 'birisi', receiverUsername: 'test@test.de', senderId: '', sessionId: ''))];
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<Commons> _commonsSubscription;
  late Commons commons;
  late List<Session?> sessions;*/


  Future<void> _onLoad (Load event, Emitter<ConnectState> emit) async {
    emit(Loading());

    User? u = await _tryLoadUser();
    if(u == null){
      emit(LoadingFailed());
    }else{
      user = u;
      emit(Loaded());
    }
    emit(Loaded());

  }

  /*
  Future<void> _onConnect (Connect event, Emitter<ConnectState> emit) async {
    emit(Connecting());

    bool success = await _tryEnterSession();

    if(!success){
      emit(ConnectingFailed());
    }
    emit(Connected());
  }*/


  //Enter session, should i rename?
  Future<void> _onSend (Send event, Emitter<ConnectState> emit) async {
    emit(Sending());

    bool success = await _trySendMsg(event.msg);

    if(!success){
      emit(SendingFailed());
    }else {
      emit(Sent());
    }
  }

  Future<void> _onQuitSession (QuitSession event, Emitter<ConnectState> emit) async {
    emit(QuitingSession());

    bool success = false;

    /*
    BAUSTELLE
    if(userRepository.currentSession == event.sessionId || userRepository.currentUser.sessions.contains(event.sessionId)){
      success = await _tryQuitSession(sessionId: event.sessionId);
    }*/

    success = await _tryQuitSession(sessionId: event.sessionId);

    if(!success){
      emit(QuittingSessionFailed());
    }else {
      emit(QuittedSession());
    }
  }


  Future<void> _onInviteToNewSession (InviteToNewSession event, Emitter<ConnectState> emit) async {
    emit(Sending());

    //bool success = await _trySendMsg(event.msg);

    var inviteeId = event.inviteeId;
    var inviteeUsername =  event.inviteeUsername;
    //THIS IS REALLY FUll. NOT SURE IF BLOC SHOULD HANDLE THIS.
    var senderUsername = userRepository.currentProfile.username;
    var senderId = userRepository.currentProfile.id;
    //Should CoppleRepo then send creation request for these?

    bool success= await _tryInviteToNewSession(senderId: senderId, senderUsername: senderUsername, inviteeId: inviteeId, inviteeUsername: inviteeUsername, );

    if(!success){
      emit(InvitingToNewSessionFailed());
    }else {
      emit(InvitedToNewSession());
    }
  }

  /*maybe differentiate join and enter session*/

  Future<void> _onEnterSession (EnterSession event, Emitter<ConnectState> emit) async {
    emit(EnteringSession(session: event.session));

    //bool success = await _trySendMsg(event.msg);
    bool success = false;



    //if(userRepository.user.contains() != event.sessionId || userRepository.currentUser.currentSession != event.sessionId){
      //success = await _tryEnterSession(sessionId: event.session.id);
      success = await _tryEvaluateCommons(sessionId: event.session.id);
      await _tryLoadUser();
    //}

    if(!success){
      emit(EnteringSessionFailed());
    }else {
      emit(EnteredSession(session: event.session));
    }
  }

  Future<void> _onJoinSession (JoinSession event, Emitter<ConnectState> emit) async {
    emit(JoiningSession(sessionId: event.sessionId));

    //bool success = await _trySendMsg(event.msg);
    bool success = false;



    //if(userRepository.user.contains() != event.sessionId || userRepository.currentUser.currentSession != event.sessionId){
    success = await _tryJoinSession(sessionId: event.sessionId);
    await _tryEvaluateCommons(sessionId: event.sessionId);
    await _tryLoadUser();
    //}

    if(!success){
      emit(JoiningSessionFailed());
    }else {
      emit(JoinedSession(sessionId: event.sessionId));
    }
  }

  Future<void> _onGetSession (GetSession event, Emitter<ConnectState> emit) async {
    emit(GettingSession());

    //bool success = await _trySendMsg(event.msg);
    bool success = false;



    //if(userRepository.user.contains() != event.sessionId || userRepository.currentUser.currentSession != event.sessionId){
    success = await _tryEvaluateCommons(sessionId: event.sessionId);
    await _tryLoadUser();
    //}

    if(!success){
      emit(GettingSessionFailed());
    }else {
      emit(GotSession());
    }
  }

  Future<void> _onGetTrigger (GetTrigger event, Emitter<ConnectState> emit) async {
    emit(GettingTrigger(session:event.session));

    trigger = await _tryGetTrigger(session: event.session);

    if(trigger == null){
      emit(GettingTriggerFailed());
    }else {
      emit(GotTrigger(trigger: trigger!));
    }
  }

  //////////////////////////
  ///Repository Requests///
  ////////////////////////

  Future<User?> _tryLoadUser() async {
    try {
      //await userRepository.getUser();
      return userRepository.getUser();
    } on Exception {
      print('failed loading box, connect bloc');
      return null;
    }
  }

  Future<List<Message>?> _tryLoadBox() async {
    try {
      //await userRepository.getUser();

      return userRepository.currentUser.box;
    } on Exception {
      print('failed loading box, connect bloc');
      return null;
    }
  }

  Future<bool> _tryJoinSession({required String sessionId}) async {
    try {
      return connectRepository.joinSession(sessionId: sessionId, username: user.username);
    } on Exception {
      print('failed entering session, connect bloc');
      return false;
    }
  }

  Future<bool> _trySendMsg(Message msg) async {
    try {
      final success = await connectRepository.sendMessage(msg: msg);
      return success;
    } on Exception {
      print('failed sending request, connect bloc');
      return false;
    }
  }

  Future<bool> _tryInviteToNewSession({required String inviteeId, required String inviteeUsername, required String senderId, required String senderUsername}) async {
    try {
      final success = await connectRepository.inviteToNewSession(inviteeId: inviteeId, inviteeUsername:inviteeUsername, senderId:senderId,  senderUsername:senderUsername);
      return success;
    } on Exception {
      print('failed sending request, connect bloc');
      return false;
    }
  }

  Future<bool> _tryQuitSession({required String sessionId}) async {
    try {
      return connectRepository.quitSession(sessionId: sessionId);
    } on Exception {
      print('failed quitting session, connect bloc');
      return false;
    }
  }

  Future<bool> _tryEvaluateCommons({required String sessionId}) async {
    try {
      return connectRepository.evaluateCommons(sessionId: sessionId);
    } on Exception {
      print('failed evl commons, connect bloc');
      return false;
    }
  }

  Future<Trigger?> _tryGetTrigger({required Session session}) async {
    try {
      print("try get trigger");
      return connectRepository.getTrigger(session: session);
    } on Exception {
      print('failed getting trigger, connect bloc');
      return null;
    }
  }




  ////*
  /*
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }*/

}
