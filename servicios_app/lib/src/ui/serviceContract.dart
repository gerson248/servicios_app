import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/profesional.dart';
import 'dart:convert';

import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'UtilityWidgets.dart';

class ServiceContract extends StatefulWidget {
  ServiceContract({Key key,this.fecha,this.idServicio,this.idUsuario,this.idVenta}) : super(key: key);

  final String fecha;
  final int idUsuario;
  final int idServicio;
  final int idVenta;
  @override
  _ServiceContractState createState() => _ServiceContractState();
}

class _ServiceContractState extends State<ServiceContract> {
  
  bool loading=true;
  List dataU;
  List dataS;
  List dataUS;
  List dataV;
  double puntuacion=0;

  var dias = [
    "Lunes", "Martes", "Miercoles",
    "Jueves", "Viernes", "Sabado", "Domingo",
  ];
  var meses = [
    "Enero", "Febrero", "Marzo",
    "Abril", "Mayo", "Junio", "Julio",
    "Agosto", "Septiembre", "Octubre",
    "Noviembre", "Diciembre"
  ];

  Future addStar() async{
    final response = await http.post("http://0.0.0.0/servicio/addStar.php", body: {
      "calificar":puntuacion.toString(),
      "id":widget.idVenta.toString(),
    });
    setState(() {
      dataV[0].calificar=puntuacion.toString();
    });
  }
  
  Future getData() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    dataU=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response1 = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id":widget.idServicio.toString(),
    });

    dataS=(json.decode(response1.body) as List).map((e) => Servicio.fromJson(e)).toList();

    final response2 = await http.post("http://0.0.0.0/servicio/getIdProfesionalByIdService.php", body: {
      "idServicioProfesional":dataS[0].idServicioProfesional.toString(),
    });

    var idUsuario = json.decode(response2.body);

    //print("holaaaaaa");
    final response3 = await http.post("http://0.0.0.0/servicio/getUsuariolByIdProfUsuario.php", body: {
      "idProfesionalUsuario": idUsuario[0]['idProfesionalUsuario'].toString(),
    });

    dataUS=(json.decode(response3.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response4 = await http.post("http://0.0.0.0/servicio/ventaId.php", body: {
      "id":widget.idVenta.toString(),
    });
    dataV=(json.decode(response4.body) as List).map((e) => Venta.fromJson(e)).toList();

    setState(() {
      loading=false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Servicio", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
              ?UtilityWidget.containerloadingIndicator(context)
              :Container(
                padding: EdgeInsets.only(left:40,right:40,top: 20.0,bottom: 30),
                child: Container(
                  margin: EdgeInsets.only(left:5,right:5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [new BoxShadow(          //SOMBRA
                      color: Color(0xffA4A4A4),
                      offset: Offset(1.0, 5.0),
                      blurRadius: 3.0,
                    ),],
                  ),
                  child:ListView(
                    children:<Widget>[
                      SizedBox(height:20.0),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                            "Servicio",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:20.0,
                              color:Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),  
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataS[0].categoria}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize:20.0,
                              color:Color(0xFF652dc1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataS[0].subcategoria}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize:17.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),  
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dias[DateTime.parse(widget.fecha).weekday-1]}  ${DateTime.parse(widget.fecha).day} de ${meses[DateTime.parse(widget.fecha).month-1]} del ${DateTime.parse(widget.fecha).year}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:17.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      dataS[0].dias!="0"?Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataS[0].dias}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:17.0,
                              color:Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ):Container(), 
                      dataS[0].horario!="0"?Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataS[0].horario}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ):Container(),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataUS[0].nombre} ${dataUS[0].apellido}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataUS[0].email}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataUS[0].telefono}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "costo: ${dataV[0].pago}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:20.0),
                          child: Text(
                            "CLIENTE",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),  
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:20.0),
                          child: Text(
                            "${dataU[0].nombre} ${dataU[0].apellido}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataU[0].email}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top:10.0),
                          child: Text(
                            "${dataU[0].telefono}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:18.0,
                              color:Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:10),
                      Center(
                        child: Container(
                          child: RaisedButton(
                            shape: StadiumBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text('CALIFICAR',style: TextStyle(color: Colors.white))
                              ),
                            ),
                            onPressed: (){                            
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Center(child: Text("Calificar Servicio")),
                                  content: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: SmoothStarRating(
                                      rating: double.parse(dataV[0].calificar),
                                      isReadOnly: false,
                                      size: 40,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      color:Color(0xFF652dc1),
                                      borderColor:Colors.black54,
                                      starCount: 5,
                                      allowHalfRating: true,
                                      spacing: 2.0,
                                      onRated: (value) {
                                        //print("rating value -> $value");
                                        puntuacion=value;
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancelar",style: TextStyle(color: Color(0xFF32bcd1),fontSize: 18),),
                                      onPressed:(){
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                    FlatButton(
                                      child: Text("Aceptar",style: TextStyle(color: Color(0xFF32bcd1),fontSize: 18),),
                                      onPressed:(){
                                        addStar();
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                  ],
                                ),
                              );
                            },
                            color: Color(0xFF32bcd1),
                          ),
                        ),
                      ), 
                      SizedBox(height:10),                                        
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}