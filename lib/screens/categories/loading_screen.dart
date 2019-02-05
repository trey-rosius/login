import 'package:cori/locale/locale.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        AppLocalizations.of(context).loading,
        style: new TextStyle(
          fontSize: 20.0,
          fontFamily: "Montserrat-Regular",
        ),
      ),
    ));
  }
}
