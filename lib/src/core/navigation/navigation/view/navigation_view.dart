
import 'package:aemn/src/modules/settings/settings.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:swipe_repository/swipe_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:aemn/src/modules/profile/profile.dart';
import 'package:aemn/src/modules/swipe/swipe.dart';
import 'package:aemn/src/modules/search/search.dart';
import 'package:cache/cache.dart';

class AppPage extends StatelessWidget {
  /*const*/ AppPage();
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AppPage());
  }
  static Page page() => /*const*/ MaterialPage<void>(child: AppPage());

  //late final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = context.read<AuthenticationRepository>().userRepository;//= UserRepository(cache: context.read<AuthenticationRepository>().cache);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => NavigationBloc(userRepository: userRepository )),
        ],
        child: NavigationScreenView(cache: context.read<AuthenticationRepository>().cache, userRepository: userRepository));
  }
}


class NavigationScreenView extends StatefulWidget {
  final CacheClient cache;
  final UserRepository userRepository;

  NavigationScreenView({required this.cache, required this.userRepository}) : super();

  @override
  _NavigationScreenViewState createState() => _NavigationScreenViewState();
}

class _NavigationScreenViewState extends State<NavigationScreenView> {
  late final CacheClient _cache; //=  CacheClient();
  late final UserRepository _userRepository;
  late final SwipeRepository _swipeRepository;
  late final InterestRepository _interestRepository;
  late final ConnectRepository _connectRepository;

  void initState() {
    super.initState();
    //In case anything unexpected happens, thosse are the default options. This could be declared in the interst class, maybe even should.
    if (widget.cache == null) {
      //throw error
      _cache = CacheClient();
    } else {
      _cache = widget.cache;
      _interestRepository = InterestRepository();
      _userRepository = widget.userRepository;//UserRepository(cache: CacheClient());
      _swipeRepository = SwipeRepository(cache: _cache, interestRepository: _interestRepository);
      _connectRepository = ConnectRepository();

      _userRepository.getUser();
      _userRepository.getProfile();
    }
  }


  MultiBlocProvider blocProviderUserAndSwipeBloc(BuildContext context, Widget tChild) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileBloc(
                    userRepository: _userRepository) /*this.userRepository*/,),
          BlocProvider(
            create: (context) => SwipeBloc(swipeRepository: _swipeRepository, userRepository: _userRepository,),
          ),
          BlocProvider(
            create: (context) => ConnectBloc(userRepository: _userRepository, connectRepository: _connectRepository),
          ),
          BlocProvider(
            create: (context) => SearchBloc(userRepository: _userRepository, interestRepository: _interestRepository, connectRepository: _connectRepository),
          ),

        ],
        child: tChild);
  }

  NavigationDestinations giveDestinationByIndex(int index) {
    if(index ==0) {
      return NavigationDestinations.swipe;
    }else if(index == 1){
      return NavigationDestinations.home;
    }else if(index==2){
      return NavigationDestinations.profile;
    }else{
      return NavigationDestinations.home;
    }
  }

  int giveIndexByDestination(NavigationDestinations destination) {
    if(destination == NavigationDestinations.swipe) {
      return 0;
    }else if(destination == NavigationDestinations.home){
      return 1;
    }else if(destination==NavigationDestinations.profile){
      return 2;
    }else{
      return 1;
    }
  }


  Scaffold scaffoldNavigationScreenView(BuildContext context){
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (BuildContext context, NavigationState state) {
          //print(state);
          /*if (state is DestinationLoading) {
            /*if(state.currentDestination == NavigationDestinations.home || state.currentDestination == NavigationDestinations.session){
              //Say to this blocBuilder Load
              BlocBuilder<ConnectBloc, ConnectState>(
                  builder: (BuildContext ccontext, ConnectState cstate) {
                    //loading
                    //circular bla
                    ccontext
                        .read<ConnectBloc>()
                        .add(Load());
                    return true;

                    ccontext.read<Connect()

                    //loaded
                    //emit DestinationLoaded in NavigationBloc
                  }
                  );
            }else if(state.currentDestination == NavigationDestinations.profile){

            }else if(state.currentDestination == NavigationDestinations.swipe){

            }else{

            }*/
            //return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
          }*/
          print(state.session);

          if (state is DestinationLoaded || state is DestinationLoading) {
            switch(state.currentDestination){
              case(NavigationDestinations.home):  return  ConnectView();
              case(NavigationDestinations.swipe):  return SwipeView();
              case(NavigationDestinations.settings):  return  SettingsScreen(text: 'test');
              case(NavigationDestinations.searchInterests):  return  SearchInterestsScreen();
              case(NavigationDestinations.searchMembers):  return SearchMembersScreen();
              case(NavigationDestinations.profile): return ProfileScreen();
              case(NavigationDestinations.editProfile):  return ProfileEditScreen();
              case(NavigationDestinations.scan):  return ScanIdScreen(text: 'test');
              case(NavigationDestinations.show):  return ShowIdScreen(code: 'the QR Code Masterkey',);
              case(NavigationDestinations.session):  return SessionView(session: state.session);
              //case(NavigationDestinations.triggers):  return SessionView(session: state.session);
              //default: return HomeLandingScreen();
            }
          }




          /*
          if (state is HomeDestinationLoaded) {
                return  HomeLandingScreen();
          }

          if (state is SwipeDestinationLoaded) {
            return SwipeView();//SwipeScreen();
          }

          if (state is SettingsDestinationLoaded) {
            return SettingsScreen(text: 'test');;//SwipeScreen();
          }

          if(state is SearchInterestsDestinationLoaded){
            return SearchInterestsScreen();
          }

          if(state is SearchProfilesDestinationLoaded){
            return SearchMembersScreen();
          }

          if(state is ProfileDestinationLoaded){
            return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state){
                  /*BlocProvider.of<ProfileBloc>(context).add(
                      ProfileLoad());*/
                  return  ProfileScreen();
                }

            ); //Macht der Blocbuilder hier sinn? wo sind die anderen BlocBuilder?
          }

          if(state is EditProfileDestinationLoaded){
            return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state){
                  return ProfileEditScreen();
                }

            );
          }

          if(state is ScanIdDestinationLoaded){
            return BlocBuilder<ConnectBloc, ConnectState>(//Bloc?? Should this be handled in a separate bloc ... why u asking all these questions asking all these questions why u asking all these questions makin statements assuming.
                builder: (context, state){
                  return ScanIdScreen(text: 'test');
                }
            );
          }

          if(state is ShowIdDestinationLoaded){
            return ShowIdScreen(code: 'the QR Code Masterkey',); //Is he BlocBuilder neccesary?
          }

          if(state is SessionDestinationLoaded){
            return SessionScreen();
          }*/

          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        },
      ),
      bottomNavigationBar:
      BlocBuilder<NavigationBloc, NavigationState>(
          builder: (BuildContext context, NavigationState state) {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconSize: 18,
              unselectedFontSize: 10,
              selectedFontSize: 10.5,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.amber,
              selectedLabelStyle: TextStyle(color: Colors.black),
              currentIndex:
              giveIndexByDestination(context.select((NavigationBloc bloc) => bloc.currentDestination)),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Swipe',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_tree_sharp),
                  label: 'Connect',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: (index) => context
                  .read<NavigationBloc>()
                  .add(NavigationRequested(destination: giveDestinationByIndex(index))),
            );
          }),
    );
  }




  @override
  Widget build(BuildContext context) {
    return blocProviderUserAndSwipeBloc(context, scaffoldNavigationScreenView(context));
  }

}