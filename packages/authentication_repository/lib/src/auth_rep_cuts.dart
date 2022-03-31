/*
import 'package:cache/cache.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'constants.dart' as Constants;
import 'package:authentication_repository/authentication_repository.dart';
//import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
//import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
//import 'package:google_sign_in/google_sign_in.dart';

const SERVER_IP = 'http://192.168.178.35:5000';



/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    //firebase_auth.FirebaseAuth? firebaseAuth,
    //GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient();
        //_firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        //_googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  //final firebase_auth.FirebaseAuth _firebaseAuth;
  //final GoogleSignIn _googleSignIn;

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
  final StreamController<User> controller = StreamController<User>();
  Stream<User>? _stream;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User>? get user {
    /*return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });*/

    _stream = controller.stream;
      final user = User.empty;
      _cache.write(key: userCacheKey, value: user);
      controller.add(user);
      return _stream;
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
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
      /*await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );*/
    }/* on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }*/ catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /*
  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    }/* on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    }*/ catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }*/



  //Ref: https://dev.to/carminezacc/user-authentication-jwt-authorization-with-flutter-and-node-176l
/*
 json.decode(
        utf8.decode(
          base64.decode(base64.normalize(jwt.split(".")[1]))
        )
      )
 */

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
      /*
      print("Before the test method .");
      var test = await http.get(
       //Uri(path:'http://localhost:5000/interests'),
        Uri.parse('"$SERVER_IP/interests'),
      );
      print(test.body);
      //Diese Stelle (Test) funktionierte bevor ich den unteren Teil entkommentiert habe.
      */
      print("Before posting the Api request to login");
      var res = await http.post(
          //Uri(path: "$SERVER_IP/login"),
          url,
          headers: header,
          body: jsonEncode(body),
      );

      if(res.statusCode == 200){
        var resBody =  json.decode(res.body);
        var jwt = resBody["token"].toString();
        _cache.storage.write(key: "jwt", value: jwt);

        /*
        var resProfile = await http.get(
          //Uri(path: "$SERVER_IP/login"),
          Uri.parse("$SERVER_IP/getProfile"),
          headers: {
            "content-type" : "application/json",
            "authorization" : "Bearer $jwt"
          }
        );*/
        //print(resProfile.body);


        await _cache.storage.write(key: "jwt", value: jwt);


        ////DAS PASSIERT NICHT HIER!!
        var userRepo = UserRepository(cache: _cache);

        var _user = await userRepo.getUser();
        //print(_user);
        //var _profile = await userRepo.getProfile();

        //print(_profile);

        if(user == null) {
          throw Exception("user is null in authentication repository");
        }

        controller.add(_user);

      }

      /*await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );*/

    }
      /*on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } */
    /*catch (_) {
      print('an error occured while trying to log in.');
      throw const LogInWithEmailAndPasswordFailure();
    }*/catch(e){
      print(e);
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      controller.add(User.empty);
      /*
      await Future.wait([

        /*_firebaseAuth.signOut(),
        _googleSignIn.signOut(),*/
      ]);*/
      //_cache = new CacheClient();
    } catch (_) {
      throw LogOutFailure();
    }
  }


  CacheClient get cache => _cache;
}

/*
extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}*/
 */