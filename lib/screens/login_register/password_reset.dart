import 'package:cori/locale/locale.dart';
import 'package:cori/utils/authentication.dart';
import 'package:cori/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PasswordReset extends StatefulWidget {
  @override
  PasswordResetState createState() {
    return new PasswordResetState();
  }
}

class PasswordResetState extends State<PasswordReset> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final emailController = TextEditingController();

  Validations validations = new Validations();
  UserAuth userAuth = new UserAuth();

  bool autovalidate = false;

  bool loading = false;

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

  void reset() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar(AppLocalizations.of(context).fixErrors);
    } else {
      form.save();
      setState(() {
        loading = true;
      });

      userAuth.resetUserPassword(emailController.text).then((value) {
        if (value) {
          setState(() {
            loading = false;
          });
          showInSnackBar(
              "A Reset Link Has been forwarded to your Email Address");
        }
      }).catchError((onError) {
        showInSnackBar(onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Forgot Password ?",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: 'Montserrat-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Form(
                key: formKey,
                autovalidate: autovalidate,
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 20.0),
                        child: new TextFormField(
                          validator: (value) {
                            validations.validateEmail(value);
                            if (value.isEmpty) {
                              return AppLocalizations.of(context).enterEmail;
                            } else {
                              final RegExp nameExp = new RegExp(
                                  r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
                              if (!nameExp.hasMatch(value))
                                return AppLocalizations.of(context)
                                    .invalidEmail;
                            }
                          },
                          /*
                        onSaved: ((String value) {
                          user.email = value.trim();
                        }),
                        */
                          controller: emailController,
                          decoration: new InputDecoration(
                              labelText: "Enter Email to Reset Password",
                              contentPadding: new EdgeInsets.all(12.0),
                              filled: true,
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    width: 2.0, color: Colors.white),
                              )),
                        ),
                      ),
                    ]))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: width,
        height: height / 8,
        color: Colors.redAccent,
        child: loading == true
            ? SpinKitWave(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  );
                },
              )
            : MaterialButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    reset();
                  }
                },
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text("Reset Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600)),
                ),
              ),
      ),
    );
  }
}
