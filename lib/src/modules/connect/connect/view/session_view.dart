import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';

import 'package:aemn/src/modules/connect/connect.dart';

class SessionView extends StatelessWidget {
  Session? session;
  /*@override
  initState(){
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileLoad(),
    );
  }*/

  SessionView({this.session});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ConnectBloc>(context).add(
      Load(),
    );/*
    session = context
        .select(
            (ConnectBloc bloc) => bloc.user.sessions./*,  listen: true*/
    );*/
    print("now in sessionview the session is");
    print(session);
    return BlocBuilder<ConnectBloc, ConnectState>(
        builder: (BuildContext context, ConnectState state){
          //if (profileNavigationState is ProfileShowing) {
          return BlocBuilder<ConnectBloc, ConnectState>(
              builder: (context, state) {
                if(state is Loaded){
                  if(session != null){
                    return SessionMainView(session: session!, commons: session!.commons,);
                  }else{
                    return SafeArea(child: Text("Error: No session has been passed."));
                  }
                }else if(state is Loading){
                  return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
                } else{
                  return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
                }
              }
          );
        }
    );
  }

}