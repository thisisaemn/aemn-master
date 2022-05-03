import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


//Pageination missing

class TriggersMainView extends StatefulWidget {
  Session? session;
  Trigger? trigger;

  TriggersMainView({required this.session, required this.trigger});

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
  Trigger? _trigger;

  @override
  void initState() {
    super.initState();
    if (widget.session == null) {
      _session = Session.generic;
    } else {
      _session = widget.session!;
    }
    if (widget.trigger != null) {
      _trigger = widget.trigger;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: triggersBody(),
    );
  }

  Widget triggersBody () {
    if(_trigger != null){
      return triggers(_trigger!);
    }else{
      print("we'Re in triggers main view");
      return Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,));
    }
  }

  Widget triggers(Trigger trigger){
    //return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
   //https://stackoverflow.com/questions/66111911/swipe-effect-of-tiktok-how-to-scroll-vertically-in-full-screen
    return PageView.builder(
       scrollDirection: Axis.vertical,
       itemCount: 2,
       itemBuilder: (context, index) {
         try {
           return Container(child: TriggerOverviewWidget(trigger), alignment: Alignment.center,);
         } catch (e) {
           print(e);
           return Container();
         }
       });

  }

  Widget TriggerOverviewWidget(Trigger trigger){
    //return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
    //https://api.flutter.dev/flutter/widgets/Stack-class.html
    return SizedBox(
      width: MediaQuery.of (context).size.width,
      height: MediaQuery.of (context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of (context).size.width,
            height: MediaQuery.of (context).size.height,
            //color: Colors.white,
            child: TriggerWidget(trigger),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withAlpha(0),
                  Colors.black.withAlpha(0),
                  Colors.black26
                ],
              ),
            ),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of (context).size.width * 0.12,
                    height: MediaQuery.of (context).size.height * 0.12,
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.refresh), onPressed: () => {}),
                      ],
                    )
                ),
                Container(
                    width: MediaQuery.of (context).size.width * 0.12,
                    height: MediaQuery.of (context).size.height * 0.12,
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        IconButton(icon: Icon(Icons.keyboard_arrow_up), onPressed: () => {}),
                        IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: () => {}),
                      ],
                    )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget TriggerWidget(Trigger trigger){
    return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);;
  }


}
