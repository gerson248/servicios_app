import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:culqi_flutter/culqi_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/ui/SnackBars.dart';
import 'package:servicios_app/src/ui/UtilityWidgets.dart';
import 'package:servicios_app/src/ui/serviceContractPage.dart';
//import 'package:flutter_credit_card_brazilian/flutter_credit_card_brazilian.dart';

class Pago extends StatefulWidget {
  Pago({Key key,this.idServicio,this.idUsuario, this.idUsuarioProfesional, this.precioT});
  final double precioT;
  final int idServicio;
  final int idUsuario;
  final int idUsuarioProfesional;
  @override
  _PagoState createState() => _PagoState();
}

class _PagoState extends State<Pago> {

  List dataS;
  List dataU;
  List dataUS;
  List dataUP;
  bool loading=true;
  DateTime selectedDate=DateTime.now();

  TextEditingController _cardNumber = new TextEditingController();
  TextEditingController _expirationMonth = new TextEditingController();
  TextEditingController _expirationYear = new TextEditingController();
  TextEditingController _cvv = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  //TextEditingController _amount = new TextEditingController();
  //TextEditingController _currency_code = new TextEditingController();
  TextEditingController _phone_number = new TextEditingController();
  TextEditingController _address_city = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  //TextEditingController _country_code = new TextEditingController();
  TextEditingController _first_name = new TextEditingController();
  TextEditingController _last_name = new TextEditingController();
  //TextEditingController controllerPorcentaje = new TextEditingController();
  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAAu2k4BlE:APA91bHxNMVQDlGh53z5GslL86bMgjmimDlPdcPMGEZLNOXUdsR1LHV_t6tcSWi86H-dpiVTs3I8rzgrv-f3AcGTe-C4J7zJVra3Rb_471H2uc8rA4JK6Qqhk32uFy1T541gLQmzrypk';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    //print(dataUS[0].token);
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

  Future enviarCorreo()async{
    final response = await http.post("http://0.0.0.0/servicio/correoEditadoBancario.php", body: {
      "nombre":dataUS[0].nombre,
      "apellido":dataUS[0].apellido,
      "telefono":dataUS[0].telefono,
      "direccion":dataUS[0].direccion,
      "email":dataUS[0].email,
      "cuentaBancaria":dataUP[0].cuentaBancaria,
      "precioconadicional":(((widget.precioT)*104)/100).toString(),
      "precio":widget.precioT.toString(),
      "fecha":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",

    });
  }


  Future addVenta(BuildContext context) async{


    final response = await http.post("http://0.0.0.0/servicio/venta.php", body: {
      "idUsuario":widget.idUsuario.toString(),
      "idServicio":widget.idServicio.toString(),
      "dia":selectedDate.toString(),
      "idUsuarioProfesional":widget.idUsuarioProfesional.toString(),
      "pago":widget.precioT.toString(),
    });
    sendAndRetrieveMessage();
    
    
    Navigator.push(context,MaterialPageRoute(builder: (context) => ServiceContractPage()));

  }


