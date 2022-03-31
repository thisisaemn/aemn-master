part of 'swipe_bloc.dart';

@immutable
abstract class SwipeState {}

class SwipeInitial extends SwipeState {}

class Loading extends SwipeState{}

class LoadingFailed extends SwipeState{

}
class Loaded extends SwipeState {}

//class LoadSwipesReturned extends SwipeState{}

class ReactionToSwipeSent extends SwipeState{

}

class ReactionToSwipeFailed extends SwipeState{

}

class ReactingToSwipe extends SwipeState{

}

class ReactedToSwipe extends SwipeState{

}