import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


//Pageination missing

//This page does also have to deal with the management of triggers.

class TriggersMainView extends StatefulWidget {
  Session? session;
  List<Trigger?>? triggers;

  TriggersMainView({required this.session, required this.triggers});

  @override
  State<StatefulWidget> createState() => _TriggersMainView();
}


/**
 * tiktok and reels like swiping to navigate through the triggers
 * if one is interested in the details tap the triggers
 * it is also needed to rate the triggers
 */

class _TriggersMainView extends State<TriggersMainView> {

  late Session _session;
  List<Trigger?>? _triggers;

  @override
  void initState() {
    super.initState();
    if (widget.session == null) {
      _session = Session.generic;
    } else {
      _session = widget.session!;
    }
    if (widget.triggers != null) {
      _triggers = widget.triggers;
    }else{
      //generateTriggers() ...
      _triggers = [];
    }

  }

  @override
  Widget build(BuildContext context) {
    _triggers = [context.select((ConnectBloc bloc) => bloc.trigger,), context.select((ConnectBloc bloc) => bloc.trigger,)];
    return Scaffold(
      body: triggersBody(),
    );
  }

  Widget triggersBody () {
    if(_triggers != null){
      return triggers(_triggers!);
    }else{
      //print("we'Re in triggers main view");
      return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
    }
  }

  PageController pageController = PageController();

  Widget triggers(List<Trigger?> triggers){
    //return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
   //https://stackoverflow.com/questions/66111911/swipe-effect-of-tiktok-how-to-scroll-vertically-in-full-screen
    if(_triggers == null){
      return Container();
    }
    return PageView.builder(
      controller: pageController,
       scrollDirection: Axis.vertical,
       itemCount: _triggers!.length,
       itemBuilder: (context, index) {
         try {
           if(_triggers![index]== null){
             return Container();
           }
           return OverviewTrigger(trigger: _triggers![index]!,);
         } catch (e) {
           print(e);
           return Container();
         }
       });
  }
}
