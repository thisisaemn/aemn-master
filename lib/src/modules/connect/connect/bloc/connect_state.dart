part of 'connect_bloc.dart';

@immutable
abstract class ConnectState {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class ConnectInitial extends ConnectState {}

class Loading extends ConnectState{}

class Loaded extends ConnectState{}

class LoadingFailed extends ConnectState{}

class Connecting extends Loading{}

class Connected extends Loaded{}

class ConnectingFailed extends LoadingFailed{}

class SentMsg extends Loaded{}

class SendingMsg extends Loading{}

class SendingMsgFailed extends LoadingFailed{}

class DeletedMsg extends Loaded{}

class DeletingMsg extends Loading{}

class DeletingMsgFailed extends LoadingFailed{}

class ChangedMsgSessionName extends Loaded{}

class ChangingMsgSessionName extends Loading{}

class ChangingMsgSessionNameFailed extends LoadingFailed{}

class InvitingToNewSession extends Loading{}

class InvitedToNewSession extends Loaded{}

class InvitingToNewSessionFailed extends LoadingFailed{}

class ExitingSession extends Loading{}

class ExitedSession extends Loaded{}

class ExitingSessionFailed extends LoadingFailed{}

class KillingSession extends Loading{}

class KilledSession extends Loaded{}

class KillingSessionFailed extends LoadingFailed{}

class ChangingSessionName extends Loading{}

class ChangedSessionName extends Loaded{}

class ChangingSessionNameFailed extends LoadingFailed{}

class JoiningSession extends Loading{
  final String sessionId;

  JoiningSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class JoinedSession extends Loaded{
  final String sessionId;

  JoinedSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class JoiningSessionFailed extends LoadingFailed{}

class EnteringSession extends Loading{
  final String sessionId;
  final options option; //whether commons, triggers

  EnteringSession({required this.sessionId, required this.option});

  @override
  List<Object> get props => [sessionId, option];

}

class EnteredSession extends Loaded{
  final Session session;
  final options option; //whether commons, triggers

  EnteredSession({required this.session, required this.option});

  @override
  List<Object> get props => [session, option];
}

class EnteringSessionFailed extends LoadingFailed{}

class GettingSession extends Loading{}

class GotSession extends Loaded{}

class GettingSessionFailed extends LoadingFailed{}

class GettingTrigger extends Loading{
  final Session session;
  int? index = -1;

  GettingTrigger({required this.session, this.index});

  @override
  List<Object> get props => [session];
}

class GotTrigger extends Loaded{
  final Trigger trigger;
  int? index = -1;

  GotTrigger({required this.trigger, this.index});

  @override
  List<Object> get props => [trigger];
}

class GettingTriggerFailed extends LoadingFailed{
  int? index = -1;

  GettingTriggerFailed({this.index});

  @override
  List<Object> get props => [];
}

class GettingTriggers extends Loading{
  final Session session;

  GettingTriggers({required this.session});

  @override
  List<Object> get props => [session];
}

class GotTriggers extends Loaded{
  //final Trigger trigger;

  GotTriggers(); //{required this.trigger});

  //@override
  //List<Object> get props => [trigger];
}

class GettingTriggersFailed extends LoadingFailed{} //give error msg with it right


