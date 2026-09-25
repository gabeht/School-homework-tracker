import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//User Login Function parameters take in both an email & password
  Future<String?> login(String email, String password) async{
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }
    catch (e){
      return e.toString();
    }
  }
//User Creating/Registration Function parameters take in both an email & password
  Future<String?> signUp(String email, String password) async{
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    }
    catch (e){
      return e.toString();
    }
  }
// Signout Function
  Future<void> signOut() async{
    await _auth.signOut();
  }
  // Returns active user stream/state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  //Pointer to return the current user
  User? get currentUser => _auth.currentUser;


}