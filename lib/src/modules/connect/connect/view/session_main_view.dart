
import 'package:aemn/src/modules/connect/connect.dart';

import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/utils/utils.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';

//This is the Sessions 'Frame', containig app bar for both the commons and triggers view option


class SessionMainView extends StatefulWidget {
  Session session;
  Widget sessionBody;

  SessionMainView({required this.session, required this.sessionBody});

  @override
  State<StatefulWidget> createState() => _SessionMainView();
}

class _SessionMainView extends State<SessionMainView> {

  late Session _session;
  late Widget _sessionBody; //triggers or commons body

  @override
  void initState() {
    super.initState();
    if (widget.session == null) {
      _session = Session(id: "00000000", partition: "=00000000", name: "", members: [Member(id: "00000000", username: "aemn", active: false)], commons: Commons.generic, triggers: []);;
    } else {
      _session = widget.session;
      _sessionBody = widget.sessionBody;
    }
  }
 //https://stackoverflow.com/questions/57748170/flutter-how-to-open-drawer-programmatically
  //final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: _key,
        appBar: AppBar(
            elevation:0,
            leading: BuilderBackButton(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.person_add_alt_1_rounded , size: 18,),
                  tooltip: 'Invite other members',
                  onPressed: () {
                    BlocProvider.of<NavigationBloc>(context).add(
                      NavigationRequested(destination: NavigationDestinations.searchMembersForAnExistingSession, session: _session),
                    );
                  }),
             /* IconButton(
                  icon: Icon(Icons.people , size: 20,),
                  tooltip: 'See members',
                  onPressed: () {
                    //_key.currentState!.openDrawer();
                    Scaffold.of(context).openEndDrawer();
                  }),*/
              IconButton(
                  icon: Icon(Icons.exit_to_app , size: 18,),
                  tooltip: 'Exit',
                  onPressed: () {
                    BlocProvider.of<ConnectBloc>(context).add( //This nav flow is not accurate
                        ExitSession(sessionId: _session.id)
                    );
                    BlocProvider.of<NavigationBloc>(context).add(
                      NavigationRequested(destination: NavigationDestinations.back),
                    );
                  }),
            ]),
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: MembersList(),
        ),
        body: _sessionBody,
        /*floatingActionButton: ElevatedButton(
          onPressed: () => {
            setState(() {
              _triggersMode = !_triggersMode;
            })
            /*BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.coppled), //Sollte hier iwo nicht die session id mitgegeben werden?
            ),*/
          },
          child: _triggersMode ? Text("commons") : Text("triggers"),
        ),*/
    );
  }

  /*Widget sessionBody () {
    if(_triggersMode){
      return TriggersView(session: _session);
    }else{
      return CommonsMainView(session: _session);
    }
  }*/

Widget MembersList(){
  return SafeArea(child: 
  Container(
    padding: EdgeInsets.all(10),
    child: ListView.builder(
      itemCount: _session.members.length+1,
      itemBuilder: (BuildContext context, int index){
        if(index == 0){
          return Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
              child:Text(
            'members',
            textAlign: TextAlign.start,
            style: TextStyle(
                backgroundColor: Colors.amberAccent.withOpacity(0.4),
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [Shadow(blurRadius: 1.5)],
                /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
            6.0,
                wordSpacing: 5),
          ));
        }else{
          return Container(
            padding: EdgeInsets.fromLTRB(20, 10,5, 0),
              child:Text(
            _session.members[index-1].username,
            textAlign: TextAlign.start,
            style: TextStyle(
              overflow: TextOverflow.fade,
                //backgroundColor: Colors.amberAccent.withOpacity(0.4),
                //fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [Shadow(blurRadius: 1.5)],
                /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
            6.0,
                wordSpacing: 5),
          ));
        }
       
      },
      
    ),
  ));
}




}

/*
class InterestList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: ListView.builder(itemBuilder: ))
  }

}*/