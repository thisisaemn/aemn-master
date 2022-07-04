import 'package:aemn/src/modules/profile/bloc/profile_bloc.dart';
import 'package:aemn/src/modules/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';

class SearchInterestsFilterScreen extends StatefulWidget {
  SearchInterestsFilterScreen({
    Key? key,
  }) : super();

  @override
  State<StatefulWidget> createState() => _SearchInterestsFilterScreenState();
}

class _SearchInterestsFilterScreenState extends State<SearchInterestsFilterScreen> {
  String input = '';

  late SearchBloc _searchBloc;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context)
        .add(SearchInterestsKey(key: "", isInitialSearch: true));

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "filter criteria"
          ),
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
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext context, SearchState state) {
              return Container();
            }));
  }
}
