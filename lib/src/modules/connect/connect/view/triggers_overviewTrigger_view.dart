import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OverviewTrigger extends StatelessWidget {
  const OverviewTrigger({required Trigger trigger}) : trigger = trigger;

  final Trigger trigger;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TriggerOverviewWidget(context: context, trigger: trigger),
      alignment: Alignment.center,
    );
  }

  //The trigger itself.

  Widget TriggerOverviewWidget(
      {required BuildContext context, required Trigger trigger}) {
    //return Container(child: Text(trigger.mainContent, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
    //https://api.flutter.dev/flutter/widgets/Stack-class.html
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Colors.white,
            child: TriggerWidget(trigger),
          ),
          Container(
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.bottomCenter,
              /*decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(0),
                    Colors.black12,
                  ],
                ),
              ),*/
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("swipe down de de down de de down de de down down down")
                  /*
                  //refreshing the trigger base
                  Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.12,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(Icons.refresh), onPressed: () => {}),
                        ],
                      )),*/
                  /*
                  //Rating the trigger
                  Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.12,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        children: [
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_up),
                              onPressed: () => {}),
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              onPressed: () => {}),
                        ],
                      )),*/
                ],
              )),
        ],
      ),
    );
  }

  /*final urlRegExp = new RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
  final urlMatches = urlRegExp.allMatches(text);
  List<String> urls = urlMatches.map(
          (urlMatch) => text.substring(urlMatch.start, urlMatch.end))
      .toList();
  urls.forEach((x) => print(x));*/



  Widget TriggerWidget(Trigger trigger) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          if(trigger.mainContentLink != null && Uri.tryParse(trigger.mainContentLink) != null){
            await launchUrl(Uri.dataFromString(trigger.mainContentLink));
          }
        },
        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
          child: Text(
        trigger.mainContent,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
      )),
      alignment: Alignment.center,
      padding: EdgeInsets.all(40),
    );
  }
}
