import 'package:firebase_auth/firebase_auth.dart';
import 'package:timerforeyes/theme.dart';

import 'global_variable.dart';

Future<FirebaseUser> getCurrentUser() async {
  var user = await firebase.currentUser();
  return user;
}

Future<bool> isEmailVerified() async {
  var user = await firebase.currentUser();
  return user.isEmailVerified;
}

Future<void> sendEmailVerification() async {
  var user = await firebase.currentUser();
  await user.sendEmailVerification();
}

Future<String> signIn(String email, String password) async {
  var result = await firebase.signInWithEmailAndPassword(
      email: email, password: password);
  var user = result.user;
  Firebase_User = user;
  return user.uid;
}

Future<void> signOut() async {
  isAuth = false;
  iconAuth = iconAuthFalse; //в дальнейшем будет реализация на mobx
  return firebase.signOut();
}

Future<String> signUp(String email, String password) async {
  var result = await firebase.createUserWithEmailAndPassword(
      email: email, password: password);
  var user = result.user;
  Firebase_User = user;
  return user.uid;
}

Future<bool> updateProfile(String _name) async {
  var info = UserUpdateInfo();
  info.displayName = _name;
  var success;
  await Firebase_User.updateProfile(info).then((value) async {
    await Firebase_User.reload();
    Firebase_User = await getCurrentUser();
    success = true;
  }).catchError((e) {
    print(e);
    success = false;
  });
  return success;
}
