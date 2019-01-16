import 'package:cori/locale/locale.dart';

import 'package:cori/utils/authentication.dart';
import 'package:cori/utils/config.dart';
import 'package:cori/utils/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormScreen extends StatefulWidget {
  LoginFormScreen(
      {Key key,
      this.width,
      this.height,
      this.isLargeScreen,
      this.isLargerScreen,
      this.formKey,
      this.emailController,
      this.passwordController,
      this.scaffoldKey})
      : super(key: key);

  final double width;
  final double height;
  final bool isLargeScreen;
  final bool isLargerScreen;

  final GlobalKey<FormState> formKey;

  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserData user = new UserData();
  UserAuth userAuth = new UserAuth();

  Validations validations = new Validations();
  bool autovalidate = false;
  bool loading = false;
  void showInSnackBar(String value) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Montserrat-Regular', fontSize: 20.0),
      ),
      backgroundColor: Colors.redAccent,
    ));
  }

  _saveEmail(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.CORI_EMAIL, _email);
  }

  void initState() {
    super.initState();
  }

  _saveUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saved userId to preferences");
    prefs.setString(Config.CORI_USER_ID, uid);
  }

  void _handleFormSubmission() {
    final FormState form = widget.formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar(AppLocalizations.of(context).fixErrors);
    } else {
      form.save();
      setState(() {
        loading = true;
      });

      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      firebaseAuth
          .signInWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((onValue) {
        Future<FirebaseUser> user = firebaseAuth.currentUser();
        user.then((FirebaseUser user) async {
          if (user != null) {
            print(user.email);
            print(user.displayName);
            print(user.uid);
            _saveUserId(user.uid);
            setState(() {
              loading = false;
            });

            showInSnackBar("Successful");
            /*
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => UserInformation(user.uid),
                ));
                */

            /*
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => GeneralProvider(
                        itemBloc: GeneralBloc(Api()),
                        child: HomeScreen(),
                      ),
                ));
                */
          } else {
            showInSnackBar(AppLocalizations.of(context).somethingWrong);
            setState(() {
              loading = false;
            });
          }
        });
      }).catchError((e) {
        // showInSnackBar(AppLocalizations.of(context).acountNonExist);
        showInSnackBar(e.toString());
        print(e);
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width - 40,
        padding: widget.isLargeScreen
            ? EdgeInsets.only(top: widget.height / 7)
            : widget.isLargerScreen
                ? EdgeInsets.only(top: widget.height / 4.5)
                : EdgeInsets.only(top: widget.height / 20),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                key: widget.formKey,
                autovalidate: autovalidate,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(
                        validator: (value) {
                          validations.validateEmail(value);
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).enterEmail;
                          } else {
                            final RegExp nameExp =
                                new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
                            if (!nameExp.hasMatch(value))
                              return AppLocalizations.of(context).invalidEmail;
                          }
                        },
                        onSaved: ((String value) {
                          user.email = value.trim();
                        }),
                        controller: widget.emailController,
                        decoration: new InputDecoration(
                            labelText: AppLocalizations.of(context).email,
                            contentPadding: new EdgeInsets.all(12.0),
                            filled: true,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).enterPassword;
                          }
                        },
                        onSaved: ((String value) {
                          user.password = value.trim();
                        }),
                        controller: widget.passwordController,
                        obscureText: true,
                        decoration: new InputDecoration(
                            labelText: AppLocalizations.of(context).password,
                            contentPadding: new EdgeInsets.all(12.0),
                            filled: true,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    loading == true
                        ? new CircularProgressIndicator()
                        : new Container(
                            width: widget.width / 1.3,
                            height: 50.0,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              onPressed: () {
                                _handleFormSubmission();
                                /*
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => GeneralProvider(
                                            itemBloc: GeneralBloc(Api()),
                                            child: HomeNonAdmin(),
                                          ),
                                    ));
                                    */
                              },
                              color: Colors.redAccent,
                              child: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                    AppLocalizations.of(context).signIn,
                                    style: new TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )),
                              ),
                            ),
                          ),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            showInSnackBar(
                                AppLocalizations.of(context).forgotPassword);
                          },
                          child: Text(
                            AppLocalizations.of(context).forgotPassword,
                            style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                            ),
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      onPressed: () {
                        // showInSnackBar("Create New Account");
                        Navigator.of(context).pushNamed('/SignUp');
                        /*
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => CreateCategory(),
                            ));
                            */
                      },
                      child: Text(
                        AppLocalizations.of(context).createAccount,
                        style: TextStyle(
                            fontFamily: "Montserrat-Regular",
                            fontSize: 18.0,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ]));
  }
}
