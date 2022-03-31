import 'dart:async';
//import 'packages: user_repository/lib/src/models/user.dart';
import 'package:interest_repository/interest_repository.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:constants/constants.dart';

//enum AuthenticationStatus { unknown, authenticated, unauthenticated }
const SERVER_IP = NetworkConstants.SERVER_IP;

class InterestRepository {
  /*final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }*/

  /*Stream<InterestModel> searchInterests({
    required String key
  }) async* {
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );
  }*/

  Future<List<InterestModel>> searchInterests({
    required String key
  }) async {
    var header = {
      "content-type" : "application/json"
    };
    var body = {
      "key": key
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/searchInterest'),
      headers: header,
      body: jsonEncode(body),
    );
    var interestArray = [InterestModel.generic];

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      var jsonInterestArray = resBody["searchResult"];
      interestArray = (jsonInterestArray as List<dynamic>)
          .map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      print(interestArray);

    }

    return interestArray;
  }

  Future<List<Tag>> getRandomInterestTags(int limit) async {
    return [Tag(name: "fashion", id: "")];
    var header = {
      "content-type" : "application/json"
    };
    var body = {
      "limit": limit,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/getRandomInterestTags'),
      headers: header,
      body: jsonEncode(body),
    );
    List<Tag> tagsArray = [];

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      var jsonInterestArray = resBody["searchResult"];
      tagsArray = (jsonInterestArray as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList();
      print(tagsArray);

    }

    //return tagsArray;

  }

  Future<List<List<Tag>>> getRandomInterestTagGroups() async {
    int limit = 20;
    List<List<Tag>> tagsArray = [];

    for(var i = 0; i<limit; i++){
      tagsArray.add(await getRandomInterestTags(3));
    }



    return tagsArray;
  }


  //void dispose() => _controller.close();
}