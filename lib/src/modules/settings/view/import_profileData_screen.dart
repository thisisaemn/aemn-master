import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:aemn/src/modules/settings/models/models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aemn/src/app/app.dart';

class ImportProfileDataScreen extends StatefulWidget {
  ImportProfileDataScreen() : super();

  @override
  State<StatefulWidget> createState() => _ImportProfileDataScreenState();
}

//How to check whether information has been imported already?
class _ImportProfileDataScreenState extends State<ImportProfileDataScreen> {
  ImportProfileDataFromOptions _chosenOption =
      ImportProfileDataFromOptions.spotify;
  String _inputUsername = "";
  String _inputPassword = "";

  @override
  initState() {
    _chosenOption = ImportProfileDataFromOptions.spotify;
  }

  // Title in appbar
  Widget importProfileDataTitle() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(
          'import profile data',
          textAlign: TextAlign.start,
          style: TextStyle(
            //backgroundColor: Colors.amberAccent.withOpacity(0.4),
            //fontWeight: FontWeight.bold,
            color: Colors.black,
            //shadows: [Shadow(blurRadius: 1.5)],
            // /*shadows: [Shadow(blurRadius: 4.0)],*/ /*backgroundColor: Colors.black54,*/ letterSpacing:  6.0,
            // wordSpacing: 5
          ),
        ));
  }

  //The Choose Option segment
  Widget importProfileDataFromOptionsList() {
    //return Expanded(child:
    return Container(
        height: 100, //(MediaQuery.of(context).size.height * 0.005),
        child: ListView.builder(
            itemCount: ImportProfileDataFromOptions.values.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor: giveColor(
                                chosen: _chosenOption ==
                                    ImportProfileDataFromOptions
                                        .values[index])),
                        child: Text(
                            ImportProfileDataFromOptions.values[index].name),
                        onPressed: () {
                          setState(() => _chosenOption =
                              ImportProfileDataFromOptions.values[index]);
                        },
                      ))
                ],
              );
            }));
  }

  //Color
  MaterialStateProperty<Color> giveColor({required bool chosen}) {
    if (chosen) {
      return MaterialStateProperty.all(Colors.black12);
    } else {
      return MaterialStateProperty.all(Colors.black12.withOpacity(0));
    }
  }

  //The action asssociated with the Option
  _actionForOption() {
    if (_chosenOption == 'spotify') {
      //BlocMethod to deal with ...
    } else if (_chosenOption == 'instagram') {
    } else if (_chosenOption == 'pinterest') {
    } else if (_chosenOption == 'twitter') {
    } else {}
  }

  //Username TextField
  Widget UsernameTextField() {
    return Container(
        padding: EdgeInsets.all(10),
        width: 300,
        child: TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => setState(() => _inputUsername = username),
          keyboardType: TextInputType.emailAddress,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            label: Row(children: [
              Icon(
                Icons.alternate_email,
                size: 14.0,
              ),
              Text(" username")
            ]),
            //labelText: 'email',
            //helperText: '',
            //errorText: state.email.invalid ? 'invalid email' : null,
          ),
        ));
  }

  //Password Textfield
  Widget PasswordTextField() {
    return Container(
      padding: EdgeInsets.all(10),
        width: 300.0,
        child: TextField(
          key: const Key('import_profileData_passwordInput_textField'),
          onChanged: (password) => setState(() => _inputPassword = password),
          obscureText: true,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            //labelText: 'password',
            label: Row(children: [
              Icon(
                Icons.lock_outlined,
                size: 14.0,
              ),
              Text(" password")
            ]),
            //helperText: 'password',
            //errorText: state.password.invalid ? 'invalid password: 8 characters, at least one number' : null,
          ),
        ));
  }

  Widget LoginButton(){
    return ElevatedButton(
        onPressed: () => _actionForOption(), 
        child: Container(child: Text("Login"),),
      style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
    );
  }

  Widget CredentialsSection() {
    return Expanded(child:
      Column(
      children: [UsernameTextField(), PasswordTextField(), LoginButton()],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //DIE NAVIGATION NICHT GEKLÄRT...
          title: importProfileDataTitle(),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 18,
            ),
            onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
              NavigationRequested(destination: NavigationDestinations.back),
            ),
          ),
        ),
        body: Column(
          children: [
            //Choice section
            importProfileDataFromOptionsList(),

            //Space
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              //Image of the Logo may be placed here
             // child: chosenOptionsLogo();
            ),

            //Credentials section
             CredentialsSection(),

          ],
        ));
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
                context.read<AppBloc>().add(AppLogoutRequested());
                Navigator.of(context).pop(false);
                //Navigator.of(context).pop(context);
                //Navigator.of(context).pop(true);
              }
              /*() {/*
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
                Navigator.of(context).pop(true);*/
              }*/
              ,
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
