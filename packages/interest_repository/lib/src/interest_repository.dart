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

  /**
   * Search Interests is missing pageination and partial search
   * to solve pageination i will introduce a local variable pagen
   * it will store the amt of times loadMore has been called
   *
   * When search Interests is called for the first time pagen will be set to 0
   * Every time loadMore is called it will be increased by one
   *
   * The pagen information will be forwarded to the database
   *
   * if k=100 results are awaited with each return, then the for loop might look like this
   * for(int i = (pagen * k); i < (pagen + 1) * k ; i++){
   *    finalResult.append( listOfSortedDbDocs[i]);
   * }
   *
   * listOfSortedDbDocs implies that the Documents of the Collection will first be sorted by _id
   * the finalResult is what is to be expected to be returned
   *
   */

  /**
   * took a slightly different approach with a very similar principle
   *
   * instead of using pagen as the determining index
   * we sort the collection by _id
   * the last relevant returned id from the results is given as a parameter
   * k greater than that will be considered in the result
   *
   *
   */

  /*
  //original search interests method

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
  }*/

  Future<List<InterestModel>> searchInterests({
    required String key, required pagen, required lastId
  }) async {
    var header = {
      "content-type" : "application/json"
    };
    var body = {
      "key": key,
      "pagen": pagen,
      "lastId" : lastId
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
      //print(interestArray);

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