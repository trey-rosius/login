import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
}

class Auth implements BaseAuth {
  Future<String> signIn(String email, String password) async {
    // TODO: implement signIn
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return user.uid;
  }
}
