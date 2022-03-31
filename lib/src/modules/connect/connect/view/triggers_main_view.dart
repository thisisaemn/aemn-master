import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import 'package:user_repository/user_repository.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:aemn/src/modules/profile/profile.dart';


class TriggersMainView extends StatefulWidget {
  Session session;

  TriggersMainView({required this.session});

  @override
  State<StatefulWidget> createState() => _TriggersMainView();
}

class _TriggersMainView extends State<TriggersMainView> {

  late Session _session;
  Trigger? _trigger;

  @override
  void initState() {
    super.initState();
    if (widget.session == null) {
      _session = Session.generic;
    } else {
      _session = widget.session;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: triggersBody(),
    );
  }

  Widget triggersBody () {
    if(_trigger != null){
      return TriggersMainView(session: _session);
    }else{
      BlocProvider.of<ConnectBloc>(context).add(
        GetTrigger(session: _session),
      );
      return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));
    }
  }

  Widget trigger(){
    return Container(child: Text("trigger", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),), alignment: Alignment.center,);
  }
}
