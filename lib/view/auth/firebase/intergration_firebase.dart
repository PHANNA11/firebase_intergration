import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  Future loginUser({required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<bool> logOutUser() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
}