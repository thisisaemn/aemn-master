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
      _session = Session(id: "00000000", partition: "=00000000", name: "", members: [Member(id: "00000000", username: "aemn", active: false)], commons: Commons.generic, triggers: []);
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
    //_triggers = [context.select((ConnectBloc bloc) => bloc.trigger,), context.select((ConnectBloc bloc) => bloc.trigger,)];
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  PageController _pageController = PageController();

  Widget triggers(List<Trigger?> triggers){
    //return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
   //https://stackoverflow.com/questions/66111911/swipe-effect-of-tiktok-how-to-scroll-vertically-in-full-screen
   _triggers = context.select(
         (ConnectBloc bloc) => bloc.triggers,
   );
   if(_triggers == null){
      return Container();
    }
    return RefreshIndicator(child:  PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _triggers!.length + 2,
        itemBuilder: (context, index) {
          try {
           /* print(_pageController.page);
            double p = _pageController.page != null ? _pageController.page! : 0;
            int roundedP = p.round();
            print(roundedP);
            print(_triggers!.length-(_triggers!.length/3).round());
            if(roundedP == (_triggers!.length-(_triggers!.length/3)).round()){
              print("last");
              BlocProvider.of<ConnectBloc>(context).add(
                GetTriggers(session: _session),
              );
              //Get back to the page they were currently on
            }*/

           /* print(_triggers!.length);
            print(index);
            print(_triggers!.length <= index);
            print(_triggers);*/

            if((!(BlocProvider.of<ConnectBloc>(context).state is GettingTrigger) && _triggers!.length <= index) || _triggers![index]== null){
              //print("this trigger is null");
              BlocProvider.of<ConnectBloc>(context).add(GetTrigger(session: _session, index: index),);
              //return Container();
              return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
            }else if(BlocProvider.of<ConnectBloc>(context).state is GettingTrigger){
              return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
            }else if(BlocProvider.of<ConnectBloc>(context).state is GotTrigger){
              return /*Column(children: [Text("$index index, " + (_triggers!.length.toString()) + " length"),*/OverviewTrigger(trigger: _triggers![index]!,)/*])*/;
            }
            return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));


          } catch (e) {
            print(e);
            return Container();
          }
        }), onRefresh: () {
      BlocProvider.of<ConnectBloc>(context).add(ResetTriggers(),);
      // BlocProvider.of<ConnectBloc>(context).add(GetTriggers(session: _session),);
      BlocProvider.of<ConnectBloc>(context).add(GetTrigger(session: _session),);
      return Future.delayed(Duration(milliseconds: 1));
    });

  }
}
