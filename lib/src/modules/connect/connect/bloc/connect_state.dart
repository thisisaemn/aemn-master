part of 'connect_bloc.dart';

@immutable
abstract class ConnectState {

  const ConnectState();

  @override
  List<Object> get props => [];

}

class ConnectInitial extends ConnectState {}

class Loading extends ConnectState{

}

class Loaded extends ConnectState{

}

class Connecting extends ConnectState{

}

class Connected extends ConnectState{

}

class LoadingFailed extends ConnectState{

}

class ConnectingFailed extends ConnectState{

}

class Sent extends ConnectState{

}

class Sending extends ConnectState{

}

class SendingFailed extends ConnectState{

}

class InvitedToNewSession extends ConnectState{

}

class InvitingToNewSession extends ConnectState{

}

class InvitingToNewSessionFailed extends ConnectState{

}

class QuitingSession extends ConnectState{

}

class QuittedSession extends ConnectState{

}

class QuittingSessionFailed extends ConnectState{

}


class JoiningSession extends ConnectState{
  final String sessionId;

  JoiningSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];

}

class JoinedSession extends ConnectState{
  final String sessionId;

  JoinedSession({required this.sessionId});

  @override
  List<Object> get props => [sessionId];
}

class JoiningSessionFailed extends ConnectState{

}


class EnteringSession extends ConnectState{
  final Session session;

  EnteringSession({required this.session});

  @override
  List<Object> get props => [session];

}

class EnteredSession extends ConnectState{
  final Session session;

  EnteredSession({required this.session});

  @override
  List<Object> get props => [session];
}

class EnteringSessionFailed extends ConnectState{

}

class GettingSession extends ConnectState{

}

class GotSession extends ConnectState{

}

class GettingSessionFailed extends ConnectState{

}

class GettingTrigger extends ConnectState{
  final Session session;

  GettingTrigger({required this.session});

  @override
  List<Object> get props => [session];
}

class GotTrigger extends ConnectState{
  final Trigger trigger;

  GotTrigger({required this.trigger});

  @override
  List<Object> get props => [trigger];
}

class GettingTriggerFailed extends ConnectState{

}


