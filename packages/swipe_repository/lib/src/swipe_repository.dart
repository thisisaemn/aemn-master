import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:interest_repository/interest_repository.dart';

import 'models/models.dart';
import 'package:cache/cache.dart';
import 'package:constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//SAMPLE TILL I CAN

import 'sample_swipes.json';

class SwipeRepository {
  //Stream<SwipeSuggestion> _swipe_suggestions = new Stream.fromIterable(jsonDecode('sample_swipes.json')); //Initial value of User
  //Stream<SwipeSuggestion> _swipe_suggestions = new Stream.fromIterable([SwipeSuggestion.fromJson(jsonDecode('sample_swipes.json'))]);
  Stream<SwipeSuggestion> _swipe_suggestions = new Stream.fromIterable([SwipeSuggestion.generic]);

  SwipeRepository({CacheClient? cache, InterestRepository? interestRepository}) : _cache = cache ?? CacheClient(), _interestRepository = interestRepository ?? InterestRepository();

  final CacheClient _cache;
  final InterestRepository _interestRepository;

  /*Future<User> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
          () => _user=User.anonymous, //_user = User(id: const Uuid().v4()),
    );
  }*/

  //Future<Stream<SwipeSuggestion>> getSwipeSuggestionStream() async {
  Future<Stream<String>> getSwipeSuggestionStream() async {
    Stream<String> stream = new Stream.fromFuture(getData());
    print("Created the stream");

    stream.listen((data) {
      print("DataReceived: "+data);
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });

    print("code controller is here");
  return Future.delayed(
  const Duration(milliseconds: 300),
  () => stream, //_user = User(id: const Uuid().v4()),
  );
  }

  //Get randomSwipeSuggestions
  Future<List<SwipeSuggestion>?> getRandomSwipes() async {
    return [];
    List<List<Tag>> tags =  await _interestRepository.getRandomInterestTagGroups();//await _interestRepository.getRandomInterestTags();
    List<SwipeSuggestion>? ss = [];
    for(var tag in tags){
      SwipeSuggestion? s = await getTagsImageFromPexels(tags: tag);
      if(s!=null){
        ss.add(s);
      }

    }
    return ss;
  }


  Future<SwipeSuggestion?> getTagsImageFromPexels(/*List<Tag> tags*/ {required List<Tag> tags}) async {
    //Need to link back at pexels https://www.pexels.com/api/documentation/

   //If tags == null return random image

    const String apiToken = NetworkConstants.APIKEY_PEXELS;
    const String baseUrl = NetworkConstants.BASEURL_PEXELS;
    String searchKey = tags[0].name;
    String query = "search?query=$searchKey&per_page=1";

    String url = "" + baseUrl + query;

    var header = {
      "content-type" : "application/json",
      "authorization" : "$apiToken",
    };


    //
    print("Send API Request to get image to $searchKey");

    var res = await http.get(
      Uri.parse('$url'),
      headers: header,
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["photos"]);
      
      SwipeSuggestion result = SwipeSuggestion(id: resBody["photos"][0]["id"].toString(), partition: "partition="+resBody["photos"][0]["id"].toString(), tags: tags, src: resBody["photos"][0]["src"]["original"].toString(), reaction: 0);
      print(result);
      return result; //return true if successful
    }

    return null;
  }

  Future<String> getData() async {
    await Future.delayed(Duration(seconds: 5)); //Mock delay
    print("Fetched Data");
    return "This a test data";
  }

}