  Future click(BuildContext context)async{

    var salida;

    if( 
      _cardNumber.text.isEmpty ||
      _expirationMonth.text.isEmpty ||
      _expirationYear.text.isEmpty ||
      _cvv.text.isEmpty ||
      _email.text.isEmpty ||
      _phone_number.text.isEmpty ||
      _address_city.text.isEmpty ||
      _address.text.isEmpty ||
      _first_name.text.isEmpty ||
      _last_name.text.isEmpty 
    ){
      SnackBars.showOrangeMessage(context, "Debes completar todos los campos");
    }else{
      CCard card = CCard(
        cardNumber: _cardNumber.text,
        expirationMonth: int.parse(_expirationMonth.text),
        expirationYear: int.parse(_expirationYear.text),
        cvv: _cvv.text,
        email: _email.text
      );

      try{
        CToken token = await createToken(card: card, apiKey: "pk_test_f1d44bfec85deec9");
          //su token
        /*print(token.id);
        print("pASO1");*/
        final response = await http.post("http://0.0.0.0/servicio/pago.php", body: {
          "amount": (widget.precioT*104).toString(),
          "currency_code": "PEN",
          "email": _email.text,
          "phone_number": _phone_number.text,
          "address_city": _address_city.text,
          "address": _address.text,
          "country_code": "PE",
          "first_name": _first_name.text,
          "last_name": _last_name.text,
          "source_id": token.id,        
        });
        //print(token.id);
        salida=response.body;
      } on CulqiBadRequestException catch(ex){
        print("${ex.cause}");
          /*showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(child: Text("Aviso")),
              content: Text(
                "${ex.cause}",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Aceptar",style: TextStyle(color: Color(0xFF32bcd1),fontSize: 18),),
                  onPressed:(){
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          );*/
      } on CulqiUnknownException catch(ex){
          //codigo de error del servidor
          print(ex.cause);
          /*showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(child: Text("Aviso")),
              content: Text(
                "${ex.cause}",
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Aceptar",style: TextStyle(color: Color(0xFF32bcd1),fontSize: 18),),
                  onPressed:(){
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          );*/
      }
      //-----------------------------PASANDOO------------------------//
      if(salida=="EXITOSO"){
        //print("SE REALIZO EL PAGO");
        addVenta(context);
        enviarCorreo();
        //SnackBars.showOrangeMessage(context, "EXITOSOOOOOOOO");
      }else{
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(child: Text("Aviso")),
            content: Text(
              "Ocurrio un error al realizar el pago, verifique bien sus datos",
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",style: TextStyle(color: Color(0xFF32bcd1),fontSize: 18),),
                onPressed:(){
                  Navigator.of(context).pop();
                }
              ),
            ],
          ),
        );
      }
    }
  }

  Future getData()async{
    print(widget.idUsuarioProfesional.toString());
    final response = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id": widget.idUsuarioProfesional.toString(),
    });

    dataUS=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response3 = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id": widget.idUsuario.toString(),
    });

    dataU=(json.decode(response3.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response2 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
      "idProfesionalUsuario": dataUS[0].id.toString(),
    });

    dataUP=(json.decode(response2.body) as List).map((e) => Profesional.fromJson(e)).toList();

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
    
    return Scaffold(
      appBar:AppBar(
        title: Text("Pago online", style: TextStyle(color: Colors.white,),),
        backgroundColor: Color(0xFF32bcd1),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return loading
            ?UtilityWidget.containerloadingIndicator(context)
            :Container(
            child: SingleChildScrollView(
              child: Column(
                children:<Widget>[
                  SizedBox(height:20.0),
                  Container(
                    margin: EdgeInsets.only(left:20,right: 20),
                    height: MediaQuery.of(context).size.height * 0.28,
                    decoration: BoxDecoration(
                      //color: Colors.transparent,
                      borderRadius: BorderRadius.circular(11.5),
                      boxShadow: [new BoxShadow(          //SOMBRA
                        color: Color(0xffA4A4A4),
                        offset: Offset(1.0, 5.0),
                        blurRadius: 3.0,
                      ),],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/tarjetaPago.png"),
                      ),
                    ),
                  ),
                  SizedBox(height:20.0),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left:20.0,right: 20),
                      child: TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        maxLength:16,
                        cursorColor: Colors.black,
                        cursorRadius: Radius.circular(16),
                        cursorWidth: 4.0,
                        controller: _cardNumber,
                        decoration: InputDecoration(
                          hintText: "Numero de tarjeta",
                          labelText: "Numero de tarjeta",
                          //hintStyle: greyText(),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white
                        ),
                        validator: (value) {
                          return value.isEmpty?"incompleto":value;
                        }
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:20.0,right:20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            maxLength:2,
                            controller: _expirationMonth,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Mes",
                                labelText: "Mes",
                                border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                                fillColor: Colors.white,
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:20.0,right:20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            maxLength:2,
                            controller: _expirationYear,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Año",
                                labelText: "Año",
                                border: OutlineInputBorder(),
                                fillColor: Colors.white
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left:20.0,right:20),
                      child: TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        maxLength:4,
                        cursorColor: Colors.black,
                        cursorRadius: Radius.circular(16),
                        cursorWidth: 4.0,
                        controller: _cvv,
                        decoration: InputDecoration(
                          hintText: "CVV",
                          labelText: "CVV",
                          //hintStyle: greyText(),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white
                        ),
                        validator: (value) {
                          return value.isEmpty?"incompleto":value;
                        }
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:20.0,right:10),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _first_name,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Nombre",
                                labelText: "Nombre",
                                border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                                fillColor: Colors.white,
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:10.0,right:20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _last_name,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Apellido",
                                labelText: "Apellido",
                                border: OutlineInputBorder(),
                                fillColor: Colors.white
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                    ],
                  ), 
                  SizedBox(height:15.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:20.0,right:10),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _address_city,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Ciudad",
                                labelText: "Ciudad",
                                border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                                fillColor: Colors.white,
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:10.0,right:20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _address,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Direccion",
                                labelText: "Direccion",
                                border: OutlineInputBorder(),
                                fillColor: Colors.white
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:15.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:20.0,right:10),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _email,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Correo",
                                labelText: "Correo",
                                border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                                fillColor: Colors.white,
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left:10.0,right:20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _phone_number,
                            cursorColor: Colors.black,
                            cursorRadius: Radius.circular(16),
                            cursorWidth: 4.0,
                            decoration: InputDecoration(
                                hintText: "Celular",
                                labelText: "Celular",
                                border: OutlineInputBorder(),
                                fillColor: Colors.white
                            ),
                            validator: (value) {
                              return value.isEmpty?"incompleto":value;
                            }),
                        ),
                      ),
                    ],
                  ), 
                  SizedBox(height:15.0),
                  InkWell(
                    onTap: (){click(context);},
                    child: Container(
                      margin: EdgeInsets.only(left:20,right: 20, top:5),
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(11.5),
                        boxShadow: [new BoxShadow(          //SOMBRA
                          color: Color(0xffA4A4A4),
                          offset: Offset(1.0, 5.0),
                          blurRadius: 3.0,
                        ),],
                      ),
                      child: Align(alignment: Alignment.center, child: Text('PAGO: S/${((widget.precioT)*104)/100}', style: TextStyle(fontSize:35.0,fontWeight: FontWeight.w600,color: Colors.white ),)),
                    ),
                  ), 
                  SizedBox(height:30.0),                                                        
                ],
              ),
            ),
          );
        }
      ),
    );

  }
}