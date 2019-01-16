/**
 * Writen By Rosius Ndimofor
 * CORI
 * Phat Rabbit Apps
 * 
 */
import 'dart:async';

import 'package:cori/components/input_field.dart';
import 'package:cori/locale/locale.dart';

import 'package:cori/theme/style.dart';
import 'package:cori/utils/authentication.dart';
import 'package:cori/utils/config.dart';
import 'package:cori/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserData newUser = new UserData();

  String email;
  String name;
  String userKey;
  bool _loading = false;
  UserAuth userAuth = new UserAuth();
  bool _autovalidate = false;

  Validations _validations = new Validations();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String _value = null;

  List<String> values = new List<String>();

  @override
  void initState() {
    super.initState();
  }

  backToLogin(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Montserrat-Regular', fontSize: 20.0),
      ),
      backgroundColor: Colors.redAccent,
    ));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar(AppLocalizations.of(context).errorOccured);
    } else {
      form.save();
      print(newUser.email);
      _saveEmail(newUser.email);

      setState(() {
        _loading = true;
      });

      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      firebaseAuth
          .createUserWithEmailAndPassword(
              email: newUser.email, password: newUser.password)
          .then((onValue) {
        Future<FirebaseUser> user = firebaseAuth.currentUser();
        user.then((FirebaseUser firebaseUser) {
          userKey = firebaseUser.uid;

          print(userKey);

          Config.firebaseConfig().then((FirebaseApp firebaseApp) {
            final Firestore firestore = new Firestore(app: firebaseApp);

            //save uid
            _saveUid(firebaseUser.uid);

            var reference = firestore.collection(Config.CORI_USERS);
            reference.document(firebaseUser.uid).setData({
              Config.CORI_USER_ID: firebaseUser.uid,
              Config.CORI_EMAIL: newUser.email,
              Config.CORI_ADMIN: true,
              "created_on": new DateTime.now().toString(),
            }).then((_) {
              setState(() {
                _loading = false;
              });
              print("User Successfully registered");

              showInSnackBar("Successful");
/*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              */
            });
          });
        });

        // showInSnackBar(onValue);
      }).catchError((onError) {
        // showInSnackBar(AppLocalizations.of(context).emailExist);
        showInSnackBar(onError.toString());
        print(onError.toString());
        setState(() {
          _loading = false;
        });
      });
    }
  }

  _saveEmail(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.CORI_EMAIL, _email);
  }

  _saveUid(String _uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.CORI_USER_ID, _uid);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;

    //print(context.widget.toString());
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).createAccount,
            style: TextStyle(fontFamily: 'Montserrat-Regular'),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: SingleChildScrollView(
              child: new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(top: 150.0)),
                new Container(
                  width: screenSize.width / 1.3,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Form(
                          key: _formKey,
                          autovalidate: _autovalidate,
                          //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                              InputField(
                                  hintText: AppLocalizations.of(context).email,
                                  obscureText: false,
                                  textInputType: TextInputType.emailAddress,
                                  textStyle: loginFormTextStyle,
                                  //  textFieldColor: textFieldColor,
                                  icon: Icons.mail_outline,
                                  iconColor: Theme.of(context).primaryColor,
                                  bottomMargin: 20.0,
                                  validateFunction: _validations.validateEmail,
                                  onSaved: (String email) {
                                    newUser.email = email;
                                  }),
                              InputField(
                                  hintText:
                                      AppLocalizations.of(context).password,
                                  obscureText: true,
                                  textInputType: TextInputType.text,
                                  textStyle: loginFormTextStyle,
                                  // textFieldColor: textFieldColor,
                                  icon: Icons.lock_open,
                                  iconColor: Theme.of(context).primaryColor,
                                  bottomMargin: 40.0,
                                  validateFunction:
                                      _validations.validatePassword,
                                  onSaved: (String password) {
                                    newUser.password = password;
                                  }),
                              new Padding(
                                  padding: const EdgeInsets.only(top: 20.0)),
                              _loading == true
                                  ? new CircularProgressIndicator()
                                  : new Container(
                                      width: screenSize.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 10.0),
                                      child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        onPressed: () {
                                          _handleSubmitted();
                                        },
                                        color: Colors.redAccent,
                                        child: new Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: new Text(
                                              AppLocalizations.of(context)
                                                  .createAccount,
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      'Montserrat-Regular',
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                    ),
                              FlatButton(
                                child:
                                    Text(AppLocalizations.of(context).already),
                              ),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(AppLocalizations.of(context).login,
                                    style: new TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 15.0,
                                      fontFamily: 'Montserrat-Regular',
                                    )),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
