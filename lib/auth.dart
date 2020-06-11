import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerforeyes/auth_firebase.dart';
import 'package:timerforeyes/global_variable.dart';
import 'theme.dart';

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading;
  String _email;
  String _password;
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
        if (_isLoginForm) {
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          userId = await signIn(_email, _password);
          print('Signed in: $userId');
          isAuth = true;
          iconAuth = iconAuthTrue;
          Firebase_User = await getCurrentUser();
          Navigator.pop(context);
        } else {
          userId = await signUp(_email, _password);
          print('Signed up user: $userId');
          Firebase_User = await getCurrentUser();
          isAuth = true;
          iconAuth = iconAuthTrue;
          Navigator.pop(context);
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.isNotEmpty && userId != null && _isLoginForm) {
          //widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }


  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = '';
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }


  Widget _showForm() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
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

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
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

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
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

  Widget showPrimaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
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
        onPressed: toggleFormMode
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


}
