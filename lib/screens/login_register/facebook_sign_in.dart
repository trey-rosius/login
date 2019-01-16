import 'package:cori/locale/locale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacebookLogin extends StatefulWidget {
  FacebookLogin({Key key, this.width});
  final double width;
  @override
  _FacebookLoginState createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.width / 4,
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed('/Home'),
        color: Colors.blueAccent,
        child: Text(
          AppLocalizations.of(context).fLogin,
          style: TextStyle(
              fontSize: Localizations.localeOf(context).languageCode == 'fr'
                  ? 18.0
                  : 22.0,
              fontFamily: "Montserrat-Regular",
              color: Colors.white),
        ),
      ),
    );
  }
}
