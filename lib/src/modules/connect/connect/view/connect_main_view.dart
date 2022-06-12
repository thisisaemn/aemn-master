import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/utils/utils.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: SessionOverviewTitle(),
        centerTitle: true,
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
  Widget BoxList() {
    return ListView.builder(
      itemCount: context
          .select((ConnectBloc bloc) => bloc.user.box /*,  listen: true*/
              )
          .length,
      itemBuilder: (BuildContext context, int index) {
        return Builder(builder: (context) {
          Message item = context.select(
            (ConnectBloc bloc) => bloc.user.box,
          )[index];
          return Container(padding: EdgeInsets.all(10),child:BoxInvitationTile(
              item,
              context.select(
                (ConnectBloc bloc) => bloc.user.sessions,
              )));
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
  Widget enterSessionTriggersBtn(
      {required List<String> sessions, required String sessionId}) {
    if (!userJoinedSession(sessions: sessions, sessionId: sessionId)) {
      return Container();
    }
    return ElevatedButton(
        style: ButtonStyle(
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

  Widget enterSessionCommonsBtn(
      {required List<String> sessions, required String sessionId}) {
    if (userJoinedSession(sessions: sessions, sessionId: sessionId)) {
      return ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
          ),
          onPressed: () {
            BlocProvider.of<ConnectBloc>(context).add(
                EnterSession(sessionId: sessionId, option: options.commons));
          },
          child: Container(
              child: Column(children: [
            Icon(
              Icons.people,
              size: 20,
            ),
            Text('commons', style: TextStyle(fontSize: 10.0))
          ])));
    } else {
      return Container();
    }
  }

  Widget pressToJoinTxt(
      {required List<String> sessions, required String sessionId}) {
    if (userJoinedSession(sessions: sessions, sessionId: sessionId)) {
      return Container();
    }
    return Text(
      "press to join",
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  //sessions the user is already part of
  Widget JoinSessionBtn(
      {required Message msg, required List<String> sessions}) {
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

    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0.0),
      ),
      child: Column(
          children: [
        Text(/*msg.subject + " "+*/ sessionName),
        pressToJoinTxt(sessions: sessions, sessionId: sessionId),
      ]),
      onPressed: () {
        String requester;
        if (msg.meta.senderUsername?.isEmpty ?? true) {
          requester = '';
        } else {
          requester = msg.meta.senderUsername!;
        }

        if (msg.meta.sessionId != "" &&
            !userJoinedSession(sessions: sessions, sessionId: sessionId)) {
          _showDialogConfirmConnection(msg);
        }
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
  Widget BoxInvitationTile(Message msg, List<String> sessions) {
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

    return ListTile(
      title: JoinSessionBtn(msg: msg, sessions: sessions),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: enterSessionCommonsBtn(
                  sessions: sessions, sessionId: sessionId)),
          Expanded(
              child: enterSessionTriggersBtn(
                  sessions: sessions, sessionId: sessionId)),
        ],
      ),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black38, width: 0.9), borderRadius: BorderRadius.circular(13)),
      //trailing: Divider(),
    );

    /*return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      textColor: Colors.black,
      collapsedTextColor: Colors.black,
      iconColor: Colors.black,
      collapsedIconColor: Colors.black38,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: JoinSessionBtn(msg: msg, sessions: sessions)),
          enterSessionTriggersBtn(sessions: sessions, sessionId: sessionId)
        ],
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child:
                Container(
                  margin: EdgeInsets.fromLTRB(50, 0, 5, 0),
                //child: invitationDetailsWidget(msg: msg)
                )
            ),
            enterSessionCommonsBtn(sessions: sessions, sessionId: sessionId)
          ],
        )
      ],
    );*/
  }

  /**
   * This is the previous ListTile
   */
  Widget BoxMsgTile(Message item, List<Session?> sessions) {
    /* String senderUsername;

    if(msg.meta.senderUsername?.isEmpty ?? true){
      senderUsername = "";
    }else{
      senderUsername = msg.meta.senderUsername!;
    }*/

    return Dismissible(
        key: Key(item.id),
        child: Column(children: [
          SizedBox(height: 8),
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
            onPressed: () {
              if (item.meta.sessionId != "") {
                _showDialogConfirmConnection(item);
              }
            },
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                Icons.arrow_right,
                size: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      item.subject,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                    ),
                    Text(
                      item.content,
                      softWrap: true,
                    ),
                  ])),
            ]),
          )
        ]),
        background: Container(color: Colors.red),
        confirmDismiss: (DismissDirection direction) async {
          return _deleteDialog(
            context,
            "content",
          ); //...
        },
        onDismissed: (direction) {
          //and delete msg
          BlocProvider.of<ConnectBloc>(context).add(DeleteMsg(msgId: item.id));
          if (item.meta.sessionId != null) {
            BlocProvider.of<ConnectBloc>(context)
                .add(ExitSession(sessionId: item.meta.sessionId!));
          }
        });
  }

  //Dieses Dialogue ist sehr provisorisch apparently
  void _showDialogConfirmConnection(
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
        BlocProvider.of<ConnectBloc>(context)
            .add(JoinSession(sessionId: (sessionId)));
        //Wait for this to enter
        /* List<Session?> _ss = context.select(
              (ConnectBloc bloc) => bloc.user.sessions,
        );*/

        /*
        Session s;
        for(var i in _ss){
          if(i!= null && i.id == _sessionId){
            s= i;
            BlocProvider.of<ConnectBloc>(context)
                .add(JoinSession(sessionId: s.id));
            /*
            BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(
                  destination: NavigationDestinations
                      .session, session: s), //Sollte hier iwo nicht die session id mitgegeben werden? //Va jz da mehrere sessions mgl sind.
            );
             */
          }
        }*/

      }
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
