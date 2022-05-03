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
              builder: (context, state) {
                print("we are in trigger view state changed");
                if(state is GotTrigger){
                  print('we are in trigger view got trigger');
                  print(context.select((ConnectBloc bloc) => bloc.trigger,));
                  return TriggersMainView (session: session, trigger: context.select((ConnectBloc bloc) => bloc.trigger,),);
                }else if(state is GettingSessionFailed){
                  return Center(child:Text("Getting trigger failed, triggers_view"));
                } else{
                  print('triggers view else');
                  return Text('else'); //Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
                }
              }
          );
        }

  Widget contentForState(BuildContext context, ConnectState state,){
    if(state is GotTrigger){
      return TriggersMainView (session: session, trigger: context.select((ConnectBloc bloc) => bloc.trigger,),);
    }else if(state is GettingSessionFailed){
      return Scaffold(body:Center(child:Text("Getting trigger failed, triggers_view")));
    } else{
      return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
    }
  }

}