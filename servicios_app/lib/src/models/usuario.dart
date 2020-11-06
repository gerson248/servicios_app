class Usuario {
  int id;
  String nombre;
  String apellido;
  String email;
  String password;
  String direccion;
  String telefono;
  String foto;
  String tipo;
  String token;
  //int verificado;

  Usuario({this.id,this.tipo,this.token, this.nombre, this.apellido, this.email, this.password, this.direccion, this.telefono, this.foto});

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
      id: int.parse(json['id']) as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      direccion: json['direccion'] as String,
      tipo: json['tipo'] as String,
      telefono: json['telefono'] as String,
      token: json['token'] as String,
      foto: json['foto'] as String,
      //verificado: json['verificado'] as int,
    );
  }
}