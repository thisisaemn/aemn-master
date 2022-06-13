import 'dart:async';


import 'package:connect_repository/connect_repository.dart';
import 'package:interest_repository/interest_repository.dart';
import 'models/models.dart';
import 'package:cache/cache.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:constants/constants.dart';

//SERVER Adress
//const SERVER_IP = 'http://localhost:5000';
const SERVER_IP = NetworkConstants.SERVER_IP;



class UserRepository {
  UserRepository({CacheClient? cache,}): _cache = cache ?? CacheClient(){
    userStream=userController.stream;
    profileStream = profileController.stream;
    sessionsStream = sessionsController.stream;
    commonsStream = commonsController.stream;
  }
  final CacheClient _cache;
  User currentUser = User.anonymous; //Initial value of User
  Profile currentProfile = Profile.generic;
  List<Session> currentSessions = [];
  Commons currentCommons = Commons.generic;


  //? Machen die Streams wirklich Sinn? Wäre es vlt nicht besser, ein Stream zu haben, der nur angibt, das sich was verändert hat, zum neuladen?

  final StreamController<User> userController = StreamController<User>();
  late Stream<User> userStream; //= userController.stream; //= Stream();

  final StreamController<Profile> profileController = StreamController<Profile>();
  late Stream<Profile> profileStream;

  final StreamController<List<Session>> sessionsController = StreamController<List<Session>>();
  late Stream<List<Session>> sessionsStream;

  final StreamController<Commons> commonsController = StreamController<Commons>();
  late Stream<Commons> commonsStream;




  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    /*return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });*/

    userStream = userController.stream;
    //final user = User.empty; //? Was passiert hier, wird immer ein leerer user hinzugefügt oder nur einam
    //_cache.write(key: userCacheKey, value: user);
    //userController.add(user);
    return userStream;
  }



  //am not really sure abt this stream thing.
  //can mongodb notify... but nah to bothersome. it should be requested then delivered... right?
  /*Stream<Profile> get profile async* {
    //await getProfile(); //Muss das gemacht werden?
    //yield AuthenticationStatus.unauthenticated;
    yield* profileController.stream;
  }
  int helperForNow = -1;
  Profile get profile async* {
    if(helperForNow == -1){

    }
  }*/

  //am not really sure abt this stream thing.
  //can mongodb notify... but nah to bothersome. it should be requested then delivered... right?
  Stream<Commons> get commons async* {
    //await getProfile(); //Muss das gemacht werden?
    //yield AuthenticationStatus.unauthenticated;
    yield* commonsController.stream;
  }

  /*
  @override
  void initState(){
    await getUser();
    await getProfile();
  }

  */

  //Returns the user document to the cached token
  Future<User> getUser() async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    print(token.toString());

    var resUser = await http.get(
      //Uri(path: "$SERVER_IP/login"),
        Uri.parse("$SERVER_IP/getUser"),
        headers: {
          "content-type" : "application/json",
          "authorization" : "Bearer $token"
        }
    );
    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);

    var _user = await User.fromJson(jsonDecode(resUser.body)["user"]);

    //print('here $_profile');
    if (_user == null) return User.anonymous;
    _cache.write(key: "user", value: _user);
    currentUser = _user;
    userController.add(_user);
    return _user;

  }

  //returns the profile document to the cached token
  Future<Profile> getProfile() async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var resProfile = await http.get(
      //Uri(path: "$SERVER_IP/login"),
        Uri.parse("$SERVER_IP/getProfile"),
        headers: {
          "content-type" : "application/json",
          "authorization" : "Bearer $token"
        }
    );

    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);

    var _profile = await Profile.fromJson(jsonDecode(resProfile.body)["profile"]);

    //print('here $_profile');
    if (_profile == null) {
      return Future.delayed(
        const Duration(milliseconds: 300),
            () => _profile=Profile.generic, //_user = User(id: const Uuid().v4()),
      );
    }
    _cache.write(key: "profile", value: _profile);
    currentProfile = _profile;
    return _profile;

  }

  ///EDITS
  ///
  ///
  Future<bool> deleteUser({
    required String interestId,
    required int interestIntensity
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "interestId": interestId,
      "interestIntensity": interestIntensity
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteUser'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }

  Future<bool> changeUsername({
    required String newUsername
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "newUsername": newUsername,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/changeUsername'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      //print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }



  /**
   * If Interests does not exists add to profile with default intensity,
   * otherwise change interest intensity by delta
   */
  Future<bool> addOrModifyProfile({
    required String interestId, //add interest to profile if not in it yet
    required int intensityDelta //or change the value by delta
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    int defaultIntensity = 50;

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "interestId": interestId,
      "interestIntensity": defaultIntensity,
      "intensityDelta": intensityDelta
    };


    //
    print("Send API Request to add interest with id $interestId");

    var res = await http.post(
      Uri.parse('$SERVER_IP/addInterestToProfile'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }



/*
  i believe this was the old modify method for interest intensity
 */
  Future<bool> changeInterestIntensity({
    required String interestId,
    required int interestIntensity
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "interestId": interestId,
      "interestIntensity": interestIntensity
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/changeInterestIntensity'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }


  /**
   * deletes interest from profile
   */
  Future<bool> deleteInterest({
    required String interestId
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "interestId": interestId,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteInterestFromProfile'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }


  /*
    Adds Fact (KeyValue Pair) to profile
   */
  Future<bool> addFactToProfile({
    required KeyValue keyValue
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      //"factId": keyValue.id,
      "factKey": keyValue.key,
      "factValue": keyValue.value
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/addFactToProfile'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }


  /*
  Future<bool> changeFact({
    required KeyValue keyValue
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "factId": keyValue.id,
      "factKey": keyValue.key,
      "factValue": keyValue.value
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/changeFact'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }*/

  Future<bool> deleteFact({
    required String factId
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "factId": factId,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/deleteFactFromProfile'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }

  /*
    Upserts Fact (KeyValue Pair) to profile
   */
  Future<bool> upsertFactOfProfile({
    required KeyValue keyValue
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    /*
    print(keyValue.id);
    print(keyValue.key);
    print(keyValue.value);*/

    var body = {
      "factId": keyValue.id.toString(),
      "factKey": keyValue.key.toString(),
      "factValue": keyValue.value.toString()
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/upsertFactOfProfile'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true; //return true if successful
    }

    return false;
  }

  ///




  @override
  List<Object> get props => [_cache, currentUser, currentProfile];
}
