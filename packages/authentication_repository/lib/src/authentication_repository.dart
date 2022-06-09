import 'package:cache/cache.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:constants/constants.dart';

const SERVER_IP = NetworkConstants.SERVER_IP;

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient? cache,
    required this.userRepository
  })  : _cache = cache ?? CacheClient();

  final CacheClient _cache;
  final UserRepository userRepository;

  /// Whether or not the current environment is web
  /// Should only be overriden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  //Using this for now instead of _firebaseauth
  final StreamController<User?> controller = StreamController<User?>();
  Stream<User?>? _stream;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User?>? get user {
    _stream = controller.stream;
      //final user = User.empty;
      //_cache.write(key: userCacheKey, value: user);
      controller.add(null);
      return _stream;
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User? get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? null;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      print(email);

      var header = {
        "content-type" : "application/json"
      };
      var body = {
        "email": email,
        "password": password
      };


      var res = await http.post(
          Uri.parse('$SERVER_IP/signup'),
          headers: header,
          body: jsonEncode(body),
      );
      print(res.body);
      print(res.statusCode);

    }catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }


  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse("$SERVER_IP/login");
    var header = {
      "content-type" : "application/json"
    };
    var body = {
      "email": email,
      "password": password
    };

    try {
      print("Before posting the Api request to login");
      var res = await http.post(
          url,
          headers: header,
          body: jsonEncode(body),
      );

      if(res.statusCode == 200){
        var resBody =  json.decode(res.body);
        var jwt = resBody["token"].toString();
        //_cache.storage.write(key: "jwt", value: jwt);


        await _cache.storage.write(key: "jwt", value: jwt);


        ////DAS PASSIERT NICHT HIER!!
       // var userRepo = UserRepository(cache: _cache);

        var _user = await userRepository.getUser();

        /*
        if(user == null) {
          throw Exception("user is null in authentication repository");
        }*/

        controller.add(_user);

      }

    } catch(e){
      print(e);
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      controller.add(null);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  ///


  Future<bool> deleteUser({
    required String userId
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "userId": userId,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/userId'),
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

  Future<bool> changePassword({
    required String changedPw
  }) async {
    var token = await _cache.storage.read(key: 'jwt');

    var header = {
      "content-type" : "application/json",
      "authorization" : "Bearer $token"
    };
    var body = {
      "changedPw": changedPw,
    };

    var res = await http.post(
      Uri.parse('$SERVER_IP/changePw'),
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


  CacheClient get cache => _cache;
}
