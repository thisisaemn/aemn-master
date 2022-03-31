//import 'package:copple_repository/connect_repository.dart';
import 'package:flutter/material.dart';

import 'package:aemn/src/modules/settings/settings.dart';
import 'package:aemn/src/modules/profile/profile.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';

class ProfileScreen extends StatelessWidget {

  /*@override
  initState(){
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileLoad(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    /*BlocProvider.of<ProfileBloc>(context).add(
      ProfileLoad(),
    );*/
    return  ProfileMainScreen(profile: context.select((ProfileBloc bloc) => bloc.profile,));
  }

}


/*
class ProfileScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfileScreen());
  }

  ProfileScreen(/*{UserRepository this.userRepository}*/) : super();

  //final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        /*BlocProvider(
        create: (_) => ProfileBloc(userRepository: UserRepository() /*userRepository*/),
    ),*/
      BlocProvider(
        create: (_) => NavigationBloc(),
      ),
    ], child: ProfileView());
      /*BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state){
          if(state == ProfileShowing){
            return ProfileOverviewScreen(number: -1);
          }else if(state == ProfileEditing){
            return ProfileEditScreen();
          }else {

          }

        }
    );*/

  }
}

class ProfileView extends StatefulWidget{
  @override
  _ProfileViewState createState() => _ProfileViewState();

}

class _ProfileViewState extends State<ProfileView>{
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, profileNavigationState) {
        return BlocBuilder<ProfileBloc, ProfileState>( //REDUNDANCY!!!!!!
            builder: (context, state){
              /*
              BlocProvider.of<ProfileBloc>(context).add(
                ProfileLoad(),
              );*/
              /*BlocProvider.of<ProfileBloc>(context).add(
                ProfileLoad(),
              );*/

              if (profileNavigationState is PageLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if(profileNavigationState is ProfileDestinationLoaded){
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state){
                      BlocProvider.of<ProfileBloc>(context).add(
                        ProfileLoad(),
                      );
                      return  ProfileMainScreen();
                    }

                );
                /*
          _navigator.pushAndRemoveUntil<void>(
            ProfileOverviewScreen.route(),
                (route) => false,
          );*/
              }else if(profileNavigationState is EditProfileDestinationLoaded){
                return BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state){
                      return ProfileEditScreen();
                    }

                );
                /*
          _navigator.pushAndRemoveUntil<void>(
            ProfileEditScreen.route(),
                (route) => false,
          );*/
              }else {
                return ProfileMainScreen();
                /*
          _navigator.pushAndRemoveUntil<void>(
            ProfileOverviewScreen.route(),
                (route) => false,
          );*/ //ICH VERSTEHE DIESE METHODEN NICHT GANZ.
              }
              //return  ProfileOverviewScreen();
            }

        );
      },
    );
  }

}

*/