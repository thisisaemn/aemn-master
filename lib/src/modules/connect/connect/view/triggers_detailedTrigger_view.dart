/*import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

//This view is not relevant right now. Dude why u always distracting.

class TriggerDetailedView extends StatelessWidget{
  final Trigger trigger;

  const TriggerDetailedView({required this.trigger});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        mainContent(),
      ],
    );
  }

  //Txt, could be a Headline, a question, a challenge
  Widget mainContent(){
    return TextButton(
        onPressed: () {if(trigger.mainContentLink != null && trigger.mainContentLink.isNotEmpty){
          js.context.callMethod('open', [trigger.mainContentLink]);
    }},
        child: Text(
          trigger.mainContent,
          overflow: TextOverflow.visible,
          softWrap: true,
    ));
  }

  //Could be photo, video, audio and corresponding link
  //images https://docs.flutter.dev/cookbook/images/network-image
  //video player guideline: https://docs.flutter.dev/cookbook/plugins/play-video
  //

  /*
  Widget media(){

    if(image){

    }
    return Container();
  }

  //could be article details, explanations, further realted content/posts
  Widget details(){
    return Container();
  }
*/



 */

/*
}

 */