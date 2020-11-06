class Favorito {
  int id;
  int idUsuarioFav;
  int idServicioFav;
  int idServicioProfesionalFav;

  Favorito({this.idUsuarioFav, this.idServicioFav, this.id, this.idServicioProfesionalFav});

  factory Favorito.fromJson(Map<String, dynamic> json){
    return Favorito(
      id: int.parse(json['id']) as int,
      idServicioFav: int.parse(json['idServicioFav']) as int,
      idUsuarioFav: int.parse(json['idUsuarioFav']) as int,
      idServicioProfesionalFav: int.parse(json['idServicioProfesionalFav']) as int,
      //idProfesionalUsuario: int.parse(json['idServicioProfesionalFav']) as int,
    );
  }
}