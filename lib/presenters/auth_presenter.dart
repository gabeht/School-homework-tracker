import "../models/auth_model.dart";

class AuthPresenter {
  final AuthModel _model = AuthModel();

  //Function passes parameters(email & password) to the model to perform log in
  Future<String?> login(String email, String password) {
    return _model.login(email, password);
  }
  //Function passes parameters(email & password) to the model to perform sign up
  Future<String?> signUp(String email, String password) {
    return _model.signUp(email, password);
  }
//Function passes parameters to the model to perform logout
  Future<void> logout() => _model.signOut();

  Stream authStateChanges() => _model.authStateChanges();

  String? getCurrentUserEMail() => _model.currentUser?.email;
}