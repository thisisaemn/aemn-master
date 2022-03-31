import 'package:flutter/widgets.dart';
import 'package:aemn/src/app/app.dart';
import 'package:aemn/src/modules/authentication/login/login.dart';
import 'package:aemn/src/core/navigation/navigation/navigation.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [AppPage.page()];
    case AppStatus.unauthenticated:
    default:
      print('unauthenticated');
      return [LoginPage.page()];
  }
}