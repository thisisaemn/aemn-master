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

class Sent extends Loaded{}

class Sending extends Loading{}

class SendingFailed extends LoadingFailed{}

class InvitingToNewSession extends Loading{}

class InvitedToNewSession extends Loaded{}

class InvitingToNewSessionFailed extends LoadingFailed{}

class QuittingSession extends Loading{}

class QuittedSession extends Loaded{}

class QuittingSessionFailed extends LoadingFailed{}

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

  GettingTrigger({required this.session});

  @override
  List<Object> get props => [session];
}

class GotTrigger extends Loaded{
  final Trigger trigger;

  GotTrigger({required this.trigger});

  @override
  List<Object> get props => [trigger];
}

class GettingTriggerFailed extends LoadingFailed{}

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


