import 'package:flutter/cupertino.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        error,
        style: new TextStyle(
          fontSize: 20.0,
          fontFamily: "Montserrat-Regular",
        ),
      ),
    ));
  }
}
