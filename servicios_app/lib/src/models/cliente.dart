import 'package:servicios_app/src/models/usuario.dart';

class Cliente extends Usuario{
  int id;
  int idClienteUsuario;

  Cliente({this.id, this.idClienteUsuario});

  factory Cliente.fromJson(Map<String, dynamic> json){
    return Cliente(
      id: json['id'] as int,
      idClienteUsuario: json['idClienteUsuario'] as int,
    );
  }
}