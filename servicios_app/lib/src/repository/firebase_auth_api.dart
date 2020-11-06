/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  //variables globales
  //contendra la instancia FirebaseAuth (nos traera lo que existe en firebase)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Contendra toda la logica respecto a sigin o hacer una conexion
  //metodo que devuelva un future en flutter
  // async por que sera un proceso qeu se ejecutara en segundo plano
  Future<FirebaseUser> signInWithGoogle() async{
    //paralizar y ejecutar en segundo plano
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    //solicitar el caudrod e diablo cuando se plique el boton sig in con google 
    //en gSA se obtendran las credenciales
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    // segunda autenticacion con firebase
    // nos regresa un objeto AuthResult el cual se obtiene un FirebaseUser
    FirebaseUser user = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: gSA.idToken, accessToken: gSA.accessToken));

    return user;
  }

  //logeo con credenciales
  Future<void> signInWithCredentials(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  // signUp - Registro
  Future<void> signUp(String email, String password) async{
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

    // SignOut
  Future<void> signOut() async {
    return Future.wait([
      _auth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  /*Future<FirebaseUser> emailAndPasswordSignIn(String email, String password) async{

    AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

    FirebaseUser user = authResult.user;

    return user;
  }*/
}*/