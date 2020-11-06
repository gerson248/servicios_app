class Venta {
  int id;
  int idUsuario;
  int idUsuarioProfesional;
  int idServicio;
  String dia;
  String calificar;
  String recomendar;
  String estado;
  String pago;

  Venta({this.id, this.idUsuario, this.idServicio, this.dia,this.calificar, this.recomendar, this.estado, this.idUsuarioProfesional, this.pago});

  factory Venta.fromJson(Map<String, dynamic> json){
    return Venta(
      id: int.parse(json['id']) as int,
      idUsuario: int.parse(json['idUsuario']) as int,
      idUsuarioProfesional: int.parse(json['idUsuarioProfesional']) as int,
      idServicio: int.parse(json['idServicio']) as int,
      dia: json['dia'] as String,
      calificar: json['calificar'] as String,
      recomendar: json['recomendar'] as String,
      estado: json['estado'] as String,
      pago: json['pago'] as String,
      //verificado: json['verificado'] as int,
    );
  }
}