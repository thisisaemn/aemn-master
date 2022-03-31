import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/utils/utils.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Widget? floatingActionButtonSession(BuildContext context, bool isInSession) {
    if (isInSession) {
      return ElevatedButton(
        //Hier eigentlich nur navigation when session existiert
        child: Text("enter session egain"),
        //Icon(Icons.door_back_door_outlined, semanticLabel: "enter session",),
        onPressed: /*() => BlocProvider.of<ConnectBloc>(context).add(EnterSession(sessionId: "")),*/
            () => BlocProvider.of<NavigationBloc>(context).add(
          NavigationRequested(
              destination: NavigationDestinations
                  .session), //Sollte hier iwo nicht die session id mitgegeben werden?
        ),
        //tooltip: 'enter session',
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Session?> _sessions = context.select(
          (ConnectBloc bloc) => bloc.user.sessions,
    );
    return Scaffold(
      drawer: SessionsOverviewView(),
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
        child: ListView.builder(
          itemCount: context
              .select(
                (ConnectBloc bloc) => bloc.user.box/*,  listen: true*/
              )
              .length,
          itemBuilder: (BuildContext context, int index) {
            return Builder(builder: (context) {
              Message item = context.select(
                (ConnectBloc bloc) => bloc.user.box,
              )[index];
              return Dismissible(
                  key: Key(item.id),
                  child: Column(children: [
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: () {
                        String requester = item.meta.senderUsername;
                        if (item.meta.sessionId != "") {
                          _showDialogConfirmConnection(
                              context,
                              item.meta.sessionId,
                              "$requester would like to connect.", _sessions);
                        }
                      },
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                            ),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                    item.subject,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 0),
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
                    BlocProvider.of<ConnectBloc>(context)
                        .add(QuitSession(sessionId: ''));
                  });
            });
          },
        ),
        onRefresh: () {
          //Set List to zero during loading, make loading connect
          BlocProvider.of<ConnectBloc>(context).add(Load());
          return Future.delayed(Duration(milliseconds: 1));
        },
      ),
      //),
    );
  }

  //Dieses Dialogue ist sehr provisorisch apparently
  void _showDialogConfirmConnection(BuildContext context,
      /*String _requestedBy,*/ String _sessionId, String _msg, List<Session?> _ss) async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedValue = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          ConfirmDialog(/*requestedBy: _requestedBy,*/ msg: _msg),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedValue != null) {
      //UPDATE VALUE IF CHANGED
      if (selectedValue) {
        BlocProvider.of<ConnectBloc>(context)
            .add(JoinSession(sessionId: _sessionId));
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
