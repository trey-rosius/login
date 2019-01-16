/**
 *  Created By Ndimofor Ateh Rosius
 * CORI
 * Phat Rabbit Apps
 * 
 */
import 'package:cori/Auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth}) : super(key: key);
  final BaseAuth auth;
  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = await widget.auth.signIn(_email, _password);
        setState(() {
          _authHint = 'Success\n\nUser id: ${userId}';
        });
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Form(
                key: formKey,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    new TextFormField(
                      key: new Key('email'),
                      decoration: new InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val.isEmpty ? 'Email can\'t be empty.' : null,
                      onSaved: (val) => _email = val,
                    ),
                    new TextFormField(
                      key: new Key('password'),
                      decoration: new InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) =>
                          val.isEmpty ? 'Password can\'t be empty.' : null,
                      onSaved: (val) => _password = val,
                    ),
                    new RaisedButton(
                        key: new Key('login'),
                        child: new Text('Login',
                            style: new TextStyle(fontSize: 20.0)),
                        onPressed: validateAndSubmit),
                    new Container(
                        height: 80.0,
                        padding: const EdgeInsets.all(32.0),
                        child: buildHintText())
                  ],
                ))));
  }

  Widget buildHintText() {
    return new Text(_authHint,
        key: new Key('hint'),
        style: new TextStyle(fontSize: 18.0, color: Colors.grey),
        textAlign: TextAlign.center);
  }
}
