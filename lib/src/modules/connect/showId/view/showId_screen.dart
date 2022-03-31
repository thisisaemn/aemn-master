
import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../connect.dart';

//import 'package:aemn/src/assets/sample_data/aemn-interest-0.png';

//Later the code should be able to be scanned with the normal camera than redirect to aemn

class ShowIdScreen extends StatelessWidget {
  String code;

  ShowIdScreen({required this.code}) : super();

  @override
  Widget build(BuildContext context) {
    String userId = context.select((ConnectBloc bloc) => bloc.userRepository.currentUser.id,);
    String username = context.select(
          (ConnectBloc bloc) => bloc.userRepository.currentUser.username,
    );
    code = "https://www.aemn.io/connectionRequest/smencrtptyness/$userId;$username";
    return Scaffold(
      appBar: AppBar(//DIE NAVIGATION NICHT GEKLÄRT...
        elevation: 0,
        leading: Builder(
          ////NOT CLEAN!!!!!!!
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18,),
              onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                NavigationRequested(destination: NavigationDestinations.back),
              ),
              tooltip: 'go back',
            );
          },
        ),
        /*actions: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(code),
          ),
        ],*/
      ),
      body: Center(
        child: QrImage(
          data: code,
          version: QrVersions.auto,
          size: 250.0,
        ),
      ),
    );
  }
}