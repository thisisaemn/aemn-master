part of 'connect_bloc.dart';

@immutable
abstract class ConnectEvent {
  const ConnectEvent();

  @override
  List<Object> get props => [];
}

class Load extends ConnectEvent{

}


class Connect extends ConnectEvent{
  final String sessionId;

  Connect({required this.sessionId});

  List<Object> get props => [sessionId];

}

class SendMsg extends ConnectEvent{
  final Message msg;

  SendMsg({required this.msg});

  List<Object> get props => [msg];

}

class DeleteMsg extends ConnectEvent{
  final String msgId;

  DeleteMsg({required this.msgId});

  List<Object> get props => [msgId];

}

class InviteToNewSession extends ConnectEvent{
  final String inviteeId;
  final String inviteeUsername;

  InviteToNewSession({required this.inviteeId, required this.inviteeUsername});

  List<Object> get props => [inviteeId, inviteeUsername];

}

class InviteToExistingSession extends ConnectEvent{
  final String inviteeId;
  final String inviteeUsername;
  final String sessionName;
  final String sessionId;

  InviteToExistingSession({required this.inviteeId, required this.inviteeUsername, required this.sessionName, required this.sessionId});

  List<Object> get props => [inviteeId, inviteeUsername, sessionName, sessionId];

}

class ExitSession extends ConnectEvent{
  final String sessionId;

  ExitSession({required this.sessionId});

  List<Object> get props => [sessionId];
}

class KillSession extends ConnectEvent{
  final String sessionId;

  KillSession({required this.sessionId});

  List<Object> get props => [sessionId];
}

class ChangeSessionName extends ConnectEvent{
  final String sessionId;
  final String sessionName;

  ChangeSessionName({required this.sessionId, required this.sessionName});

  List<Object> get props => [sessionId, sessionName];
}

class JoinSession extends ConnectEvent{
  //final String sessionId;
  final String sessionId;

  JoinSession({required this.sessionId});

  List<Object> get props => [sessionId];

}

class EnterSession extends ConnectEvent{
  final String sessionId;
  //final Session session;
  final options option;

  EnterSession({required this.sessionId, required this.option});

  List<Object> get props => [sessionId, option];

}


class GetSession extends ConnectEvent{
  final String sessionId;

  GetSession({required this.sessionId});

  List<Object> get props => [sessionId];
}

class GetTrigger extends ConnectEvent{
  final Session session;
  int? index;

  GetTrigger({required this.session, this.index});

  List<Object> get props => [session];
}

class GetTriggers extends ConnectEvent{
  final Session session;


  GetTriggers({required this.session});

  List<Object> get props => [session];
}

class ResetTriggers extends ConnectEvent{

  ResetTriggers();

  List<Object> get props => [];
}

