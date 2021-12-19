import 'package:firebase_auth/firebase_auth.dart';

class UserClass {
  String userId;

  UserClass({required this.userId});
}

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserClass? _userFromFirebaseUser(User user) {
    return user != null ? UserClass(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser!);
    } catch(e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser!);
    } catch(e) {
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e);
    }
  }
}
