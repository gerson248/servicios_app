/*import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_api.dart';

class AuthRepository {
  //Definimos el objeto a  crear
  final _firebaseAuthAPI = FirebaseAuthAPI();
  //crear un futuro( espera recibir un dato a futuro) en este caso el dato qeu viene es firebaseUser
  //Future<FirebaseUser> signInFirebase() => _firebaseAuthAPI.signInWithGoogle();
  Future<FirebaseUser> signInFirebase() => _firebaseAuthAPI.signInWithCredentials('email', 'password');
}*/