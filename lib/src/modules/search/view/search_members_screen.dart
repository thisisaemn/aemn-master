import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/modules/profile/bloc/profile_bloc.dart';
import 'package:aemn/src/modules/search/bloc/search_bloc.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:user_repository/user_repository.dart';

class SearchMembersScreen extends StatefulWidget {
  SearchMembersScreen({Key? key}) : super();

  @override
  State<StatefulWidget> createState() => _SearchMembersScreenState();
}

class _SearchMembersScreenState extends State<SearchMembersScreen> {
  String input = '';

  // https://api.flutter.dev/flutter/material/TextField-class.html
  late TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    _listViewController = new ScrollController()..addListener(_scrollListener);
    //_searchBloc = SearchBloc(userRepository: UserRepository());
  }

  void dispose() {
    _controller.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  //late final SearchBloc _searchBloc; //= SearchBloc();

  /*@override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            BlocProvider(
              create: (context) => _searchBloc,

              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext context, SearchState state) {
                    return TextField(
                      controller: _controller,
                      onSubmitted: (String value) async {
                        input = value;
                        /*sContext
                            .read<SearchBloc>()
                            .add(SearchInterestsKey(key: value));*/
                        BlocProvider.of<SearchBloc>(context).add(SearchInterestsKey(key: value));
                        /*
                        await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thanks!'),
                                  content: Text ('You typed "$value", which has length ${value.characters.length}.'),
                                  actions: <Widget>[
                                  TextButton(
                                  onPressed: () { Navigator.pop(context); },
                                  child: const Text('OK'),
                                  ),
                                  ],
                                  );
                                },
                        );*/
                      },
                      onChanged: (String value) async { //for the app to be dynamic
                        input = value;
                      },
                      decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                contentPadding: EdgeInsets.all(9),
                                border: OutlineInputBorder(),
                                labelText: 'search',
                      ),
                  );
              }
            )

      )),
      body: BlocProvider(
            create: (context) => _searchBloc,

            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (BuildContext context, SearchState state) {
                return ListView.builder(
                    itemCount: BlocProvider.of<SearchBloc>(context).resultsInterests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                           title: Text(BlocProvider.of<SearchBloc>(context).resultsInterests[index].name),
                         );
                      },
                );
              }
              )
        )
    );
  }*/

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
                leading: IconButton( icon: Icon(Icons.arrow_back_ios, color: Colors.grey,size: 18,) ,onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                  NavigationRequested(destination: NavigationDestinations.back),
                ),),
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
                          /*
                        await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Thanks!'),
                                  content: Text ('You typed "$value", which has length ${value.characters.length}.'),
                                  actions: <Widget>[
                                  TextButton(
                                  onPressed: () { Navigator.pop(context); },
                                  child: const Text('OK'),
                                  ),
                                  ],
                                  );
                                },
                        );*/
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
                            icon: Icon(Icons.local_post_office_outlined), onPressed: () {
                            //print("the id of the interest is \n");
                            //print(BlocProvider.of<SearchBloc>(context).resultsInterests[index].id);

                            BlocProvider.of<ConnectBloc>(context).add(
                                InviteToNewSession(inviteeUsername: BlocProvider
                                    .of<SearchBloc>(context)
                                    .resultsMembers[index].username,
                                    inviteeId: BlocProvider
                                        .of<SearchBloc>(context)
                                        .resultsMembers[index].id)
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