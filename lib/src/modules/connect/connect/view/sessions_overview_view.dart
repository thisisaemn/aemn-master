


import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


class SessionsOverviewView extends StatefulWidget{
  //SessionsOverviewView({required this.sessions});

  @override
  State<StatefulWidget> createState() => _SessionsOverviewView();

}


class _SessionsOverviewView extends State<SessionsOverviewView>{
  late List<Session?> _sessions;

  @override
  void initState(){
    _sessions = [];
  }


  @override
  Widget build(BuildContext context) {

    List<Session?>? sessions = context.select((ConnectBloc bloc) => bloc.user.sessions);
    print( context.select((ConnectBloc bloc) => bloc.user));

    if(sessions != null){
      _sessions = sessions;
    }

    return Container(
        width: 200,
        child: Drawer(
            elevation: 5,
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: SafeArea(child:
            ListView.builder(
              itemCount: 1+_sessions.length,
              padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if(index==0){
                        return Container(
                          padding: EdgeInsets.all(18),
                        child:  Text(
                          'sessions',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(blurRadius: 1.5)],/*shadows: [Shadow(blurRadius: 4.0)],*//*backgroundColor: Colors.black54,*/ letterSpacing: 6.0, wordSpacing: 5), ),
                        );
                      }else {
                        //return Text("test");
                        List<String> members = [];
                        if(_sessions[index-1]!= null && _sessions[index-1]!.members != null) {
                          for (var member in _sessions[index-1]!.members){
                            if(member != null){
                              members.add(member.username);
                            }
                          }
                        }else{
                          return Container();
                        }
                        if(members.length <= 0){
                          return Text("smth's messed up with this session, no members.");
                        }
                        return ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                          ),
                          onPressed: () {
                            BlocProvider.of<ConnectBloc>(context)
                                .add(EnterSession(session: _sessions[index-1]!));


                            /*String requester = item.meta.senderUsername;
                            if (item.meta.sessionId != "") {
                              _showDialogConfirmConnection(
                                  context,
                                  item.meta.sessionId,
                                  "$requester would like to connect.");
                            }*/
                          },
                          child: Container(
                              height: 20,
                              child:ListView.builder(
                            itemCount: members.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index2) {
                              return Text(
                                members[index2] + " ",
                                softWrap: true,
                              );
                            },
                          ))

                        );
                      }

            }),
            )));
  }

}