import 'package:flutter/material.dart';
import 'dart:math';

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class SliderDialog extends StatefulWidget {
  /// initial selection for the slider
  final int initialValue;
  final double min;
  final double max;
  final String msg;

  const SliderDialog(
      {Key? key,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.msg})
      : super(key: key);

  @override
  _SliderDialogState createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  /// current selection of the slider
  late String _msg;
  double _min = 0;
  double _max = 100;
  late int _initialValue;
  late int _chosenValue;

  @override
  void initState() {
    super.initState();
    _msg = widget.msg;

    _min = widget.min;
    _max = widget.max;

    _initialValue = widget.initialValue;
    _chosenValue = _initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('$_msg'),
            Container(
              child: Slider(
                inactiveColor: Colors.grey,
                activeColor: Colors.grey,
                value: _chosenValue.toDouble(),
                min: _min,
                max: _max,
                divisions: _max.toInt() - (_min.toInt() + 1),
                onChanged: (value) {
                  setState(() {
                    _chosenValue = value.toInt();
                  });
                },
                label: '$_chosenValue',
              ),
            ),
            Text('$_chosenValue'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'save',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            //Navigator.of(context).pop(_initialAge);
            Navigator.pop(context, _chosenValue);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, _initialValue);
          },
        ),
      ],
    );
  }
}

//DROPDOWN Menu

class DropDownPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final String dialogKey;
  final String initialValue;
  final List<String> options;

  const DropDownPickerDialog({
    Key? key,
    required this.dialogKey,
    required this.initialValue,
    required this.options,
  }) : super(key: key);

  @override
  _DropDownPickerDialogState createState() => _DropDownPickerDialogState();
}

class _DropDownPickerDialogState extends State<DropDownPickerDialog> {
  /// current selection of the slider
  late String _dialogKey;
  late String _initialValue;
  late List<String> _options;
  late String value;
  late String finalValue;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.initialValue;
    _options = widget.options;
    _dialogKey = widget.dialogKey;

    //For Other
    _controller = TextEditingController();

