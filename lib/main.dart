import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/config/config.dart';

import 'package:aemn/src/app/app.dart';



/*
void main() {
  Bloc.observer = SimpleBlocObserver();
  //LOAD SOME REPOSITORIES
  runApp(App());
}

class App extends StatelessWidget {
  final ThemeData theme = ThemeData(
    primaryColorDark: Colors.black,
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: AemnTheme.generateMaterialColor(Color(0xffffffff)), //PrimaryColor
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,

      home: BlocProvider<TabNavigat$HOME/
ionBloc>(
        create: (context) => TabNavigationBloc(
          homeRepository: HomeRepository(),
          profileRepository: ProfileRepository(),
          swipeRepository: SwipeRepository(),
        )..add(AppStarted()),
        child: AppScreen(),
      ),
    );
  }
}
*/

//https://bloclibrary.dev/#/flutterfirebaselogintutorial?id=splash
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:cache/cache.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  //Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  final cache = CacheClient();
  final authenticationRepository = AuthenticationRepository(cache: cache, userRepository: UserRepository(cache: cache));

  //final userRepository = UserRepository();

  //await authenticationRepository.user.first;


  BlocOverrides.runZoned(
        () => runApp(App(cache: cache, authenticationRepository: authenticationRepository/*, userRepository: userRepository,*/)),
    blocObserver: AppBlocObserver(),
  );
 // runApp(App(authenticationRepository: authenticationRepository, userRepository: userRepository,));

}
