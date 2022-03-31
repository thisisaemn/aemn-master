import 'package:flutter/material.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/modules/swipe/swipe.dart';


class SwipeView extends StatelessWidget {
  /*static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SwipeView());
  }*/

  //final String text;
  //final SwipeRepository swipeRepository;

  SwipeView(/*{@required this.swipeRepository}*/) : super();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SwipeBloc>(context).add(
      LoadSwipes(bias: []),
    );
    return BlocBuilder<SwipeBloc, SwipeState>(
        builder: (BuildContext context, SwipeState state){
          //if (profileNavigationState is ProfileShowing) {
          return BlocBuilder<SwipeBloc, SwipeState>(
              builder: (context, state) {
                if(state is Loaded){
                  return SwipeMainScreen();
                }else if(state is Loading){
                  return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
                } else{
                  return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
                }
              }
          );
        }
    );

  }

}


/*
class SwipeView extends StatefulWidget {
  @override
  _SwipeViewState createState() => _SwipeViewState();

}


class _SwipeViewState extends State<SwipeView> {
  /*return  BlocBuilder<SwipeNavigationBloc, SwipeNavigationState>(
  builder: (context, profileNavigationState) {*/
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          //if (profileNavigationState is ProfileShowing) {
          return BlocBuilder<SwipeBloc, SwipeState>(
              builder: (context, state) {
                return SwipeMainScreen();
              }
          );
        }
    );
  }

}
*/