    if (_options.contains(_initialValue)) {
      value = _initialValue;
    } else {
      value = 'other';
    }
  }

  late TextEditingController _controller;
  Widget textFieldForOther() {
    if (value == 'other') {
      return TextField(
        controller: _controller,
        onSubmitted: (String value) async {
          finalValue = value;
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thanks!'),
                content: Text(
                    'You typed "$value", which has length ${value.characters.length}.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        onChanged: (String value) async {
          //for the app to be dynamic
          finalValue = value;
        },
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.all(9),
          border: OutlineInputBorder(),
          labelText: '$_initialValue',
        ),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$_dialogKey'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('what $_dialogKey do you identify with?'),
            DropdownButton<String>(
              value: value,
              elevation: 16,
              onChanged: (chosenValue) {
                setState(() {
                  value = chosenValue!;
                  finalValue = chosenValue;
                });
              },
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            textFieldForOther(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'save',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            //Navigator.of(context).pop(_initialAge);
            Navigator.pop(context, finalValue);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}

//CUSTOM Dialog

class CustomPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final String dialogKey;
  final String initialValue;
  final List<String> options;

  const CustomPickerDialog({
    Key? key,
    required this.dialogKey,
    required this.initialValue,
    required this.options,
  }) : super(key: key);

  @override
  _CustomPickerDialogState createState() => _CustomPickerDialogState();
}

class _CustomPickerDialogState extends State<CustomPickerDialog> {
  /// current selection of the slider
  String _dialogKey = 'other';
  String _initialValue = '';
  late List<String> _options;
  late String value;
  late List<String> finalValue;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.initialValue;
    _options = widget.options;
    _dialogKey = widget.dialogKey;
    finalValue = [_dialogKey, _initialValue];

    //For Other
    //_controller = TextEditingController();

    if (_options.contains(_initialValue)) {
      value = _initialValue;
    } else {
      value = 'other';
    }
  }

  // TextEditingController _controller;
  Widget textFieldEdit(
    String editing,
  ) {
    String giveplaceholder() {
      if (editing == 'key') {
        return finalValue[0];
      } else if (editing == 'value') {
        return finalValue[1];
      }
      return '';
    }

    return TextField(
      //controller: _controller,
      onSubmitted: (String value) async {
        if (editing == 'key') {
          finalValue[0] = value;
        } else if (editing == 'value') {
          finalValue[1] = value;
        }
      },
      onChanged: (String value) async {
        //for the app to be dynamic
        if (editing == 'key') {
          finalValue[0] = value;
        } else if (editing == 'value') {
          finalValue[1] = value;
        }
      },
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(9),
        border: OutlineInputBorder(),
        labelText: giveplaceholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('edit tag'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text('tag name:'),
                  ),
                  Expanded(child: textFieldEdit('key')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text('tag value:'),
                  ),
                  Expanded(child: textFieldEdit('value')),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'save',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            //Navigator.of(context).pop(_initialAge);
            Navigator.pop(context, finalValue);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}

//ADD FACT Dialog

class AddCustomPickerDialog extends StatefulWidget {
  /// initial selection for the slider

  final List<Map<String, Object>> options;

  const AddCustomPickerDialog({Key? key, required this.options})
      : super(key: key);

  @override
  _AddCustomPickerDialogState createState() => _AddCustomPickerDialogState();
}

class _AddCustomPickerDialogState extends State<AddCustomPickerDialog> {
  //Suggested options
  List<Map<String, Object>> _options = [
    {'key': 'other', 'value': 'other'}
  ];
  List<String> keyOptions = [];
  List<String> valueOptions = [];

  late String value;
  List<String> selectedValue = ['other', 'other'];
  List<String> finalValue = ['other', 'other'];

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    finalValue = ['', ''];
    keyOptions = [];

    //INITILIZE KEY OPTIONS
    for (int i = 0; i < _options.length; i++) {
      //GET THE POSSIBLE VALUES FOR A KEY
      keyOptions.add(_options[i]['key'].toString());
    }
  }

  //Widget DROPDOWN

  Widget dropdownOption(editing, dropOptions) {
    String giveplaceholder() {
      if (editing == 'key') {
        return selectedValue[0];
      } else if (editing == 'value') {
        return selectedValue[1];
      }
      return '';
    }

    return DropdownButton<String>(

      value: giveplaceholder(),
      elevation: 16,
      onChanged: (chosenValue) {
        if (editing == 'key') {
          setState(() {
            finalValue[0] = chosenValue!;
            selectedValue[0] = chosenValue;
            //this was placed in give dropdown before
            //Specify options for chosen key
            for (int i = 0; i < _options.length; i++) {
              //GET THE POSSIBLE VALUES FOR A KEY
              if (_options[i]['key'] == selectedValue[0]) {
                valueOptions = _options[i]['value'] as List<String>;
              }
            }
          });
        } else if (editing == 'value') {
          setState(() {
            finalValue[1] = chosenValue!;
            selectedValue[1] = chosenValue;
          });
        }
      },
      items: dropOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  //DROPDOWN MENU
  Widget giveDropdown(editing) {
    if (editing == 'key') {
      //EDITING KEY
      return dropdownOption(editing, keyOptions);
    } else if (editing == 'value') {
      //EDITING VALUE
      for (int i = 0; i < _options.length; i++) {
        //GET THE POSSIBLE VALUES FOR A KEY
        if (_options[i]['key'] == selectedValue[0]) {
          setState(() {
            valueOptions = _options[i]['value'] as List<String>;
          });
          return dropdownOption(editing, valueOptions);
        }
      }
    }
    return Container();
  }

  //TEXTIELD FOR OTHER

  // TextEditingController _controller;
  Widget textFieldEdit(
    String editing,
  ) {
    String giveplaceholder() {
      if (editing == 'key') {
        return finalValue[0];
      } else if (editing == 'value') {
        return finalValue[1];
      } else {
        return '';
      }
    }

    return TextField(
      onSubmitted: (String value) async {
        if (editing == 'key') {
          finalValue[0] = value;
        } else if (editing == 'value') {
          finalValue[1] = value;
        }
      },
      onChanged: (String value) async {
        //for the app to be dynamic
        if (editing == 'key') {
          finalValue[0] = value;
        } else if (editing == 'value') {
          finalValue[1] = value;
        }
      },
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(9),
        border: OutlineInputBorder(),
        labelText: giveplaceholder(),
      ),
    );
  }

  Widget giveTextfield(
    editing,
  ) {
    if (editing == 'key') {
      if (selectedValue[0] == 'other') {
        return textFieldEdit(editing);
      }
    } else if (editing == 'value') {
      if (selectedValue[1] == 'other') {
        return textFieldEdit(editing);
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add additional tags'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text('tag name:'),
                  ),
                  Container(width: 10.0,),
                  Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        giveDropdown('key'),
                        giveTextfield('key'),
                        ],
                      )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text('tag value:'),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      //giveDropdown('value'),
                      dropdownOption('value', valueOptions),
                      giveTextfield('value'),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'save',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            //Navigator.of(context).pop(_initialAge);
            Navigator.pop(context, finalValue);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}
