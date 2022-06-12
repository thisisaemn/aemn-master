import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    /*BlocProvider.of<ConnectBloc>(context).add(
      Load(),
    );*/
    BlocProvider.of<ConnectBloc>(context).add(
      Connect(sessionId: ''),
    );

    return BlocBuilder<ConnectBloc, ConnectState>(
      builder: (BuildContext context, ConnectState state){
        if(state is Connected){
          return HomeLandingScreen();
        } else if(state is EnteredSession){
         // print('session has been passed');
          //print((state as EnteredSession).session);
          //Sollte session nicht awaited werden?

          if((state as EnteredSession).option == options.triggers){
            BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(
                  destination: NavigationDestinations.triggers, session: (state as EnteredSession).session), //Sollte hier iwo nicht die session id mitgegeben werden? //Va jz da mehrere sessions mgl sind.
            );
          }else{
            BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(
                  destination: NavigationDestinations.commons, session: (state as EnteredSession).session), //Sollte hier iwo nicht die session id mitgegeben werden? //Va jz da mehrere sessions mgl sind.
            );
          }

          //return SessionView(session: (state as EnteredSession).session);
          //return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        }else if(state is ExitedSession || state is JoinedSession){
          /*BlocProvider.of<ConnectBloc>(context).add(
            Load(),
          );*/
          BlocProvider.of<ConnectBloc>(context).add(
            Connect(sessionId: ''),
          );
          //return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        }//else{
          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        //}
      },
    );
  }

}