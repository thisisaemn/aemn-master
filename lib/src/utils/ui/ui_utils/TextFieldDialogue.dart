import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  /// initial selection for the slider
  ///
  final String msg;
  final String value;

  const TextFieldDialog({ Key? key, required this.msg, required this.value}) : super(key: key);

  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  //Suggested options
  String _msg = "";

  late String _value;
  late String finalValue;

  @override
  void initState() {
    super.initState();
    _msg = widget.msg;
    _value = widget.value;
    finalValue = widget.value;
  }


  //TEXTIELD FOR OTHER

  // TextEditingController _controller;
  Widget textFieldEdit() {
    return TextField(
      onSubmitted: (String value) async {
        finalValue = value;
      },
      onChanged: (String value) async {
        finalValue = value;
      },
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(9),
        border: OutlineInputBorder(),
        labelText: _value,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_msg),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: textFieldEdit(),
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
