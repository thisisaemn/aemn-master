import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';

import 'package:aemn/src/modules/connect/connect.dart';

//But this is the main management of triggers

class TriggersView extends StatelessWidget {
  Session? session;

  TriggersView({this.session});

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return SafeArea(child: Text("Error: No session has been passed."));
    }
    //
    //Get triggers based on the commons
    ///Create different interests/facts combinations 'trigger base' and request content based on that
    ///return List<Trigger> (length around 10) and forward it to the view
    ///react to feedback on triggers
    BlocProvider.of<ConnectBloc>(context).add(
      GetTriggers(session: session!),
    );
    //
    return BlocBuilder<ConnectBloc, ConnectState>(builder: (context, state) {
      //print("we are in trigger view state changed");
      if (state is GotTriggers) {
        //print('we are in trigger view got trigger');
        /*print(context.select(
          (ConnectBloc bloc) => bloc.trigger,
        ));*/
        return TriggersMainView(
            session: session,
            triggers: context.select(
              (ConnectBloc bloc) => bloc.triggers,
            ) /*trigger: context.select((ConnectBloc bloc) => bloc.trigger,),*/);
      } else if (state is GettingTriggersFailed) {
        return Center(child: Text("Getting trigger failed, triggers_view"));
      } else {
        //print('triggers view else');
        /*return Text(
            'else, yet another error, detected in triggers_view'); */
        return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
      }
    });
  }

  /*
  Widget contentForState(BuildContext context, ConnectState state,){
    if(state is GotTrigger){
      return TriggersMainView (session: session, /*trigger: context.select((ConnectBloc bloc) => bloc.trigger,),*/);
    }else if(state is GettingSessionFailed){
      return Scaffold(body:Center(child:Text("Getting trigger failed, triggers_view")));
    } else{
      return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
    }
  }*/

}
