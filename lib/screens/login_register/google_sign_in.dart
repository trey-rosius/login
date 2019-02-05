import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cori/locale/locale.dart';
import 'package:cori/screens/product/create_product.dart';
import 'package:cori/screens/profile/user_information.dart';

import 'package:cori/utils/authentication.dart';
import 'package:cori/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  GoogleSignInButton(
      {Key key, this.scaffoldKey, this.isLargeScreen, this.width, this.height})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isLargeScreen;
  final double width;
  final double height;

  @override
  GoogleSignInButtonState createState() {
    return new GoogleSignInButtonState();
  }
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool loading = false;

  _saveEmail(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.CORI_EMAIL, _email);
  }

  void initState() {
    super.initState();
  }

  _saveUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.CORI_USER_ID, uid);
  }

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

  Future<Null> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      FirebaseUser user = await signInWithGoogle();
      if (user != null) {
        print(user.email);
        print(user.uid);
        print(user.displayName);

        Config.firebaseConfig().then((FirebaseApp firebaseApp) {
          final Firestore firestore = new Firestore(app: firebaseApp);

          var reference = firestore.collection(Config.CORI_USERS);

          var map = new Map<String, dynamic>();
          map[Config.CORI_USER_ID] = user.uid;
          map[Config.CORI_EMAIL] = user.email;
          map['createdOn'] = new DateTime.now().toString();
          reference.document(user.uid).setData(map, merge: true).then((_) {
            _saveUserId(user.uid);
            setState(() {
              loading = false;
            });
            print("User Successfully registered");

            //  showInSnackBar("Successful");

            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => UserInformation(user.uid),
                ));
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
                  builder: (context) => CreateStore(
                        user.uid,
                      ),
                ));
                */
          });

          // compressImage();
        });

        _saveEmail(user.email);
      } else {
        setState(() {
          loading = false;
        });
        showInSnackBar(AppLocalizations.of(context).errorOccured);
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.width / 4,
      child: RaisedButton(
          onPressed: () => _handleGoogleSignIn(context),
          color: Colors.redAccent,
          child: loading == false
              ? Text(
                  AppLocalizations.of(context).gLogin,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat-Regular",
                      fontSize:
                          Localizations.localeOf(context).languageCode == 'fr'
                              ? 18.0
                              : 22.0),
                )
              : SpinKitWave(
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    );
                  },
                )),
    );
  }
}
