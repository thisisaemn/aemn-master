import 'package:flutter/material.dart';

import 'package:aemn/src/modules/search/search.dart';
import 'package:aemn/src/modules/profile/view/profile_edit_dialogs.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/utils/helpers/helpers.dart';

import 'package:uuid/uuid.dart';


class ProfileEditScreen extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfileEditScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18,),
              onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                NavigationRequested(destination: NavigationDestinations.back),
              ),
              tooltip: 'Back',
            );
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          final facts = context.select(
                (ProfileBloc bloc) => bloc.profile.facts,
          );
          final interests = context.select(
                (ProfileBloc bloc) => bloc.profile.interests,
          );
          //return Text(facts[0].value);
          return ProfileEditViewScreen(facts: facts, interests: interests,);
        },
      ),
    );
  }
}

//HANDLE NULL EXCEPTIONS ....
class ProfileEditViewScreen extends StatefulWidget {
  List<KeyValue>? facts; //= factsData;
  List<Interest>? interests; //= interestData;

  ProfileEditViewScreen({Key? key, this.facts, this.interests}) : super();

  @override
  State<StatefulWidget> createState() => _ProfileEditViewScreenState();
}

class _ProfileEditViewScreenState extends State<ProfileEditViewScreen> {
  late List<KeyValue> _facts; //= factsData;
  late List<Interest> _interests; //= interestData;

  @override
  void initState() {
    super.initState();
    //In case anything unexpected happens, thosse are the default options. This could be declared in the interst class, maybe even should.
    if (widget.interests == null) {
      _interests = [Interest.generic];
    } else {
      _interests = widget.interests!;
    }

    if (widget.facts == null) {
      _facts = [KeyValue.generic];
    } else {
      _facts = widget.facts!;
    }
  }


