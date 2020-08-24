import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerforeyes/auth_firebase.dart';


import 'theme.dart';

class resetPasswordPage extends StatefulWidget {
  @override
  _resetPasswordPageState createState() => _resetPasswordPageState();
}

class _resetPasswordPageState extends State<resetPasswordPage> {
  final _formKey = GlobalKey<FormState>();


  bool _isLoading;
  String _email;
  String _errorMessage;

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

  Widget showInstructions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 4),
      child: Text(
        'Enter your email. We\'ll email instructions on how to reset your password.',
          style: TextStyle(fontSize: 16.0, color: colorText, fontWeight: FontWeight.w300)
      )
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 50),
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
            child: Text('Send',
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
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

      try {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
        await sendPasswordResetEmail(_email);
        Navigator.pop(context);

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
              showInstructions(),
              showEmailInput(),
              showPrimaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }
}
