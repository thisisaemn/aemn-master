import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/utils/utils.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';

class HomeLandingScreen extends StatelessWidget {
  /*static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeLandingScreen());
  }*/

  @override
  Widget build(BuildContext context) {
    return HomeLandingView(
        box: context.select(
      (ConnectBloc bloc) => bloc.user.box,
    ));
  }
}

class HomeLandingView extends StatefulWidget {
  //Should this be stateful widget??
  List<Message> box;

  HomeLandingView({required this.box}) : super();

  @override
  State<StatefulWidget> createState() => _HomeLandingViewState();
}

class _HomeLandingViewState extends State<HomeLandingView> {
  @override
  void initState() {
    super.initState();
    if (widget.box == null) {
      box = [];
      //print('the box was null');
    } else {
      //print('the box was not null');
      box = widget.box;
    }
    //print("the box is $box");
  }

  late List<Message> box;

  /*Widget? floatingActionButtonSession(BuildContext context, bool isInSession) {
    if (isInSession) {
      return ElevatedButton(
        //Hier eigentlich nur navigation when session existiert
        child: Text("enter session again"),
        //Icon(Icons.door_back_door_outlined, semanticLabel: "enter session",),
        onPressed: /*() => BlocProvider.of<ConnectBloc>(context).add(EnterSession(sessionId: "")),*/
            () => BlocProvider.of<NavigationBloc>(context).add(
          NavigationRequested(
              destination: NavigationDestinations
                  .commons), //Sollte hier iwo nicht die session id mitgegeben werden?
        ),
        //tooltip: 'enter session',
      );
    } else {
      return null;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*List<Session?> _sessions = context.select(
          (ConnectBloc bloc) => bloc.user.sessions,
    );*/
    /*
    User _user = context.select(
          (ConnectBloc bloc) => bloc.user,
    );*/

    return Scaffold(
      //drawer: SessionsOverviewView(),
      appBar: AppBar(
        //DIE NAVIGATION NICHT GEKLÄRT...
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.search,
            size: 18,
          ),
          tooltip: 'Search Interests',
          onPressed: /*() {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SwipeSearchScreen();
                  },
                ));
              },*/
              () => BlocProvider.of<NavigationBloc>(context).add(
            NavigationRequested(
                destination: NavigationDestinations.searchMembers),
          ),

          //onPressed: () {
          //showSearch(context: context, delegate: DataSearch(listWords));
          //https://stackoverflow.com/questions/58908968/how-to-implement-a-flutter-search-app-bar
          //}
        ),
        //title: SessionOverviewTitle(),
        //centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code, size: 18),
            tooltip: 'Show Id',
            onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.show),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera, size: 18),
            tooltip: 'Scan Id',
            onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.scan),
            ),
          ),
        ],
      ),
      //floatingActionButton: floatingActionButtonSession(context, context.select((ConnectBloc bloc) => bloc.userRepository.currentSession.id) != "" && context.select((ConnectBloc bloc) => bloc.userRepository.currentSession.id) != "00000000"),
      body: RefreshIndicator(
        child: Column(
          children: [Expanded(child: BoxList())],
        ),
        onRefresh: () {
          //Set List to zero during loading, make loading connect
          //What is the sessionId for ...
          BlocProvider.of<ConnectBloc>(context).add(Connect(sessionId: ''));
          return Future.delayed(Duration(milliseconds: 1));
        },
      ),
      //),
    );
  }

  /**
   * Helping Methods
   */
  bool userJoinedSession(
      {required List<String> sessions, required String sessionId}) {
    if (sessions.contains(sessionId)) {
      return true;
    }
    return false;
  }

  ///
  ///
  ///
  /// Combined Box and Sessions List
  Widget BoxList() {
    return ListView.builder(
      itemCount: (context.select((ConnectBloc bloc) => bloc.user.box).length) +
          (context.select((ConnectBloc bloc) => bloc.user.sessions).length) +
          2,
      itemBuilder: (BuildContext context, int index) {
        return Builder(builder: (context) {
          if (index == 0) {
            return Container(
              child: Text(
                "Invitations",
                textAlign: TextAlign.start,
                style: TextStyle(
                    backgroundColor: Colors.amberAccent.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 1.5)],
                    /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
                        6.0,
                    wordSpacing: 5),
              ),
              padding: EdgeInsets.all(20),
            );
          } else if (index <=
              (context.select((ConnectBloc bloc) => bloc.user.box).length)) {
            int bindex =
                (context.select((ConnectBloc bloc) => bloc.user.box).length) -
                    1;
            Message item = context.select(
              (ConnectBloc bloc) => bloc.user.box,
            )[bindex];
            return Dismissible(
                key: Key('$index'),
                background: Container(color: Colors.red),
                confirmDismiss: (DismissDirection direction) async {
                  return _deleteDialog(context, "");
                },
                onDismissed: (direction) {
                  //print("del msg");
                  BlocProvider.of<ConnectBloc>(context)
                      .add(DeleteMsg(msg: item));
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: BoxInvitationTile(
                      item,
                    )));
          } else if (index ==
              (context.select((ConnectBloc bloc) => bloc.user.box).length) +
                  1) {
            return Container(
              child: Text(
                "Active Sessions",
                textAlign: TextAlign.start,
                style: TextStyle(
                    backgroundColor: Colors.amberAccent.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 1.5)],
                    /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
                        6.0,
                    wordSpacing: 5),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            );
          } else if (index <
              (context.select((ConnectBloc bloc) => bloc.user.box).length) +
                  2 +
                  (context
                      .select((ConnectBloc bloc) => bloc.user.sessions)
                      .length)) {
            int sindex = index -
                (context.select((ConnectBloc bloc) => bloc.user.box).length) -
                2;

            KeyValue sessionRef = (context
                .select((ConnectBloc bloc) => bloc.user.sessions))[sindex];
            return Dismissible(
                key: Key('$index'),
                background: Container(color: Colors.red),
                confirmDismiss: (DismissDirection direction) async {
                  return _deleteDialog(context, "");
                },
                onDismissed: (direction) {
                  //print("del msg");
                  BlocProvider.of<ConnectBloc>(context)
                      .add(ExitSession(sessionId: sessionRef.id));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: SessionReferenceTile(sessionRef)));
          } else {
            return Container(
                child: Text(
                    "something went wrong. we have to chill and find another way."));
          }
        });
      },
    );
  }

  Widget SessionOverviewTitle() {
    return Container(
      margin: EdgeInsets.all(10),
      //padding: EdgeInsets.all(18),
      child: Text(
        'sessions',
        textAlign: TextAlign.center,
        style: TextStyle(
          //fontSize: 13,
          //fontWeight: FontWeight.w500,
          color: Colors.black,
          //shadows: [Shadow(blurRadius: 1.5)],
          /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/
          //letterSpacing: 4.0,
          //wordSpacing: 5
        ),
      ),
    );
  }

  //EnterSession button if session exists
  Widget enterSessionTriggersBtn({required String sessionId}) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black38.withOpacity(0.01)),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          BlocProvider.of<ConnectBloc>(context).add(
              EnterSession(sessionId: sessionId, option: options.triggers));
        },
        child: Container(
            child: Column(children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 20,
          ),
          Text('triggers', style: TextStyle(fontSize: 10.0))
        ])));
  }

  Widget enterSessionCommonsBtn({required String sessionId}) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black38.withOpacity(0.01)),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          BlocProvider.of<ConnectBloc>(context)
              .add(EnterSession(sessionId: sessionId, option: options.commons));
        },
        child: Container(
            child: Column(children: [
          Icon(
            Icons.people,
            size: 20,
          ),
          Text('commons', style: TextStyle(fontSize: 10.0))
        ])));
  }


  //sessions the user is already part of
  Widget JoinSessionBtn({
    required Message msg,
  }) {
    String sessionId;
    if (msg.meta.sessionId?.isEmpty ?? true) {
      sessionId = "";
    } else {
      sessionId = msg.meta.sessionId!;
    }

    String sessionName;
    //print("the session name is " + msg.meta.sessionName!);
    if (msg.meta.sessionName?.isEmpty ?? true) {
      sessionName = "";
    } else {
      sessionName = msg.meta.sessionName!;
    }

    //print(sessionName);

    return IconButton(
      icon: Icon(Icons.check_circle, color: Colors.lightGreen),
      onPressed: () async {
        String requester;
        if (msg.meta.senderUsername?.isEmpty ?? true) {
          requester = '';
        } else {
          requester = msg.meta.senderUsername!;
        }
        bool? res = await _showDialogConfirmConnection(msg);
        if(res != null && res){
          BlocProvider.of<ConnectBloc>(context).add(DeleteMsg(msg: msg));
        }

      },
    );
  }

  //Reject Invitation
  Widget RejectInvitationBtn({required Message msg}) {
    String sessionId;
    if (msg.meta.sessionId?.isEmpty ?? true) {
      sessionId = "";
    } else {
      sessionId = msg.meta.sessionId!;
    }

    String sessionName;
    //print("the session name is " + msg.meta.sessionName!);
    if (msg.meta.sessionName?.isEmpty ?? true) {
      sessionName = "";
    } else {
      sessionName = msg.meta.sessionName!;
    }

    //print(sessionName);

    return IconButton(
      icon: Icon(Icons.cancel, color: Colors.red),
      onPressed: () async {
        String requester;
        if (msg.meta.senderUsername?.isEmpty ?? true) {
          requester = '';
        } else {
          requester = msg.meta.senderUsername!;
        }
        //bool? resDialog = await _deleteDialog(context, "");
       //if( resDialog != null && resDialog){
         BlocProvider.of<ConnectBloc>(context).add(DeleteMsg(msg: msg));
         /*BlocProvider.of<ConnectBloc>(context)
             .add(ExitSession(sessionId: sessionId));*/
       //}
      },
    );
  }

  Widget invitationDetailsWidget({required Message msg}) {
    return Text(msg.content);
  }

  ///////////////

  /**
   * new list tile for connect
   */
  Widget BoxInvitationTile(
    Message msg,
  ) {
    String receiverUsername;
    String senderUsername;
    String sessionId;

    if ((msg.meta.receiverUsername)?.isEmpty ?? true) {
      receiverUsername = "";
    } else {
      receiverUsername = msg.meta.receiverUsername!;
    }

    if (msg.meta.senderUsername?.isEmpty ?? true) {
      senderUsername = "";
    } else {
      senderUsername = msg.meta.senderUsername!;
    }

    if (msg.meta.sessionId?.isEmpty ?? true) {
      sessionId = "";
    } else {
      sessionId = msg.meta.sessionId!;
    }

    String sessionName;

    if (msg.meta.sessionName?.isEmpty ?? true) {
      sessionName = "";
    } else {
      sessionName = msg.meta.sessionName!;
    }

    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20,0,0,0),
              width: MediaQuery.of(context).size.width *0.66,
                child:Text(msg.subject, overflow: TextOverflow.fade)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(3,0,0,0),
              width: MediaQuery.of(context).size.width *0.10,
              child: RejectInvitationBtn(msg: msg),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(3,0,0,0),
                width: MediaQuery.of(context).size.width *0.10,
                child: JoinSessionBtn(msg: msg),
            ),

          ],
        ),
        decoration: BoxDecoration(
            color: Colors.black38.withOpacity(0.01),
            border: Border.all(
              width: 0.9,
              color: Colors.black38.withOpacity(0.0),
            ),
            borderRadius: BorderRadius.circular(13))
    );
  }

  ///Session Ref Tile
  Widget SessionReferenceTile(KeyValue sessionRef) {
    String sessionId = sessionRef.key;
    String sessionName = sessionRef.value;
    /*if (sessionRef.key.isEmpty ?? true) {
      sessionId = "";
    } else {
      sessionId = sessionRef.key!;
    }

    if (sessionRef.value.isEmpty ?? true) {
      sessionName = "";
    } else {
      sessionName = sessionRef.value!;
    }*/

    return Container(
        width: MediaQuery.of(context).size.width,
        //height: 50,
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(15),
              child:Text(sessionName, style: TextStyle(
              overflow: TextOverflow.fade,
              //backgroundColor: Colors.amberAccent.withOpacity(0.4),
              //fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [Shadow(blurRadius: 1.5)],
              /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
          6.0,
              wordSpacing: 5))),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20,0,0,15),
                //width: MediaQuery.of(context).size.width *0.66,
                child:enterSessionCommonsBtn(sessionId: sessionId),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10,0,20,15),
              //width: MediaQuery.of(context).size.width *0.10,
              child: enterSessionTriggersBtn(sessionId: sessionId),
            ),
          ],
        ),
        ]),
        decoration: BoxDecoration(
            color: Colors.black38.withOpacity(0.03),
            border: Border.all(
              width: 0.9,
              color: Colors.black38.withOpacity(0),
            ),
            borderRadius: BorderRadius.circular(13))
    );

    /*return ListTile(
      title: Text(sessionName),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: enterSessionCommonsBtn(sessionId: sessionId)),
          Expanded(child: enterSessionTriggersBtn(sessionId: sessionId)),
        ],
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black38, width: 0.9),
          borderRadius: BorderRadius.circular(13)),
      //trailing: Divider(),
      // onLongPress: ()=>_changeMsgSessionNameDialog(initialValue: sessionName, context: context, msgId: msg.id),
    );*/
  }

  //Dieses Dialogue ist sehr provisorisch apparently
  Future<bool?> _showDialogConfirmConnection(
      /*BuildContext context,*/ Message _msg) async {
    // <-- note the async keyword here

    String sessionName;
    String sessionId;

    if (_msg.meta.sessionName?.isEmpty ?? true) {
      sessionName = "";
    } else {
      sessionName = _msg.meta.sessionName!;
    }

    if (_msg.meta.sessionId?.isEmpty ?? true) {
      sessionId = "";
    } else {
      sessionId = _msg.meta.sessionId!;
    }

    String confirmationTxt = 'Please confirm joining ' + sessionName + '.';

    // this will contain the result from Navigator.pop(context, result)
    final selectedValue = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          ConfirmDialog(/*requestedBy: _requestedBy,*/ msg: confirmationTxt),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedValue != null) {
      //UPDATE VALUE IF CHANGED
      if (selectedValue) {
        print("join session");
        BlocProvider.of<ConnectBloc>(context)
            .add(JoinSession(sessionId: (sessionId)));
        //Wait for this to enter
        return selectedValue;

      }
      return selectedValue;
    }
  }
}

Future<bool?> _deleteDialog(
  BuildContext context,
  String msg,
  /*Function deleteOperation*/
) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Please confirm:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete $msg?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

void _changeMsgSessionNameDialog(
    {required String msgId,
    required String initialValue,
    required BuildContext context}) async {
  final selectedValue = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (context) => TextFieldDialog(
      value: initialValue,
      msg: 'Enter new name',
    ),
  );

  if (selectedValue != null) {
    BlocProvider.of<ConnectBloc>(context).add(
      ChangeMsgSessionName(msgId: msgId, newMsgSessionName: selectedValue),
    );
  }
}
