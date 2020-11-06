import 'package:flutter/material.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/reviewNot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UtilityWidgets.dart';

class NotificacionPage extends StatefulWidget {
  NotificacionPage({Key key}) : super(key: key);

  @override
  _NotificacionPageState createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  
  bool loading=true;
  List dataU;
  List dataV;
  
  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    dataU=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

    
    final response1 = await http.post("http://0.0.0.0/servicio/showVentaProfe.php", body: {
      "idUsuarioProfesional":dataU[0].id.toString(),
    });

    dataV=(json.decode(response1.body) as List).map((e) => Venta.fromJson(e)).toList();

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
            title: Text("Notificaciones", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
              ?UtilityWidget.containerloadingIndicator(context)
              :Container(
                decoration: BoxDecoration(
                  //color: Colors.pink,
                ),
                child: ListView(
                  children:<Widget>[
                    SizedBox(height:20.0),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Servicios Pendientes",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize:20.0,
                            color: Color(0xFF32bcd1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ), 
                    Container(
                      child: ListView.builder(
                        itemCount: dataV.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,i){
                          //return Text("PASANDOO ${i}");
                          return ReviewNot(idVenta: dataV[i].id);
                        },
                      ),
                    ),                                          
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }
}
