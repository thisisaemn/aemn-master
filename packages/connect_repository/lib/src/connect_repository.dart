import 'dart:async';

import 'package:connect_repository/connect_repository.dart';
import 'package:cache/cache.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:constants/constants.dart';

//SERVER Adress
//const SERVER_IP = 'http://localhost:5000';
const SERVER_IP = NetworkConstants.SERVER_IP;

enum ConnectionStatus { none, active, requested, received}

class ConnectRepository {
  final _controller = StreamController<ConnectionStatus>();

  ConnectRepository({CacheClient? cache}) : _cache = cache ?? CacheClient();

  final CacheClient _cache;

  Stream<ConnectionStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield ConnectionStatus.none;
    yield* _controller.stream;
  }

  /*
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(ConnectionStatus.requested),
    );
  }



  void logOut() {
    _controller.add(ConnectionStatus.none);
  }

  void dispose() => _controller.close();
*/

  Session get session {
    return Session.generic;
  }


  Session get currentSession {
    return Session.generic;
    ///return _cache.read<User>(key: userCacheKey) ?? User.anonymous;
  }

  Future<List<Member>> searchMembers({
    required String key
  }) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "key": key
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/searchMembers'),
      headers: header,
      body: jsonEncode(body),
    );


    List<Member> memberArray = [];

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      var jsonProfileArray = resBody["searchResult"];
      memberArray = (jsonProfileArray as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList();
      print(memberArray);
    }

    return memberArray;
  }


  //Send Message
  Future<bool> sendMessage({
    required Message msg
  }) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "msg": msg
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/sendMsg'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      return true;
    }

    return false;
  }

  Future<bool> inviteToNewSession({
    required String inviteeId,
    required String inviteeUsername,
    required String senderId,
    required String senderUsername
  }) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "receiverId": inviteeId,
      "receiverUsername":inviteeUsername,
      "senderId":senderId,
      "senderUsername":senderUsername

    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/inviteToNewSession'),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      print(resBody["msg"]);
      print(resBody["sessionId"]);
      return true;
    }

    return false;
  }



  //This method doesn't make sense if the user can be in more than one session
  /*
  Future<Session> getSession() async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());


    await getUser();
    var sessionId = "";
    if(currentUser.currentSession != ""){ //Check whteher valid id
      sessionId = currentUser.currentSession;
    }
    print("trying to get session with id $sessionId");

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "sessionId": sessionId,
    };

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
        Uri.parse("$SERVER_IP/getSession"),
        headers: header,
      body: jsonEncode(body)
    );

    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);

    if(res.statusCode == 200) {
      var _session = await Session.fromJson(jsonDecode(res.body)["session"]);

      //print('here $_profile');
      if (_session == null) {
        return Future.delayed(
          const Duration(milliseconds: 300),
              () =>
          _session = Session.generic, //_user = User(id: const Uuid().v4()),
        );
      }
      _cache.write(key: "session", value: _session);
      currentSession = _session;
      return _session;
    }
    return Session.generic;

  }*/


  //Returns the session the user is in
  Future<Session> getSessions() async {  //did the not have a stream or smth similar as a return type?
    /*var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());


    await getUser();
    var sessionId = "";
    if(currentUser.currentSession != ""){ //Check whteher valid id
      sessionId = currentUser.currentSession;
    }
    print("trying to get session with id $sessionId");

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "sessionId": sessionId,
    };

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
        Uri.parse("$SERVER_IP/getSession"),
        headers: header,
        body: jsonEncode(body)
    );

    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);

    if(res.statusCode == 200) {
      var _session = await Session.fromJson(jsonDecode(res.body)["session"]);

      //print('here $_profile');
      if (_session == null) {
        print("the returned session is null");
        return Future.delayed(
          const Duration(milliseconds: 300),
              () =>

          _session = Session.generic, //_user = User(id: const Uuid().v4()),
        );
      }
      _cache.write(key: "session", value: _session);
      currentSession = _session;
      return _session;
    }*/
    return Session.generic;

  }

  Future<bool> joinSession({required String sessionId, required String username}) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
      "sessionId": sessionId,
    };

    var body = {
      "sessionId": sessionId,
      "username": username,
    };

    print("trying to join session with id $sessionId");

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
      Uri.parse("$SERVER_IP/joinSession"),
      headers: header,
      body: jsonEncode(body),
    );

    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);
    /*
    var _session = await Session.fromJson(jsonDecode(res.body)["session"]);

    //print('here $_profile');
    if (_session == null) {
      return false;
    }
    _cache.write(key: "session", value: _session);
    currentSession = _session;*/
    //print(res.body.msg);
    if(res.statusCode == 200) {
      //await getSession();
      return true;
    }
    return false;

  }

  Future<bool> evaluateCommons({required String sessionId}) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
      "sessionId": sessionId,
    };

    var body = {
      "sessionId": sessionId,
    };

    print("trying to eval session with id $sessionId");

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
      Uri.parse("$SERVER_IP/evaluateCommons"),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200) {
      //await getSession();
      return true;
    }
    return false;

  }

  Future<Commons> getCommons() async {  //did the not have a stream or smth similar as a return type?
    /*var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    User user = await getUser();
    var commonsId = "";
    if(user.currentSession != "" && currentSession.commonsId != ""){ //Check whteher valid id
      commonsId = currentSession.commonsId;
    }

    print("tryna get commons with id " + commonsId);

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
      "commonsId": commonsId,
    };

    var body = {
      "commonsId": commonsId,
      "username": currentUser.username,
    };

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
        Uri.parse("$SERVER_IP/getCommons"),
      headers: header,
      body: jsonEncode(body),
    );

    //print(resProfile.body);
    //print(jsonDecode(resProfile.body)["profile"]);

    if(res.statusCode == 200) {
      var _commons = await Commons.fromJson(jsonDecode(res.body)["commons"]);

      //print('here $_profile');
      if (_commons == null) {
        return Future.delayed(
          const Duration(milliseconds: 300),
              () =>
          _commons = Commons.generic, //_user = User(id: const Uuid().v4()),
        );
      }

      currentSession = await getSession();
      currentCommons = _commons;

      _cache.write(key: "commons", value: currentCommons);
      return _commons;
    }*/
    return Commons.generic;

  }



  Future<bool> quitSession({required String sessionId}) async {  //did the not have a stream or smth similar as a return type?
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
      "sessionId": sessionId,
    };

    var body = {
      "sessionId": sessionId,
    };

    print("trying to eval session with id $sessionId");

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
      Uri.parse("$SERVER_IP/quitSession"),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200) {
      //await getSession();
      return true;
    }
    return false;

  }


  Future<Trigger?> getTrigger({required Session session}) async {  //did the not have a stream or smth similar as a return type?
    /*
    var token = await _cache.storage.read(key: 'jwt');
    //print(token.toString());

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
      "sessionId": sessionId,
    };

    var body = {
      "sessionId": sessionId,
    };

    print("trying to eval session with id $sessionId");

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
      Uri.parse("$SERVER_IP/quitSession"),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200) {
      //await getSession();
      return true;
    }
    return false;
     */

    return Trigger(id: "id" , mainContent: "How's the weather?", mainContentLink: '',facts: [KeyValue(id: "00000000",key: "species", value: "human"),], interests: [Interest(interestModel: InterestModel(id: "00000000", partition: "=00000000", icon: "2342", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")]), intensity: 1000)]);

  }

}