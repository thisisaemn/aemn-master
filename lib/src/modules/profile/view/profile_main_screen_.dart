import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


class ProfileMainScreen extends StatefulWidget {
  final Profile profile;

  ProfileMainScreen({required this.profile});

  @override
  State<StatefulWidget> createState() => _ProfileMainScreen();
}

class _ProfileMainScreen extends State<ProfileMainScreen> {

  late Profile profile;

  @override
  void initState() {
    super.initState();
    if (widget.profile == null) {
      profile = Profile.generic;
    } else {
      profile = widget.profile;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.settings,size: 18),
                  onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                    NavigationRequested(destination: NavigationDestinations.settings),  //Instead build scaffold and embed widget
                  ),
                  tooltip: 'Settings',
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, size: 18),
                tooltip: 'Edit Profile',
                onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                  NavigationRequested(destination: NavigationDestinations.editProfile),
                ),
          )]),
          body:profileList(context));
  }


  Widget profileList(BuildContext context){
    return RefreshIndicator(
        onRefresh: () {
          //Set List to zero during loading, make loading connect
          BlocProvider.of<ProfileBloc>(context).add(
              ProfileLoad());
          return Future.delayed(Duration(milliseconds: 1));
        },
        child: InterestsFactsListView(interests: profile.interests, facts: profile.facts,username: profile.username,)
    );
  }
}

/*
class InterestList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: ListView.builder(itemBuilder: ))
  }

}*/