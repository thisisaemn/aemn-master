part of 'swipe_bloc.dart';

@immutable
abstract class SwipeEvent extends Equatable{
  const SwipeEvent();

  @override
  List<Object> get props => [];

}


class LoadSwipes extends SwipeEvent {
  final List<Tag>? bias;

  LoadSwipes({required this.bias});

  @override
  String toString() => 'Searching $bias in search bloc.';
}


class AddFavor extends SwipeEvent {
  List<Tag> tags;

  AddFavor({required this.tags});

}

class ReduceFavor extends SwipeEvent {
  List<Tag> tags;

  ReduceFavor({required this.tags});

}