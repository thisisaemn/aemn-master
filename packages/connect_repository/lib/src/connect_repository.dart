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
  StreamController<Trigger?> triggerStreamController = StreamController<Trigger?>();

  Stream<Trigger?> get triggerStream async* {
    Trigger? t = await getTrigger(session: session);
    yield
    yield* triggerStreamController.stream;
  }*/


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

  /*Session get session {
    return Session.generic;
  }


  Session get currentSession {
    return Session.generic;
    ///return _cache.read<User>(key: userCacheKey) ?? User.anonymous;
  }*/

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
      //print(memberArray);
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
      //print(resBody["msg"]);
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
      //print(resBody["msg"]);
      //print(resBody["sessionId"]);
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


  /**
   * Returns session if user is member
   */
  Future<Session?> getSession({required String sessionId}) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };

    var body = {
      "sessionId": sessionId,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/getSession'),
      headers: header,
      body: jsonEncode(body),
    );

    //Response Dealing
    if(res.statusCode == 200){
      var resBody = await json.decode(res.body);
      //print(resBody["session"]);
      Session session = await Session.fromJson(resBody["session"]);
      return session;
    }

    return null;
  }


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
    return Session(id: "00000000", partition: "=00000000", name: "", members: [Member(id: "00000000", username: "aemn", active: false)], commons: Commons.generic, triggers: []);

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

    //print("trying to join session with id $sessionId");

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

    //print("trying to eval session with id $sessionId");

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

    //print("trying to eval session with id $sessionId");

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

  /**
   * Returns one Trigger based on the session.
   * Would it make sense to get more than one trigger?
   * Should history of triggers and the voting of them in the context play
   * a role?
   */
  Future<Trigger?> getTrigger({required Session session}) async {  //did the not have a stream or smth similar as a return type?
    //print(session.commons);
    //print('now the triggerbase:');
    //print(await getTriggerBaseInterests(commons: session.commons));

    List<InterestModel>? interestModels = await getTriggerBaseInterests(commons: session.commons);

    if(interestModels == null){
      //maybe completely random trigger request.
      return null;
    }

    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token",
    };

    var body = {
      "interestsModels": interestModels,
      "facts": session.commons.facts
    };

    var res = await http.post(
      //Uri(path: "$SERVER_IP/login"),
      Uri.parse("$SERVER_IP/getTrigger"),
      headers: header,
      body: jsonEncode(body),
    );

    if(res.statusCode == 200) {
      var resBody = await json.decode(res.body);
      //print(resBody);
      Trigger trigger = await Trigger.fromJson(resBody["trigger"]);
      print(trigger.mainContent);
      //trigger.mainContentLink = trigger.mainContent.
      return trigger;
    }

    return Trigger(id: "id" , mainContent: "How's the weather?", mainContentLink: '',facts: [KeyValue(id: "00000000",key: "species", value: "human"),], interests: [InterestModel(id: "00000000", partition: "=00000000", icon: "2342", name: "aemn", tags: [Tag(id: "000000000", name: "aemn")])]);

  }

  //Generate random interest combinations.
  /**
   * Returns a Trigger Base: this is used to find related content and recommend a trigger.
   * Does the return type make sense?
   *
   * How should the history of previous trigger bases take into account?
   * Should there be a variable storing the triggerbase and the rating of it?
   * The rating should also influence the intensity of the interests in the commons
   * Argh.
   *
   * The tags should be weighted and the trigger base kinda meaningful.
   * How do we achieve that?
   *
   * Would it make sense for now to keep the trigger base 'homogenous'?
   * Meaning, that only related tags should be put into the base
   * example: Business and Industry, StartUps and Entrepreneurship. -Since the tags suggest a relation between these interests?
   *
   * This would mean we would take each interest from commons, see whether they have tags, check whether the tags are included in commons and if so put them in the trigger base.
   * But would this make sense? this is just sm sorta groupby isn't it.
   *
   * Example: Queen
   *    Queen is related to a musician, music, rockband, songs, bohemian rhapsody, disruption ...
   *    If we would throuw all these into a pot and request a trigger, the most limiting thing would be queen itself or bohemian rhapsody right?
   *    How do we expect to generate content based on that.
   *
   * ....
   *
   * Before I get helpless, we'll start with the suggested offer until I find a better alternative.
   *
   * So to summarize:
   * 1. We're going to group by the interests in commons by tags, this will return all trigger bases
   * 2. We're going to iterate through all these triggerbases and return one;
   *    so we need a variable storing the index of the current triggerBase, also a way to rate it and an opportunity to get back at it if wished
   * 3. If there is the desire to switch into comlete random mode, this could alsobe realized by generating random trigger bases
   *    We'd get random integer values, and use them as indexes to get random combinations, the amount of random tags that should be included can also be determined by a andom int
   *
   */
  Future<List<InterestModel>?> getTriggerBaseInterests({required Commons commons}) async {
    List<List<InterestModel>>? tempAllTriggerBaseTags = await getAllTriggerBaseTags(commons: commons);
    if(tempAllTriggerBaseTags != null){
      currentIndexInAllTriggerBaseTags++;
      allTriggerBaseTags = tempAllTriggerBaseTags;
      //ratingAndIndexOfAllTriggerBaseTags = List.generate(2, (index) => List.filled(allTriggerBaseTags.length, 0, growable: false));
      ratingAndIndexOfAllTriggerBaseTags = List.generate(allTriggerBaseTags!.length, (i) => 0,);
      if(currentIndexInAllTriggerBaseTags>-1 && currentIndexInAllTriggerBaseTags<allTriggerBaseTags!.length){
        return allTriggerBaseTags![currentIndexInAllTriggerBaseTags];
      }else{
        currentIndexInAllTriggerBaseTags=0;
        return allTriggerBaseTags![currentIndexInAllTriggerBaseTags];
      }
    }
    return null;
  }

  List<List<InterestModel>>? allTriggerBaseTags;
  //Only the rating stored, the index eq to the index in the other list
  List<int>? ratingAndIndexOfAllTriggerBaseTags;
  int currentIndexInAllTriggerBaseTags = -1;

  //returns all trigger bases for the interests in commons
  //would this not be rendundant?
  //the hierachy/relationship of tags does not have to be linear
  //is there therefore a way to eliminate the redundancy properly?
  Future<List<List<InterestModel>>?> getAllTriggerBaseTags({required Commons commons}) async{
    List<List<InterestModel>> allTriggerBases = [];
    List<Interest> interests = commons.interests;

    for(int i= 0; i<interests.length; i++){
      if(interests[i].intensity>0){
      List<InterestModel>? res = await getOneTriggerBaseInterest(commons: commons, interest: interests[i]);
      if(res != null /*&& res.length>0 */){
        //print(res);
        allTriggerBases.add(res);
        //print(allTriggerBases);
      }}
    }


    if (allTriggerBases.length < 1) {
      return null;
    }

    return allTriggerBases;
  }

  Future<List<InterestModel>?> getOneTriggerBaseInterest({required Commons commons, required Interest interest}) async{
    List<InterestModel> triggerBase = [];

    interest.interestModel.tags.forEach((tag) {
      commons.interests.forEach((element) {
        if(element.interestModel.id == tag.id){
          triggerBase.add(element.interestModel);
         // break;
        }
      });
    });

    if(triggerBase.length == 0){
      return null;
    }

    return triggerBase;
  }

  //Fact matching and according content.

  //Modify triggers based on facts. Mostly the way they are conveyed.




}