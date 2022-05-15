import 'package:aemn/src/modules/connect/connect.dart';
import 'package:connect_repository/connect_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';

import 'package:aemn/src/modules/connect/connect.dart';

class CommonsView extends StatelessWidget {
  Session? session;

  CommonsView({this.session});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ConnectBloc>(context).add(
      Load(),
    );
    //print("now in sessionview the session is");
    //print(session);
    return BlocBuilder<ConnectBloc, ConnectState>(
        builder: (context, state) {
          if(state is Loaded){
            if(session != null){
              return CommonsMainView(session: session!);
            }else{
              return SafeArea(child: Text("Error: No session has been passed."));
            }
          }
            return Scaffold(body:Center(child:CircularProgressIndicator.adaptive(backgroundColor: Colors.amber,)));

        }
    );
  }

}