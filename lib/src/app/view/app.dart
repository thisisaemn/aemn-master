import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/app/app.dart';
import 'package:aemn/src/config/themes/themes.dart';
import 'package:cache/cache.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required CacheClient cache,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        _cache = cache,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  //final UserRepository _userRepository;
  final CacheClient _cache;
  CacheClient get cache => _cache;

  @override
  Widget build(BuildContext context) {
    //Does this make sense?
    WidgetsFlutterBinding.ensureInitialized();
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}