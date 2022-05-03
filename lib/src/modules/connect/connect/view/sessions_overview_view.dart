import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';

class SessionsOverviewView extends StatefulWidget {
  //SessionsOverviewView({required this.sessions});

  @override
  State<StatefulWidget> createState() => _SessionsOverviewView();
}

class _SessionsOverviewView extends State<SessionsOverviewView> {
  late List<Session?> _sessions;

  @override
  void initState() {
    _sessions = [];
  }

  @override
  Widget build(BuildContext context) {
    List<Session?>? sessions =
        context.select((ConnectBloc bloc) => bloc.user.sessions);
    print(context.select((ConnectBloc bloc) => bloc.user));

    if (sessions != null) {
      _sessions = sessions;
    }

    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
            backgroundColor: Colors.white,
            elevation: 5,
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: SafeArea(
              child: Column(
                children: [
                  SessionOverviewTitle(),
                  Expanded(child: SessionsOverviewList())
                ],
              ),
            )));
  }

  List<String> getSessionMembersUsername(Session session) {
    List<String> members = [];
    for (var member in session.members) {
      if (member != null) {
        members.add(member.username);
      }
    }
    return members;
  }

  Widget SessionOverviewTitle() {
    return Container(
      margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(18),
      child: Text(
        'sessions',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [Shadow(blurRadius: 1.5)],
            /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
                6.0,
            wordSpacing: 5),
      ),
    );
  }

  Widget SessionsOverviewList() {
    return ListView.builder(
        itemCount: _sessions.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          //Sessions need names
          //Check whether there are active members

          //Check whether session exists
          if (_sessions[index] == null) {
            return Container();
          }

          List<String> members = [];
          if (_sessions[index] != null && _sessions[index]!.members != null) {
            for (var member in _sessions[index]!.members) {
              if (member != null) {
                members.add(member.username);
              }
            }
          } else {
            return Container();
          }
          if (members.length <= 0) {
            return Text("smth's messed up with this session, no members.");
          }
          return SessionTile(pSession: _sessions[index]!, members: members);
        });
  }

  Widget SessionTile(
      {required Session pSession, required List<String> members}) {
    return Container(
      //height: MediaQuery.of (context).size.height * 0.15,
      child: ExpansionTile(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            pSession.name,
            style: TextStyle(fontSize: 16.0),
          ),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                BlocProvider.of<ConnectBloc>(context).add(
                    EnterSession(session: pSession, option: options.triggers));
              },
              child: Container(
                  child: Column(children: [
                Icon(Icons.local_fire_department_rounded),
                Text('triggers', style: TextStyle(fontSize: 10.0))
              ])))
        ]),
        controlAffinity: ListTileControlAffinity.leading,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                BlocProvider.of<ConnectBloc>(context).add(
                    EnterSession(session: pSession, option: options.commons));
              },
              child: Container(
                  child:
                      Column(children: [Icon(Icons.people), Text('commons')]))),
          membersList(getSessionMembersUsername(pSession))
        ],
      ),
    );
  }

  Widget membersList(List<String> members){

    return //Expanded(child:
    ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (BuildContext context, int index) {
          return Text(members[index]);
      },
    //)
    );
  }


}
