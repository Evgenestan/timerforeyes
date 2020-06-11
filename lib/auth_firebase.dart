import 'package:firebase_auth/firebase_auth.dart';
import 'package:timerforeyes/theme.dart';
import 'global_variable.dart';

  Future<String> signIn(String email, String password) async {
    var result = await firebase.signInWithEmailAndPassword(
        email: email, password: password);
    var user = result.user;
    return user.uid;
  }


  Future<String> signUp(String email, String password) async {
    var result = await firebase.createUserWithEmailAndPassword(
        email: email, password: password);
    var user = result.user;
    return user.uid;
  }


  Future<FirebaseUser> getCurrentUser() async {
    var user = await firebase.currentUser();
    return user;
  }


  Future<void> signOut() async {
    isAuth = false;
    iconAuth = iconAuthFalse; //в дальнейшем будет реализация на mobx
    return firebase.signOut();
  }


  Future<void> sendEmailVerification() async {
    var user = await firebase.currentUser();
    await user.sendEmailVerification();
  }


  Future<bool> isEmailVerified() async {
    var user = await firebase.currentUser();
    return user.isEmailVerified;
  }
