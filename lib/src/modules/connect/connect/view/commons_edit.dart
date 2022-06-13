import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:aemn/src/utils/utils.dart';

import '../../connect.dart';

class EditCommonsInterestsFactsListView extends StatelessWidget {
  // 1
  final Session session;
  final List<Interest> interests;
  final List<KeyValue> facts;

  const EditCommonsInterestsFactsListView(
      {Key? key,
        required this.interests,
        required this.facts,
        required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
      ),
      // 3
      child: interestFactList(),
    );
  }

  Widget interestFactList() {
    return ListView.builder(
      itemCount: interests.length + facts.length +1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if(index==0){
          return //Username
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Username
                  EditSessionNameSection(sessionName: session.name, context: context, sessionId: session.id, ),
                ]);
        } else if (index <= facts.length) {
          //Facts Section
          if (index == 1) {
            // Section Header
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Facts Content
                const SizedBox(height: 16),

                Container(
                    padding: EdgeInsets.all(13),
                    child:Text(
                      'facts',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          backgroundColor: Colors.amberAccent.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [Shadow(blurRadius: 1.5)],
                          /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:
                      6.0,
                          wordSpacing: 5),
                    )),

                factTag(context, facts[index-1])
              ],
            );
          } else {
            return factTag(context, facts[index-1]);
          }
          return Container();
        } else {
          //Interests section
          int iindex = index - facts.length -1;
          if (index == facts.length +1  && interests.length > 0) {
            //Section Header
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 4
                //Divider(height: 2,),
                //const SizedBox(height: 16),
                Container(
                  //decoration: BoxDecoration(border: Border.all(color: Colors.black38, width: 0.9), borderRadius: BorderRadius.circular(13)),
                    padding: EdgeInsets.all(13),
                    child: Text(
                      'interests',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          backgroundColor: Colors.amberAccent.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          /*Colors.black26,*/
                          shadows: [Shadow(blurRadius: 1.5)],
                          /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/
                          letterSpacing: 6.0,
                          wordSpacing: 5),
                    )),
                // 5
                const SizedBox(height: 16),
                //Divider(height: 2,),

                Container(
                    child: interestItem(
                      interest: interests[iindex],
                    ))
              ],
            );
          } else {
            return Container(
                child: interestItem(
                  interest: interests[iindex],
                ));
          }
        }
      },
    );
  }

  Widget interestItem({required Interest interest}) {
    return ListTile(
      leading: Icon(
        Icons.arrow_right, //for now ti icons are ready
        //IconData(stringToInt_tryParse(interest.interestModel.icon, 57502), fontFamily: 'MaterialIcons'),
        size: 18,
      ),
      horizontalTitleGap: 0,
      title: Container(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          interest.interestModel.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: giveTags(interest.interestModel.tags),
      isThreeLine: true,
    );
  }

  int stringToInt_tryParse(String input, int def) {
    var i = int.tryParse(input);
    //print(input);
    //print(i);
    if (i == null) {
      return def;
    } else {
      return i;
    }
  }
  //https://medium.com/nextfunc/dart-flutter-how-to-parse-string-to-number-22c6e181e599

  //https://stackoverflow.com/questions/50441168/iterating-through-a-list-to-render-multiple-widgets-in-flutter , Paresh Mangukiya

  Widget listOfWidgets(List<Tag> item) {
    List<Widget> list = [];
    for (var i = 0; i < item.length; i++) {
      list.add(Container(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              item[i].name,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
          )));
    }
    return Wrap(
        spacing: 5.0, // gap between adjacent chips
        runSpacing: 2.0, // gap between lines
        children: list);
  }

  //Constraint needed
  Widget giveTags(List<Tag> tags) {
    if (tags != null && tags.length >= 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: ClipRect(child: listOfWidgets(tags))),
        ],
      );
    } else
      return SizedBox(width: 0, height: 0);
  }

  ////Facts
  Widget factTag(BuildContext context, KeyValue fact) {
    return ListTile(
      leading: Container(
          width: 20,
          child: Text(
            "_",
            style: TextStyle(color: Colors.black45, wordSpacing: 4),
          )), // Container(width: 20,),
      horizontalTitleGap: 0,
      title: Container(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(
          fact.value,
          /*style: TextStyle(
              //fontWeight: FontWeight.bold,
              color: Colors.black,
              //shadows: [Shadow(blurRadius: 2.0)],
              /*backgroundColor: Colors.black54,*/ letterSpacing: 3.0,
              wordSpacing: 1),*/
        ),
      ),
      subtitle: Text(
        fact.key,
        style: TextStyle(color: Colors.black45, wordSpacing: 4),
      ),
    );
  }

  Widget EditSessionNameSection({required String sessionId, required String sessionName, required BuildContext context}) {
    return ElevatedButton(
        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
        onPressed: () {
          _changeSessionNameDialog(initialValue: sessionName, context: context, sessionId: sessionId);
          /*BlocProvider.of<ConnectBloc>(context).add(
              ChangeSessionName(sessionId: session.id, sessionName: session.name));*/
        },
        child: Row(children: [
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        sessionName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 3.0,
                            wordSpacing: 5),
                      ),
                      Text(
                        "press to change username",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 3.0,
                            wordSpacing: 0),
                      ),
                    ],
                  )
              ))
        ]));
  }

  //Change Session Name

  void _changeSessionNameDialog(
      {required String sessionId,
        required String initialValue,
        required BuildContext context}) async {
    final selectedValue = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TextFieldDialog(
        value: initialValue,
        msg: 'Enter new session name',
      ),
    );

    if (selectedValue != null) {
      BlocProvider.of<ConnectBloc>(context).add(
        ChangeSessionName(sessionId: sessionId, sessionName: selectedValue),
      );
    }
  }
}
