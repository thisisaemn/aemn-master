import 'package:flutter/material.dart';

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class ConfirmDialog extends StatefulWidget {
  /// initial selection for the slider
  //final String requestedBy;
  final String msg;


  const ConfirmDialog({Key? key, /*required this.requestedBy,*/ required this.msg}) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  /// current selection of the slider
  late String _msg;
  //late String _requestedBy;

  @override
  void initState() {
    super.initState();
    _msg = widget.msg;
    //_requestedBy=widget.requestedBy;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Text('$_requestedBy would like to connect with you.'),
            Text('$_msg'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'cancel',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            //Navigator.of(context).pop(_initialAge);
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(
            'confirm',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
