import 'package:aemn/src/modules/connect/connect.dart';

import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


class SessionMainView extends StatefulWidget {
  Session session;
  Commons commons;

  SessionMainView({required this.session, required this.commons});

  @override
  State<StatefulWidget> createState() => _SessionMainView();
}

class _SessionMainView extends State<SessionMainView> {

  late Session _session;
  bool _triggersMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.session == null) {
      _session = Session.generic;
    } else {
      _session = widget.session;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation:0,
            leading: Builder(

              ////NOT CLEAN!!!!!!!
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios,size:18,),
                  onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                    NavigationRequested(destination: NavigationDestinations.back),
                  ),
                  tooltip: 'Back',
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.cancel_outlined, size: 18,),
                  tooltip: 'quit',
                  onPressed: () {
                    //////COPPLED NAVIGATION???
                    BlocProvider.of<ConnectBloc>(context).add( //This nav flow is not accurate
                        QuitSession(sessionId: _session.id)
                    );
                    BlocProvider.of<NavigationBloc>(context).add(
                      NavigationRequested(destination: NavigationDestinations.back),
                    );
                  })
            ]),
        body:sessionBody(),
        floatingActionButton: ElevatedButton(
          onPressed: () => {
            setState(() {
              _triggersMode = !_triggersMode;
            })
            /*BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.coppled), //Sollte hier iwo nicht die session id mitgegeben werden?
            ),*/
          },
          child: _triggersMode ? Text("commons") : Text("triggers"),
        ),
    );
  }

  Widget sessionBody () {
    if(_triggersMode){
      return TriggersView(session: _session);
    }else{
      return CommonsMainView(session: _session);
    }
  }




}

/*
class InterestList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: ListView.builder(itemBuilder: ))
  }

}*/