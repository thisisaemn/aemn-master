import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    //null safetey do smth when event is null....
    super.onEvent(bloc, event);
    print('onEvent $event');
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}

//https://bloclibrary.dev/#/flutterweathertutorial