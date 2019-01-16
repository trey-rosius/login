// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "already" : MessageLookupByLibrary.simpleMessage("Already Have An Account ?"),
    "appName" : MessageLookupByLibrary.simpleMessage("Cori"),
    "createAccount" : MessageLookupByLibrary.simpleMessage("Create New Account"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "enterEmail" : MessageLookupByLibrary.simpleMessage("Please Enter Email"),
    "enterPassword" : MessageLookupByLibrary.simpleMessage("Please Enter Password"),
    "errorOccured" : MessageLookupByLibrary.simpleMessage("An Error Occured, Please Try Again Later"),
    "fLogin" : MessageLookupByLibrary.simpleMessage("Log In With Facebook"),
    "forgotPassword" : MessageLookupByLibrary.simpleMessage("Forgot Password ?"),
    "gLogin" : MessageLookupByLibrary.simpleMessage("Log In With Google"),
    "loading" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "login" : MessageLookupByLibrary.simpleMessage("Log In"),
    "password" : MessageLookupByLibrary.simpleMessage("Password"),
    "register" : MessageLookupByLibrary.simpleMessage("Register"),
    "signIn" : MessageLookupByLibrary.simpleMessage("Sign In")
  };
}
