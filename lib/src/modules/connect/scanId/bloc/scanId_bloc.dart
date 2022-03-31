import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scanId_event.dart';
part 'scanId_state.dart';

class ScanIdBloc extends Bloc<ScanIdEvent, ScanIdState> {
  ScanIdBloc() : super(ScanIdInitial());

  @override
  Stream<ScanIdState> mapEventToState(
    ScanIdEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  // TODO: implement initialState
  ScanIdState get initialState => throw UnimplementedError();
}

