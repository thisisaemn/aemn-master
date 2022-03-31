import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ConnectBloc>(context).add(
      Load(),
    );
    return BlocBuilder<ConnectBloc, ConnectState>(
      builder: (BuildContext context, ConnectState state){
        if(state is Loaded){
          return HomeLandingScreen();
        }else if(state is Loading){
          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        } else if(state is EnteredSession){
          print('session has been passed');
          print((state as EnteredSession).session);
          BlocProvider.of<NavigationBloc>(context).add(
            NavigationRequested(
                destination: NavigationDestinations.session, session: (state as EnteredSession).session), //Sollte hier iwo nicht die session id mitgegeben werden? //Va jz da mehrere sessions mgl sind.
          );
          //return SessionView(session: (state as EnteredSession).session);
          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        }else if(state is QuittedSession || state is JoinedSession){
          BlocProvider.of<ConnectBloc>(context).add(
            Load(),
          );
          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        }else{
          return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
        }
      },
    );
  }

}