  @override
  Widget build(BuildContext context) {

    Widget navigationItemFact(KeyValue kv) {
      List<String> options = [];

      return (ListTile(
        leading: Text(kv.key),
        trailing: SizedBox(
          height: 100, width: 200, child: Text(kv.value)),
        onTap: () {
          //Apart from age everthing has an option
          if (kv.key == 'age') {
            _showSliderDialogFacts(
                kv, ConvertInput.stringToInt_tryParse(kv.value, 0),
                0.0, 100.0, 'how old will you turn this year?');
            //_editFactDateDialog();
          } else {
            //Determine the options
            for (int i = 0; i < OptionsFact.getOptionsFact.length; i++) {
              //GET THE POSSIBLE VALUES FOR A KEY
              if (OptionsFact.getOptionsFact[i]['key'] == kv.key) {
                options = OptionsFact.getOptionsFact[i]['value'] as List<String>;
              }
            }
            //...
            if (kv.key == 'gender') {
              _showPickerDialogFacts(kv, kv.value, options);
              //_editFactSexDialog();
            } else if (kv.key == 'beliefsystem') {
              _showPickerDialogFacts(kv, kv.value, options);
              //_editFactBeliefsystemDialog();
            } else if (kv.key == 'culture') {
              _showPickerDialogFacts(kv, kv.value, options);
              //_editFactCultureDialog();
            } else {
              _showCustomPickerDialogFacts(kv, kv.value, ['other']);
              //_editFactDialog(key);
            }
          }
        },
      ));
    }

    //The fudge was this?? Comment brother
    Widget navigationItemInterest(Interest interest) {
      //LIST OF TAGS
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
      Widget? giveTags() {
        if (interest.interestModel.tags != null && interest.interestModel.tags.length > 0) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: ClipRect(child: listOfWidgets(interest.interestModel.tags))),
            ],
          );
        } else
          return null;
      }

      return ListTile(
        title: Row(
          children: [
            Text(
              interest.interestModel.name,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
                child: Container(
                  width: 0,
                  height: 0.0,
                )),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.brown,
                      size: 10.0,
                    )),
                Text(
                  ConvertInput.intToString(interest.intensity),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: giveTags(),
        onTap: () {
          //_changeInterestIntensityDialog(index, name);
          _showSliderDialogInterest(interest, interest.intensity, -1.0, 1000,
              'on a scale from -1 to 1000, how interested are u in this topic . \nrange: \n-1 = uninterested\n0 = ambivalent\n1-1000 = degree of interest.');
        },
      );
    }

    Widget factSectionTitle(String name) {
      return Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(children: [
            Text('about you',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                )),
            Expanded(
                child: Container(
                  width: 0,
                  height: 0.0,
                )),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.grey,
              ),
              onPressed: () {
                //_addFactDialog();
                _showAddCustomPickerDialog(OptionsFact.getOptionsFact);
              },
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints.tight(Size(20, 20)),
            )
          ]));
    }

    Widget interestSectionTitle() {
      return Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(children: [
            Text('your interests',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                )),
            Expanded(
                child: Container(
                  width: 0,
                  height: 0.0,
                )),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.grey,
              ),
              onPressed: /*() {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SwipeSearchScreen();
                  },
                ));
              }*/ () => BlocProvider.of<NavigationBloc>(context).add(
                NavigationRequested(destination: NavigationDestinations.searchInterests),
              ),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints.tight(Size(20, 20)),
            )
          ]));
    }

    Widget combinedSectionTitle() {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text('edit profile',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 23.0,
                fontWeight: FontWeight.w300,
              )));
    }

    Widget combinedList() {
      return Expanded( //Check if no interests n stuff
          child: ListView.builder(
              itemCount: 2 + _interests.length + _facts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      factSectionTitle('you'),
                      Divider(),
                    ],
                  );
                }
                else if (index <= _facts.length) {
                  int i = index - 1;
                    return Dismissible(
                      //https://flutter.dev/docs/cookbook/gestures/dismissible
                        key: Key('$i'),
                        child: navigationItemFact(_facts[i]),
                        background: Container(color: Colors.red),
                        confirmDismiss: (DismissDirection direction) async {
                          return _deleteFactDialog(index, _facts[i].key, _facts[i]); //...
                        },
                        onDismissed: (direction) {
                          BlocProvider.of<ProfileBloc>(context).add(
                              ProfileDeleteFact(fact: _facts[i]));
                        }
                    );
                } else if(index == _facts.length + 1){ // nicht clean...
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        interestSectionTitle(),
                        Divider(),
                      ],
                    );
                  } else {
                  int i = index - _facts.length - 2;
                    return Dismissible(
                      //https://flutter.dev/docs/cookbook/gestures/dismissible
                      key: Key('$i'),
                      child: navigationItemInterest(_interests[i]),
                      confirmDismiss: (DismissDirection direction) async {
                        return _deleteInterestDialog(i, _interests[i].interestModel.name, _interests[i]);
                      },
                      onDismissed: (direction) {
                        // Remove the item from the data source., first dialog
                        BlocProvider.of<ProfileBloc>(context).add(
                            ProfileDeleteInterest(interest: _interests[i]));
                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$i dismissed")));
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        color: Colors.red,
                        child: Text('remove'),
                      ),
                    );
                  }
              }
              )
      );
    }

    return Scaffold(
        body: Column(
          children: [
            combinedSectionTitle(),
            combinedList(),
          ],
        ));
  }

  // DIALOGS TO EDIT

  ///EDIT INTERESTS

  ///Delete Fact
  Future<bool?> _deleteFactDialog(int index, String name, KeyValue kv) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please confirm the deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you confirm deleting $name from your interests?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                /*setState(() {
                  _interests.removeAt(index);
                });*/
                Navigator.of(context).pop(true);
              },
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

  ////DELETE AN INTEREST
  Future<bool?> _deleteInterestDialog(int index, String name, Interest interest) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please confirm the deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you confirm deleting $name from your interests?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                /*setState(() {
                  _interests.removeAt(index);
                });*/
                Navigator.of(context).pop(true);
              },
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

  //EDITS INTENSITY OF INTEREST
  void _showSliderDialogInterest(Interest interest, int _initialValue,
      double _min, double _max, String _msg) async {

    // this will contain the result from Navigator.pop(context, result)
    final selectedValue = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          SliderDialog(
              initialValue: _initialValue, min: _min, max: _max, msg: _msg),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedValue != null) {
      /*Interest editedInterest = interest.duplicateWithChangedIntensity(selectedValue);
      BlocProvider.of<ProfileBloc>(context).add(
          ProfileUpsertInterest(interestId: editedInterest.interestModel.id));
      */
      BlocProvider.of<ProfileBloc>(context).add(
          ChangeInterestIntensity(interestId: interest.interestModel.id, intensity: selectedValue));


      /*//UPDATE VALUE IF CHANGED
      for (int i = 0; i < _interests.length; i++) {
        if (_interests[i].id == interest.id) {
          setState(() {
            // _interests[i]['intensity'] = selectedValue;
          //cahnge value
          });
        }
      }*/
    }
  }

  ///EDIT FACTS

  ////EDIT AGE
  //SHOW EDIT DIALOG
  //https://stackoverflow.com/questions/54010876/how-to-implement-a-slider-within-an-alertdialog-in-flutter

  //Slider for Age
  void _showSliderDialogFacts(KeyValue kv, int _initialValue,
      double _min, double _max, String _msg) async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedValue = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          SliderDialog(
              initialValue: _initialValue, min: _min, max: _max, msg: _msg),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedValue != null) {
      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpsertFact(
            kv: KeyValue(id: kv.id, key: kv.key, value: '$selectedValue')),
      );

      //UPDATE VALUE IF CHANGED
      /*for (int i = 0; i < _facts.length; i++) {
        //&& facts[i]['value'] != '$_initialAge' ... this doesn't work. it was intended to reduce database request if it is not neccessary...

        if (_facts[i].key == 'age') {
          //HERE THE DATABASE SHOULD BE UPDATED...

          setState(() {
            //_facts[i].value = '$selectedValue';
            print('hello $selectedValue');
          });
        }
      };*/
    }
  }

  ////EDIT DROPDOWN, Culture Beliefsystem ... DIALOG
  void _showPickerDialogFacts(KeyValue kv, String _initialValue,
      List<String> options) async {
    final selectedValue = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          DropDownPickerDialog(
            dialogKey: kv.key,
            initialValue: _initialValue,
            options: options,
          ),
    );

    if (selectedValue != null) {
      //HERE THE DATABASE SHOULD BE UPDATED...
      /*
      for (int i = 0; i < _facts.length; i++) {
        if (_facts[i].key == key && _facts[i].value == _initialValue) {
          //HERE THE DATABASE SHOULD BE UPDATED...
          setState(() {
            //facts[i]['value'] = '$selectedValue';
            print('hello $selectedValue');
          });
        }
      }
      ;*/

      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpsertFact(
            kv: KeyValue(id: kv.id, key: kv.key, value: '$selectedValue')),
      );
    }
  }

  ////EDIT Custom DIALOG
  void _showCustomPickerDialogFacts(KeyValue kv, String _initialValue,
      List<String> options) async {
    final selectedValue = await showDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          CustomPickerDialog(
            dialogKey: kv.key,
            initialValue: _initialValue,
            options: options,
          ),
    );

    if (selectedValue != null) {
      //HERE THE DATABASE SHOULD BE UPDATED...
      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpsertFact(
            kv: KeyValue(id: kv.id, key: kv.key, value: '$selectedValue')),
      );
    }
  }

  ////Add Fact dialog
  void _showAddCustomPickerDialog(List<Map<String, Object>> options) async {
    final selectedValue = await showDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          AddCustomPickerDialog(
            options: options,
          ),
    );

    if (selectedValue != null) {
      //HERE THE DATABASE SHOULD BE UPDATED...

      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpsertFact(
          //Isn't it possible here to get the same id twice??
            kv: KeyValue(id: Uuid().v4(), key: selectedValue[0], value: selectedValue[1])),
      );

      /*
      setState(() {
        //AVOID REDUNDANT DATA!!!!11 SAFETIE COPLETELY IGNORED TILL NOW...
        print('adding item with key' + selectedValue[0]);
        _facts.add(KeyValue(key: selectedValue[0], value: selectedValue[1]));
      });*/
    }
  }
}