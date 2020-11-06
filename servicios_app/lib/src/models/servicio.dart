class Servicio {
  int id;
  String categoria;
  String subcategoria;
  String direccion;
  String opcionA;
  String opcionB;
  String descripcion;
  String precio;
  String cantidad;
  String porcentaje;
  String fechaCad;
  int certificado;
  String galeria1;
  String archivo;
  String galeria2;
  String galeria3;
  String recomendar;
  String latitud;
  String longitud;
  String dias;
  String horario;
  int idServicioProfesional;

  Servicio({this.idServicioProfesional,this.archivo,this.certificado ,this.id, this.recomendar,this.categoria, this.galeria1, this.galeria2, this.galeria3, this.latitud, this.longitud, this.subcategoria, this.direccion, this.opcionA, this.opcionB, this.descripcion, this.precio, this.cantidad, this.porcentaje, this.fechaCad, this.dias, this.horario});

  factory Servicio.fromJson(Map<String, dynamic> json){
    return Servicio(
      id: int.parse(json['id']) as int,
      idServicioProfesional: int.parse(json['idServicioProfesional']) as int,
      certificado: int.parse(json['certificado']) as int,
      categoria: json['categoria'] as String,
      subcategoria: json['subcategoria'] as String,
      direccion: json['direccion'] as String,
      opcionA: json['opcionA'] as String,
      opcionB: json['opcionB'] as String,
      descripcion: json['descripcion'] as String,
      precio: json['precio'] as String,
      cantidad: json['cantidad'] as String,
      porcentaje: json['porcentaje'] as String,
      fechaCad: json['fechaCad'] as String,
      latitud: json['latitud'] as String,
      longitud: json['longitud'] as String,      
      dias: json['dias'] as String,
      horario: json['horario'] as String,
      galeria1: json['galeria1'] as String,
      galeria2: json['galeria2'] as String, 
      galeria3: json['galeria3'] as String, 
      recomendar: json['recomendar'] as String, 
      archivo: json['archivo'] as String,
    );
  }
}