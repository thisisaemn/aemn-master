import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/app/app.dart';

//import 'package:aemn/src/assets/sample_data/aemn-interest-0.png';

class SettingsScreen extends StatelessWidget {
  final String text;

  SettingsScreen({required this.text}) : super();

  //Define the functionality of this method.
  int stringToInt_tryParse(String input, int def) {
    var i = int.tryParse(input);
    //print(i);
    if (i == null) {
      return def;
    } else {
      return i;
    }
  }

  List<Map<String, Object>> settingsOptions = [
    {
      'key' : 'faq',
      'icon': '57986',
      'action': '',
    },
    {
      'key' : 'invite a friend',
      'icon': '58386',
      'action': '',
    },
    {
      'key' : 'privacy policy',
      'icon': '0xe846',
      'action': '',
    },
    {
      'key' : 'user agreement',
      'icon': '58530',
      'action': '',
    },
    {
      'key' : 'imprint',
      'icon': '58340',
      'action': '',
    },
    {
      'key' : 'change password',
      'icon': '59210',
      'action': '',
    },
    {
      'key' : 'logout',
      'icon': '59464',
      'action': '',
    }
  ];

  Widget settingsTitle(){
    return  Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text('settings',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 23.0,
              fontWeight: FontWeight.w300,
            )));
  }

  Widget settingsList(){

      return Expanded(child:
      ListView.builder(
          itemCount: settingsOptions.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(
                IconData(
                    stringToInt_tryParse(settingsOptions[index]['icon'].toString(), 60018),
                    fontFamily: 'MaterialIcons',),
                size: 18,
              ),
              title: Text(settingsOptions[index]['key'].toString()),
              onTap: (){
                settingsAction(context, settingsOptions[index]['key'].toString());
              },
            );
          })
      );
  }

  settingsAction(BuildContext context, String key){
    if(key == 'logout'){
      _logoutDialog(context);
    }else if(key == 'faq'){

    }else if(key == 'invite a friend'){

    }else if(key == 'privacy policy'){

    }else if(key == 'user agreement'){

    }else if(key == 'imprint'){

    }else if(key == 'change password'){

    }else{
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'This function is not available yet.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(//DIE NAVIGATION NICHT GEKLÄRT...
          elevation: 0,
          leading: IconButton( icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 18,) ,onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
            NavigationRequested(destination: NavigationDestinations.back),
          ),),
            ),
        body: Column(
          children: [
            settingsTitle(),
            settingsList(),
          ],
        )
    );
  }

  Future<bool?> _logoutDialog(BuildContext context) async {
    //Able to add about 5 custom facts and the standard facts, beliefsystem and culture also 5 each
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('please confirm that you would like to logout.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'logout',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () /*=>*/ {
                context
                    .read<AppBloc>()
                    .add(AppLogoutRequested());
                Navigator.of(context).pop(false);
                //Navigator.of(context).pop(context);
                //Navigator.of(context).pop(true);
              }
              /*() {/*
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
                Navigator.of(context).pop(true);*/
              }*/,
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
