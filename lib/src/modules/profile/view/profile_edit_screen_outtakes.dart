/*
  //Outtake?
  //CHANGE INTENSITY OF INTEREST
  Future<bool> _changeInterestIntensityDialog(int index, String name) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('set Intensity'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('enter an intensity value for $name. \nrange: \n-1 = uninterested\n0 = ambivalent\n1-1000 = degree of interest. '),
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
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(
                'cancel',
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
////EDIT SEX DIALOG

  Future<bool> _editFactSexDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gender-Identity'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter which gender you identify with.'),
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

  ////EDIT BELIEFSYSTEM

  Future<bool> _editFactBeliefsystemDialog() async {
    String belief = '';
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Beliefsystem'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter the beliefsystem you identify with.'),
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

  ////EDIT CULTURE
  Future<bool> _editFactCultureDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Culture'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter a culture you identify with.'),
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

  ////EDIT UNSPECIFIED FACT

  Future<bool> _editFactDialog(
    String key,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$key'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter a value to change $key'),
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

  Future<bool> _addFactDialog() async {
    //Able to add about 5 custom facts and the standard facts, beliefsystem and culture also 5 each
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('add new fact'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('please choose a key \n'),
                Text('tap the key in the list and change the value please.'),
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
}


 */