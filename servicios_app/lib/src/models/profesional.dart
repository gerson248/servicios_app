class Profesional {
  int id;
  String recibo;
  String dni;
  int verificado;
  String cuentaBancaria;
  String online; 
  int idProfesionalUsuario;

  Profesional({this.recibo, this.id, this.dni, this.verificado,this.cuentaBancaria,this.online,this.idProfesionalUsuario});

  factory Profesional.fromJson(Map<String, dynamic> json){
    return Profesional(
      id: int.parse(json['id']) as int,
      recibo: json['recibo'] as String,
      dni: json['dni'] as String,
      cuentaBancaria: json['cuentaBancaria'] as String,
      online: json['online'] as String,
      verificado: int.parse(json['verificado']) as int,
      idProfesionalUsuario: int.parse(json['idProfesionalUsuario']) as int,
    );
  }
}