import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/modules/profile/bloc/profile_bloc.dart';
import 'package:aemn/src/modules/search/bloc/search_bloc.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:user_repository/user_repository.dart';

class SearchMembersForAnExistingSessionScreen extends StatefulWidget {
  SearchMembersForAnExistingSessionScreen({Key? key, required this.session}) : super();

  Session session;



  @override
  State<StatefulWidget> createState() => _SearchMembersForAnExistingSessionScreenState();
}

class _SearchMembersForAnExistingSessionScreenState extends State<SearchMembersForAnExistingSessionScreen> {
  String input = '';

  // https://api.flutter.dev/flutter/material/TextField-class.html
  late TextEditingController _controller;

  late Session _session;


  void initState() {
    super.initState();
    _controller = TextEditingController();
    _listViewController = new ScrollController()..addListener(_scrollListener);
    //_searchBloc = SearchBloc(userRepository: UserRepository());

    _session = widget.session;
  }

  void dispose() {
    _controller.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  //late final SearchBloc _searchBloc; //= SearchBloc();


  late ScrollController _listViewController;
  String currentSearchKey = "";

  _scrollListener() {
    //Bottom of list
    if (_listViewController.offset >= _listViewController.position.maxScrollExtent &&
        !_listViewController.position.outOfRange) {
      BlocProvider.of<SearchBloc>(context).add(
          SearchMembersKey(key: currentSearchKey, isInitialSearch: false));
      //print("l 119 search members screen");
    }

    //Over the top
    if (_listViewController.offset <= _listViewController.position.minScrollExtent &&
        !_listViewController.position.outOfRange) {

    }


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton( icon: Icon(Icons.arrow_back_ios, color: Colors.grey,size: 18,) ,onPressed:
            /*()=>BlocProvider.of<ConnectBloc>(context).add(
                EnterSession(sessionId: _session.id, option: options.commons))*/
              /*() => BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.connect, session: _session),*/
              ()=>  BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(
                  destination: NavigationDestinations.commons, session: _session), //Sollte hier iwo nicht die session id mitgegeben werden? //Va jz da mehrere sessions mgl sind.
            )
              ,),
            title: BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext context, SearchState state) {
                  return TextField(
                    controller: _controller,
                    onSubmitted: (String value) async {
                      input = value;
                      /*sContext
                            .read<SearchBloc>()
                            .add(SearchInterestsKey(key: value));*/
                      currentSearchKey = value;
                      BlocProvider.of<SearchBloc>(context).add(SearchMembersKey(key: value, isInitialSearch: true));
                    },
                    onChanged: (String value) async { //for the app to be dynamic
                      input = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(9),
                      border: OutlineInputBorder(),
                      labelText: 'search members',
                      fillColor: Colors.white,
                    ),
                  );
                }
            )

        ),
        body: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext context, SearchState state) {
              return ListView.builder(
                controller: _listViewController,
                itemCount: BlocProvider.of<SearchBloc>(context).resultsMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  if(BlocProvider.of<SearchBloc>(context).resultsMembers[index].id == BlocProvider.of<ConnectBloc>(context).userRepository.currentUser.id ){
                    return SizedBox(height: 0,);
                  }
                  else {
                    return ListTile(
                      title: Text(BlocProvider
                          .of<SearchBloc>(context)
                          .resultsMembers[index].username),
                      trailing: IconButton(
                        icon: Icon(Icons.animation), onPressed: () {
                          String iUsername = BlocProvider
                              .of<SearchBloc>(context)
                              .resultsMembers[index].username;
                          String iId = BlocProvider.of<SearchBloc>(context).resultsMembers[index].id;

                          BlocProvider.of<ConnectBloc>(context).add(
                            InviteToExistingSession(
                                inviteeUsername: iUsername,
                                inviteeId: iId,
                                sessionId: _session.id,
                                sessionName: _session.name)
                        );
                      },),
                    );
                  }
                },
              );
            }
        )

    );
  }

}