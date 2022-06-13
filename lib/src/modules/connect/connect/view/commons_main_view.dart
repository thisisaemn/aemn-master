import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/profile/profile.dart';
import 'package:aemn/src/modules/connect/connect.dart';
import 'package:aemn/src/utils/utils.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';

//SRC: https://www.raywenderlich.com/books/flutter-apprentice/v2.0/chapters/5-scrollable-widgets#toc-chapter-011-anchor-003


class CommonsMainView extends StatefulWidget {
  final Session session;

  const CommonsMainView({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  State<CommonsMainView> createState() => _CommonsMainViewState();

}

  class _CommonsMainViewState extends State<CommonsMainView> {
  late final Session _session;
  bool _editing = false;

  @override
  void initState() {
    _session = widget.session;
  }

  @override
  Widget build(BuildContext context) {
    // 3
    return profileList(context);
  }

  /*Widget listOfMembers(List<Member> members) {
    List<Widget> list = []; //= List<Widget>();
    for (var i = 0; i < members.length; i++) {
      String content = members[i].username.toLowerCase();
      if (i == 0) {
        content = members[i].username.toLowerCase() + " ∙ ";
      } else if (i == members.length - 1) {
        content = members[i].username.toLowerCase();
      } else {
        content = " ∙ " + members[i].username.toLowerCase() + " ∙ ";
      }

      list.add(Container(
          child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
              //decorationColor: Colors.black,
              //decorationStyle: TextDecorationStyle.double,
              fontSize: 25,
              //backgroundColor: Colors.black,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [Shadow(blurRadius: 6.0)],
              /*backgroundColor: Colors.black54,*/
              letterSpacing: 7.0,
              wordSpacing: 5),
        ),

        /*Text(members[i].username.toLowerCase(),
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 23.0,
                      fontWeight: FontWeight.w300,
                    )),*/
      )));
    }

    return Wrap(
        spacing: 5.0, // gap between adjacent chips
        runSpacing: 2.0, // gap between lines
        children: list);
  }*/

  /*Widget usernameSection() {
    if (_session.members != null && _session.members.length > 0) {
      /*return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          listOfMembers(_session.members),
        ],
      );*/
      List<Member> members = _session.members;

      return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 33,
          child: ListView.builder(
            itemCount: members.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String content = members[index].username.toLowerCase();
              if (index == 0 && members.length == 2) {
                content = members[index].username.toLowerCase() + " ∩ ";
              } else if (index == members.length - 1) {
                content = members[index].username.toLowerCase();
              } else {
                content = " ∩ " + members[index].username.toLowerCase() + " ∩ ";
              }

              return Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                    //decorationColor: Colors.black,
                    //decorationStyle: TextDecorationStyle.double,
                    fontSize: 25,
                    //backgroundColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [Shadow(blurRadius: 6.0)],
                    /*backgroundColor: Colors.black54,*/
                    letterSpacing: 7.0,
                    wordSpacing: 5),
              );
            },
          ));

      //return Text('members');
    } else
      return Container(
        child: Text(''),
      );
  }*/

  Widget commonsListView(){
    if(_editing){
      return EditCommonsInterestsFactsListView(interests: _session.commons.interests,
          facts: _session.commons.facts, session: _session);
    }else{
      return InterestsFactsListView(
        interests: _session.commons.interests,
        facts: _session.commons.facts,
        username: _session.name,
      );
    }
  }

  Widget editBtn(){
    return ElevatedButton(
      onPressed: () => setState((){
        _editing = !_editing;
        if(_editing){
          editBtnTxt = "done";
        }else{
          editBtnTxt = "edit";
        }
      }),
      child: Text(
        editBtnTxt,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.4),
            letterSpacing: 3.0,
            wordSpacing: 0),
      ),
      style: ButtonStyle(elevation: MaterialStateProperty.all(0.3)),
    );
  }

  String editBtnTxt = "edit";

  Widget profileList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        //Set List to zero during loading, make loading connect
        BlocProvider.of<ConnectBloc>(context).add(Load());
        return Future.delayed(Duration(milliseconds: 5000));
      },
      child: (Stack(
        //crossAxisAlignment: CrossAxisAlignment.end,
        alignment: Alignment.topRight,
        children: [

        commonsListView(),
          editBtn()

      ],))
      /*child: ListView(
      scrollDirection: Axis.vertical,
      children: [
        SizedBox(height: 20),
        //usernameSection(),

        ElevatedButton(
            style: ButtonStyle(elevation: MaterialStateProperty.all(0.0)),
            onPressed: (){
              _changeSessionNameDialog(sessionId: session.id, initialValue: session.name, context: context);
          /*BlocProvider.of<ConnectBloc>(context).add(
              ChangeSessionName(sessionId: session.id, sessionName: session.name));*/
        }, child: Text(session.name, style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [Shadow(blurRadius: 6.0)],
            letterSpacing: 7.0,
            wordSpacing: 5))),

        /*Text(
          profile.username,
          textAlign: TextAlign.center,
          style: TextStyle(
            //decorationColor: Colors.black,
            //decorationStyle: TextDecorationStyle.double,
              fontSize: 30,
              backgroundColor: Colors.white60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 6.0)],
              /*backgroundColor: Colors.black54,*/
              letterSpacing: 7.0,
              wordSpacing: 5), ),*/
        SizedBox(height: 0),
        FactsListView(facts: session.commons.facts,),
        //TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
        const SizedBox(height: 20),
        InterestsListView(interests: session.commons.interests),
        /*Container(
            height: 400,
            color: Colors.green,
          ),*/
      ],
    )*/
    );
  }

  //Dialog

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
