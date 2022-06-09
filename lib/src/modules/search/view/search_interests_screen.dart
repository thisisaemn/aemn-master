import 'package:aemn/src/modules/profile/bloc/profile_bloc.dart';
import 'package:aemn/src/modules/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';

class SearchInterestsScreen extends StatefulWidget {
  SearchInterestsScreen({
    Key? key,
  }) : super();

  @override
  State<StatefulWidget> createState() => _SearchInterestsScreenState();
}

class _SearchInterestsScreenState extends State<SearchInterestsScreen> {
  String input = '';

  // https://api.flutter.dev/flutter/material/TextField-class.html
  late TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    _listViewController = new ScrollController()..addListener(_scrollListener); //..addListener(_loadMore);

  }

  void dispose() {
    _controller.dispose();
    _listViewController.dispose(); //.removeListener(_loadMore);
    super.dispose();

  }

  //= SearchBloc();

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

  // https://www.kindacode.com/article/flutter-listview-pagination-load-more/
  // The controller for the ListView
  late ScrollController _listViewController;
  String currentSearchKey = "";

  //https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac

  _scrollListener() {
    //Bottom of list
    if (_listViewController.offset >= _listViewController.position.maxScrollExtent &&
        !_listViewController.position.outOfRange) {
      BlocProvider.of<SearchBloc>(context).add(
          SearchInterestsKey(key: currentSearchKey, isInitialSearch: false));
      //print("l 119 search interests screen");
    }

    //Over the top
    if (_listViewController.offset <= _listViewController.position.minScrollExtent &&
        !_listViewController.position.outOfRange) {

    }


  }



  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(
        SearchInterestsKey(key: "", isInitialSearch: true));

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 18),
                onPressed: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(ResetInterestsSearchResults());
                  BlocProvider.of<NavigationBloc>(context).add(
                    NavigationRequested(
                        destination: NavigationDestinations.back),
                  );
                }),
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
                  BlocProvider.of<SearchBloc>(context)
                      .add(ResetInterestsSearchResults());
                  BlocProvider.of<SearchBloc>(context).add(
                      SearchInterestsKey(key: value, isInitialSearch: true));
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
                onChanged: (String value) async {
                  //for the app to be dynamic
                  input = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.all(9),
                  border: OutlineInputBorder(),
                  labelText: 'search tags',
                  fillColor: Colors.white,
                ),
              );
            })),
        body: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext context, SearchState state) {
          return ListView.builder(
            controller: _listViewController,
            itemCount:
                BlocProvider.of<SearchBloc>(context).resultsInterests.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(BlocProvider.of<SearchBloc>(context)
                    .resultsInterests[index]
                    .name),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    //print("the id of the interest is \n");
                    //print(BlocProvider.of<SearchBloc>(context).resultsInterests[index].id);
                    var interestId = BlocProvider.of<SearchBloc>(context)
                        .resultsInterests[index]
                        .id;
                    BlocProvider.of<ProfileBloc>(context).add(
                      AddOrModifyInterest(
                          interestId: interestId, intensityDelta: 20),
                    );
                  },
                ),
              );
            },
          );
        }));
  }
}
