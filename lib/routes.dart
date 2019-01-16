import 'package:cori/locale/locale.dart';
import 'package:cori/screens/login_register/login_screen.dart';
import 'package:cori/screens/login_register/sign_up_screen.dart';

import "package:flutter/material.dart";
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Routes {
  static String userId;
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => SignUpScreen(),
    // "/UserInformation": (BuildContext context) => UserInformation(userId),
  };

  Routes() {
    runApp(MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Color(0xFFFE5099),
          primaryColor: Colors.redAccent,
          primaryColorDark: Colors.redAccent),
      home: LoginScreen(),
      routes: routes,
    ));
  }
}
