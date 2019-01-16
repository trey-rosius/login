/**
 * Written By Rosius Ndimofor
 * CORI
 * Phat Rabbit Apps
 * 
 */
/**
 *  the methods used in this class and other classes are self explanatory.
 */

import 'package:cori/screens/login_register/facebook_sign_in.dart';
import 'package:cori/screens/login_register/google_sign_in.dart';
import 'package:cori/screens/login_register/login_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  bool isLargeScreen = false;
  bool isLargerScreen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (height >= 800 && height <= 850) {
      isLargeScreen = true;
    } else if (height >= 850 && height <= 900) {
      isLargerScreen = true;
    } else {
      isLargeScreen = false;
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 150.0,
                padding: EdgeInsets.only(top: 20.0),
                child: Image.asset('assets/images/logo.png'),
              ),
              //login form and sign in button
              LoginFormScreen(
                width: width,
                height: height,
                isLargeScreen: isLargeScreen,
                isLargerScreen: isLargerScreen,
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                scaffoldKey: _scaffoldKey,
              ),
              Container(
                padding: isLargeScreen
                    ? EdgeInsets.only(top: 20.0)
                    : EdgeInsets.only(top: 20.0),
                child: new Column(
                  children: <Widget>[
                    //google sign in button
                    GoogleSignInButton(
                      scaffoldKey: _scaffoldKey,
                      isLargeScreen: isLargeScreen,
                      width: width,
                      height: height,
                    ),
                    //facebook Sign In Button
                    FacebookLogin(
                      width: width,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
