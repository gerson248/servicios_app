import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/ui/SnackBars.dart';
import 'package:servicios_app/src/ui/UtilityWidgets.dart';
import 'package:servicios_app/src/ui/serviceContractPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Contract extends StatefulWidget {
  Contract({Key key,this.idServicio,this.idUsuario, this.idUsuarioProfesional, this.precioT}) : super(key: key);

  final int idServicio;
  final int idUsuario;
  final int idUsuarioProfesional;
  final double precioT;
  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<Contract> {

  List dataS;
  List dataU;
  List dataUS;
  bool loading=true;

  DateTime selectedDate=DateTime.now();

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

  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAAu2k4BlE:APA91bHxNMVQDlGh53z5GslL86bMgjmimDlPdcPMGEZLNOXUdsR1LHV_t6tcSWi86H-dpiVTs3I8rzgrv-f3AcGTe-C4J7zJVra3Rb_471H2uc8rA4JK6Qqhk32uFy1T541gLQmzrypk';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {

    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'El cliente ${dataU[0].nombre} ${dataU[0].apellido} contrato un servicio',
          'title': 'Servicios App'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': '${dataUS[0].token}',
      },
      ),
    );

    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();
      
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }


  Future addVenta(BuildContext context) async{

    if(dataS[0].id!=null && dataU[0].id!=null){
      final response = await http.post("http://0.0.0.0/servicio/venta.php", body: {
        "idUsuario":widget.idUsuario.toString(),
        "idServicio":widget.idServicio.toString(),
        "dia":selectedDate.toString(),
        "idUsuarioProfesional":widget.idUsuarioProfesional.toString(),
        "pago":dataS[0].precio=="0"?"A convenir":widget.precioT.toString(),
      });
      sendAndRetrieveMessage();
      Navigator.push(context,MaterialPageRoute(builder: (context) => ServiceContractPage()));
    }else{
      SnackBars.showOrangeMessage(context, "Ocurrio un error");
    }
  }
  
  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id": widget.idServicio.toString(),
    });

    final response1 = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    final response8 = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id":widget.idUsuarioProfesional.toString(),
    });



    dataUS=(json.decode(response8.body) as List).map((e) => Usuario.fromJson(e)).toList();
    dataS=(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();
    dataU=(json.decode(response1.body) as List).map((e) => Usuario.fromJson(e)).toList();

    setState(() {
      loading=false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    //getLocation();
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
                padding: EdgeInsets.only(left:30,right:40,top: 20.0,bottom: 30),
                child: Container(
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
                          margin: EdgeInsets.only(left:20.0,right: 20,bottom: 20,top:10),
                          child: Text(
                            "Servicio Contratado",
                            textAlign: TextAlign.start,
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
                          margin: EdgeInsets.only(left:3,right:3,top:0.0),
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Center(
                            child: Text(
                              "${dias[selectedDate.weekday-1]}  ${selectedDate.day} de ${meses[selectedDate.month-1]} del ${selectedDate.year}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:17.0,
                                color:Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      dataS[0].dias!="0"?Center(
                        child: Container(
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Text(
                            "${dataS[0].dias}",
                            textAlign: TextAlign.start,
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Text(
                            "${dataS[0].horario}",
                            textAlign: TextAlign.start,
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Text(
                            dataS[0].precio=="0"?"costo: A convenir":"costo: ${widget.precioT} soles",
                            textAlign: TextAlign.start,
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
                          margin: EdgeInsets.only(left:3,right:3,top:20.0),
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Text(
                            "${dataU[0].nombre} ${dataU[0].apellido}",
                            textAlign: TextAlign.start,
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
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Center(
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
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left:3,right:3,top:10.0),
                          child: Text(
                            "${dataU[0].telefono}",
                            textAlign: TextAlign.start,
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
                                child: Text('CONFIRMAR',style: TextStyle(color: Colors.white))
                              ),
                            ),
                            onPressed: (){                            
                              addVenta(context);
                            },
                            color: Color(0xFF32bcd1),
                          ),
                        ),
                      ),                                         
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