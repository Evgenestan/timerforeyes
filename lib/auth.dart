import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerforeyes/auth_firebase.dart';
import 'package:timerforeyes/global_variable.dart';
import 'package:timerforeyes/main.dart';

import 'theme.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool _isLoading;
  String _email;
  String _password;
  String _confirmPassword;
  String _name;
  String _errorMessage;
  bool _isLoginForm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          _showForm(),
          showCircularProgress(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = '';
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }



  Widget showNameInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 4),
        child: Visibility(
          visible: !_isLoginForm,
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Name',
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
            validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
            onSaved: (value) => _name = value.trim(),
          ),
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.isNotEmpty && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: TextFormField(
        controller: _pass,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showConfirmPasswordInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 50),
        child: Visibility(
          visible: !_isLoginForm,
          child: TextFormField(
            controller: _confirmPass,
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Confirm password',
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                )),
            validator: (value) {
              if (value.isEmpty) {
                return 'Confirm password can\'t be empty';
              }
              if (value != _pass.text) {
                return 'Password not match';
              }
              return null;
            },
            onSaved: (value) => _password = value.trim(),
          ),
        ));
  }

  Widget showPrimaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(_isLoginForm ? 'Login' : 'Create account',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return FlatButton(
        child: Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void toHomePage() async {
    isAuth = true;
    iconAuth = iconAuthTrue;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (validateAndSave()) {
      var userId = '';
      try {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (_isLoginForm) {
          userId = await signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await signUp(_email, _password);
          print('Signed up user: $userId');
          if (!await updateProfile(_name)) {
            print('Error, try again');
            await updateProfile(_name);
          }
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.isNotEmpty && userId != null) {
          toHomePage();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showConfirmPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }
}
