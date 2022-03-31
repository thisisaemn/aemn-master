import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';

import 'package:aemn/src/modules/connect/connect.dart';

class TriggersView extends StatelessWidget {
  Session? session;

  TriggersView({this.session});

  @override
  Widget build(BuildContext context) {
    if(session!= null){
    BlocProvider.of<ConnectBloc>(context).add(
      GetTrigger(session: session!),
    );
    }else{
      return SafeArea(child: Text("Error: No session has been passed."));
    }

    return BlocBuilder<ConnectBloc, ConnectState>(
        builder: (BuildContext context, ConnectState state){
          //if (profileNavigationState is ProfileShowing) {
          return BlocBuilder<ConnectBloc, ConnectState>(
              builder: (context, state) {
                if(state is GotTrigger){
                  if(session != null){
                    return SessionMainView(session: session!, commons: session!.commons,);
                  }else{
                    return SafeArea(child: Text("Error: No session has been passed."));
                  }
                }else if(state is GettingTrigger){
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