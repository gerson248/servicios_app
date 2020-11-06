/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:servicios_app/src/repository/auth_repository.dart';

class UsuarioBloc implements Bloc {

  final _auth_repository = AuthRepository();
  
  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController instace(estado de la autenticacion) onAuthStateChanged(nos devuelve el stream qeue stabamos esperando)
  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => streamFirebase;
  //Casos uso
  //1.SignIn a la aplicacion google
  Future<FirebaseUser> signInWithGoogle() {
    return _auth_repository.signInFirebase();
  }
  
  @override
  void dispose() {
    
  }
}*/