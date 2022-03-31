import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'showId_event.dart';
part 'showId_state.dart';

class ShowIdBloc extends Bloc<ShowIdEvent, ShowIdState> {
  ShowIdBloc() : super(ShowIdInitial());

  @override
  Stream<ShowIdState> mapEventToState(
    ShowIdEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  // TODO: implement initialState
  ShowIdState get initialState => throw UnimplementedError();
}
