import 'dart:async';

import 'package:aemn/src/modules/connect/connect.dart';
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
        triggers = [],
        super(Loading()){
    on<Load>(_onLoad);
    on<Connect>(_onConnect);
    on<SendMsg>(_onSendMsg);
    on<ExitSession>(_onExitSession);
    on<KillSession>(_onKillSession);
    on<ChangeSessionName>(_onChangeSessionName);
    on<InviteToNewSession>(_onInviteToNewSession);
    on<InviteToExistingSession>(_onInviteToExistingSession);
    on<EnterSession>(_onEnterSession);
    on<JoinSession>(_onJoinSession);
    on<GetSession>(_onGetSession);
    on<GetTrigger>(_onGetTrigger);
    on<GetTriggers>(_onGetTriggers);
    on<ResetTriggers>(_onResetTriggers);
    on<DeleteMsg>(_onDeleteMsg);
    on<ChangeMsgSessionName>(_onChangeMsgSessionName);
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
  List<Trigger?> triggers = [];
  /*
  StreamController<Trigger?> triggerStreamController = StreamController<Trigger?>();
  Stream<Trigger?> triggerStream = triggerStreamController.stream;*/

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

  Future<void> _onConnect (Connect event, Emitter<ConnectState> emit) async {
    emit(Connecting());

    User? u = await _tryLoadUser();
    if(u == null){
      emit(ConnectingFailed());
    }else{
      user = u;
      emit(Connected());
    }
    emit(Connected());

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
  Future<void> _onSendMsg (SendMsg event, Emitter<ConnectState> emit) async {
    emit(SendingMsg());

    bool success = await _trySendMsg(event.msg);

    if(!success){
      emit(SendingMsgFailed());
    }else {
      emit(SentMsg());
      //this.add(Connect(sessionId: ""));
    }

    this.add(Connect(sessionId: ""));
  }

  Future<void> _onDeleteMsg (DeleteMsg event, Emitter<ConnectState> emit) async {
    emit(DeletingMsg());

    bool success = await _tryDeleteMsg(msgId: event.msg.id);

    if(!success){
      emit(DeletingMsgFailed());
    }else {
      emit(DeletedMsg());
      String? msgSessionId =  event.msg.meta.sessionId;
      if(msgSessionId != null) {
        this.add(ExitSession(sessionId: msgSessionId));
      }
    }
    this.add(Connect(sessionId: ""));
  }

  Future<void> _onChangeMsgSessionName (ChangeMsgSessionName event, Emitter<ConnectState> emit) async {
    emit(ChangingMsgSessionName());

    bool success = false;

    /*
    BAUSTELLE
    if(userRepository.currentSession == event.sessionId || userRepository.currentUser.sessions.contains(event.sessionId)){
      success = await _tryQuitSession(sessionId: event.sessionId);
    }*/

    success = await _tryChangeMsgSessionName(msgId: event.msgId, newMsgSessionName: event.newMsgSessionName);

    if(!success){
      emit(ChangingMsgSessionNameFailed());
    }else {
      emit(ChangedMsgSessionName());
    }

    this.add(Connect(sessionId: ""));
  }

  Future<void> _onExitSession (ExitSession event, Emitter<ConnectState> emit) async {
    emit(ExitingSession());

    bool success = false;

    /*
    BAUSTELLE
    if(userRepository.currentSession == event.sessionId || userRepository.currentUser.sessions.contains(event.sessionId)){
      success = await _tryQuitSession(sessionId: event.sessionId);
    }*/

    success = await _tryExitSession(sessionId: event.sessionId);

    if(!success){
      emit(ExitingSessionFailed());
    }else {
      emit(ExitedSession());
    }

    this.add(Connect(sessionId: ""));
  }

  Future<void> _onKillSession (KillSession event, Emitter<ConnectState> emit) async {
    emit(KillingSession());

    bool success = false;

    /*
    BAUSTELLE
    if(userRepository.currentSession == event.sessionId || userRepository.currentUser.sessions.contains(event.sessionId)){
      success = await _tryQuitSession(sessionId: event.sessionId);
    }*/

    success = await _tryKillSession(sessionId: event.sessionId);

    if(!success){
      emit(KillingSessionFailed());
    }else {
      emit(KilledSession());
      this.add(Connect(sessionId: ""));
    }
    this.add(Connect(sessionId: ""));

  }


  Future<void> _onChangeSessionName (ChangeSessionName event, Emitter<ConnectState> emit) async {
    emit(ChangingSessionName());

    bool success = false;

    /*
    BAUSTELLE
    if(userRepository.currentSession == event.sessionId || userRepository.currentUser.sessions.contains(event.sessionId)){
      success = await _tryQuitSession(sessionId: event.sessionId);
    }*/

    success = await _tryChangeSessionName(sessionId: event.sessionId, sessionName: event.sessionName);

    if(!success){
      emit(ChangingSessionNameFailed());
    }else {
      emit(ChangedSessionName());
    }
  }


  Future<void> _onInviteToNewSession (InviteToNewSession event, Emitter<ConnectState> emit) async {
    emit(SendingMsg());

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
      this.add(Connect(sessionId: ""));
    }
  }

  Future<void> _onInviteToExistingSession (InviteToExistingSession event, Emitter<ConnectState> emit) async {
    emit(SendingMsg());

    //bool success = await _trySendMsg(event.msg);

    var inviteeId = event.inviteeId;
    var inviteeUsername =  event.inviteeUsername;
    print(inviteeUsername);
    //THIS IS REALLY FUll. NOT SURE IF BLOC SHOULD HANDLE THIS.
    String senderUsername = userRepository.currentProfile.username;
    String senderId = userRepository.currentProfile.id;
    String sessionId = event.sessionId;
    String sessionName = event.sessionName;
    //Should CoppleRepo then send creation request for these?

    MetaInformation metaInfo = MetaInformation(
        sessionId: event.sessionId,
        receiverUsername: inviteeUsername,
        sessionName: sessionName,
        receiverId: inviteeId,
        senderUsername: senderUsername,
        senderId: senderId
    );

    print(metaInfo.toString());
    var msg = Message(
        id: "",
        subject: "Invitation - $sessionName", content: "$senderUsername invites you to join $sessionName",
        meta: metaInfo
    );

    print(msg);

    bool success= await _trySendMsg(msg);

    if(!success){
      emit(InvitingToNewSessionFailed());
    }else {
      emit(InvitedToNewSession());
      this.add(Connect(sessionId: ""));
    }
  }

  /*maybe differentiate join and enter session*/

  Future<void> _onEnterSession (EnterSession event, Emitter<ConnectState> emit) async {
    emit(EnteringSession(sessionId: event.sessionId, option: event.option));

    //bool success = await _trySendMsg(event.msg);
    bool success = false;

    //if(userRepository.user.contains() != event.sessionId || userRepository.currentUser.currentSession != event.sessionId){
      //success = await _tryEnterSession(sessionId: event.session.id);
      success = await _tryEvaluateCommons(sessionId: event.sessionId);
      await _tryLoadUser();
    //}

    Session? session = await _tryGetSession(sessionId: event.sessionId);

    if (session != null) {
      success = true;
    }else{success= false;
    };

    if(!success){
      emit(EnteringSessionFailed());
    }else {
      emit(EnteredSession(session: session!, option: event.option));
    }
  }

  Future<void> _onJoinSession (JoinSession event, Emitter<ConnectState> emit) async {
    emit(JoiningSession(sessionId: event.sessionId));

    //bool success = await _trySendMsg(event.msg);
    bool success = false;



    //if(userRepository.user.contains() != event.sessionId || userRepository.currentUser.currentSession != event.sessionId){
    success = await _tryJoinSession(sessionId: event.sessionId);
    await _tryEvaluateCommons(sessionId: event.sessionId);
    User? user = await _tryLoadUser();
    //}

    if(!success){
      emit(JoiningSessionFailed());
    }else {
      emit(JoinedSession(sessionId: event.sessionId));
    }

    //After joining a session enter it automatically
    if(user != null){
      //Session? pSession =  await _tryGetSession(sessionId: event.sessionId);//user.sessions.where((element) => element?.id ==event.sessionId).first;
      //if(pSession != null) {
        this.add(EnterSession(sessionId: event.sessionId, option: options.triggers));
      //}
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

  Future<bool> _onGetTrigger (GetTrigger event, Emitter<ConnectState> emit) async {
    emit(GettingTrigger(session:event.session));
    //print("ALLLLOOO");
    trigger = await _tryGetTrigger(session: event.session);

    if(trigger == null){
      if(event.index == null){
        emit(GettingTriggerFailed());
      }else{
        emit(GettingTriggerFailed(index: event.index));
      }
      return false;
    }else {
      if(event.index == null){
        print(trigger);
        triggers.add(trigger);
        emit(GotTrigger(trigger: trigger!));
      }else{
        print(trigger);
        triggers.add(trigger);
        emit(GotTrigger(trigger: trigger!, index: event.index));
      }
      return true;
    }
  }

  Future<void> _onGetTriggers (GetTriggers event, Emitter<ConnectState> emit) async {
    emit(GettingTriggers(session:event.session));
    //Don't know if additional states are necessary
    print(triggers);
    try{
        for (int i = 0; i < 1; i++) {
          /*Trigger? t = await _tryGetTrigger(session: event.session);
          if(t != null){
            triggers.add(t);
          }*/

          await GetTrigger(session: event.session, index: triggers.length);
        }
        if(triggers.length > 0) {
        emit(GotTriggers());
      }else{
          emit(GettingTriggersFailed());
        }
    }catch(e){
      emit(GettingTriggersFailed());
    }
  }

  Future<void> _onResetTriggers (ResetTriggers event, Emitter<ConnectState> emit) async {
    triggers = [];
  }

  //////////////////////////
  ///Repository Requests///
  ////////////////////////

  Future<User?> _tryLoadUser() async {
    try {
      //await userRepository.getUser();
      return userRepository.getUser();
    } on Exception {
      //print('failed loading box, connect bloc');
      return null;
    }
  }

  Future<List<Message>?> _tryLoadBox() async {
    try {
      //await userRepository.getUser();

      return userRepository.currentUser.box;
    } on Exception {
      //print('failed loading box, connect bloc');
      return null;
    }
  }

  Future<bool> _tryJoinSession({required String sessionId}) async {
    try {
      return connectRepository.joinSession(sessionId: sessionId, username: user.username);
    } on Exception {
      //print('failed entering session, connect bloc');
      return false;
    }
  }

  Future<bool> _trySendMsg(Message msg) async {
    try {
      final success = await connectRepository.sendMessage(msg: msg);
      return success;
    } on Exception {
      ////print('failed sending request, connect bloc');
      return false;
    }
  }

  Future<bool> _tryDeleteMsg({required String msgId}) async {
    try {
      final success = await connectRepository.deleteMessage(msgId: msgId);
      return success;
    } on Exception {
      ////print('failed sending request, connect bloc');
      return false;
    }
  }

  Future<bool> _tryInviteToNewSession({required String inviteeId, required String inviteeUsername, required String senderId, required String senderUsername}) async {
    try {
      //print(senderUsername);
      final success = await connectRepository.inviteToNewSession(inviteeId: inviteeId, inviteeUsername:inviteeUsername, senderId:senderId,  senderUsername:senderUsername);
      return success;
    } on Exception {
      ////print('failed sending request, connect bloc');
      return false;
    }
  }

  Future<bool> _tryExitSession({required String sessionId}) async {
    try {
      return connectRepository.exitSession(sessionId: sessionId);
    } on Exception {
      ////print('failed quitting session, connect bloc');
      return false;
    }
  }

  Future<bool> _tryKillSession({required String sessionId}) async {
    try {
      return connectRepository.killSession(sessionId: sessionId);
    } on Exception {
      ////print('failed quitting session, connect bloc');
      return false;
    }
  }

  Future<bool> _tryEvaluateCommons({required String sessionId}) async {
    try {
      return connectRepository.evaluateCommons(sessionId: sessionId);
    } on Exception {
      ////print('failed evl commons, connect bloc');
      return false;
    }
  }

  Future<Trigger?> _tryGetTrigger({required Session session}) async {
    try {
      ////print("try get trigger");
      return connectRepository.getTrigger(session: session);
    } on Exception {
      ////print('failed getting trigger, connect bloc');
      return null;
    }
  }

  Future<Session?> _tryGetSession({required String sessionId}) async {
    try {
      ////print("try get trigger");
      return connectRepository.getSession(sessionId: sessionId);
    } on Exception {
      ////print('failed getting trigger, connect bloc');
      return null;
    }
  }

  Future<bool> _tryChangeSessionName({required String sessionId, required String sessionName}) async {
    try {
      ////print("try get trigger");
      return connectRepository.changeSessionName(sessionId: sessionId, sessionName: sessionName);
    } on Exception {
      ////print('failed getting trigger, connect bloc');
      return false;
    }
  }

  Future<bool> _tryChangeMsgSessionName({required String msgId, required String newMsgSessionName}) async {
    try {
      ////print("try get trigger");
      return connectRepository.changeMsgSessionName(msgId: msgId, newMsgSessionName: newMsgSessionName);
    } on Exception {
      ////print('failed getting trigger, connect bloc');
      return false;
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
