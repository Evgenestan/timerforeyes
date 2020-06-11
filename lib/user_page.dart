import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timerforeyes/auth_firebase.dart';
import 'package:timerforeyes/theme.dart';

import 'global_variable.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Пользователь', style: TextStyle(color: colorText)),
        actions: <Widget>[
          FlatButton(
              child: Text('Logout',
                  style: TextStyle(color: Colors.white)),
              onPressed: logout)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Text('User Email= ${Firebase_User.email}'),
              Text('User Name = ${Firebase_User.displayName}')
            ],
          ),
        ),
      ),
    );
  }

  void logout(){
    signOut();
    Navigator.pop(context);
  }
}
