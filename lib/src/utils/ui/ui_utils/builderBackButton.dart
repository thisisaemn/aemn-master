import 'package:aemn/src/core/navigation/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BuilderBackButton extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return   Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios,size:18,),
          onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
            NavigationRequested(destination: NavigationDestinations.back),
          ),
          tooltip: 'Back',
        );
      },
    );
  }}