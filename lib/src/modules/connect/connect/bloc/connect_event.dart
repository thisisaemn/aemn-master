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

class Send extends ConnectEvent{
  final Message msg;

  Send({required this.msg});

  List<Object> get props => [msg];

}

class InviteToNewSession extends ConnectEvent{
  final String inviteeId;
  final String inviteeUsername;

  InviteToNewSession({required this.inviteeId, required this.inviteeUsername});

  List<Object> get props => [inviteeId, inviteeUsername];

}

class QuitSession extends ConnectEvent{
  final String sessionId;

  QuitSession({required this.sessionId});

  List<Object> get props => [sessionId];
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

  GetTrigger({required this.session});

  List<Object> get props => [session];
}


