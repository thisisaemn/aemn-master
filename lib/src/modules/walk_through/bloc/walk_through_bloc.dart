import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'walk_through_event.dart';
part 'walk_through_state.dart';

class WalkThroughBloc extends Bloc<WalkThroughEvent, WalkThroughState> {
  WalkThroughBloc() : super(WalkThroughInitial());

  @override
  Stream<WalkThroughState> mapEventToState(
    WalkThroughEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  // TODO: implement initialState
  WalkThroughState get initialState => throw UnimplementedError();
}
