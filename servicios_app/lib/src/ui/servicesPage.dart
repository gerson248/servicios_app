import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/notificacionPage.dart';
import 'package:servicios_app/src/ui/profile.dart';
import 'package:servicios_app/src/ui/serviceReview.dart';
import 'package:servicios_app/src/ui/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'ProgressIndicators.dart';
import 'SnackBars.dart';
import 'UtilityWidgets.dart';
import 'homePage.dart';



class ServicesPage extends StatefulWidget {
  ServicesPage({Key key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {

  int increment=0;
  int iterator;
  bool loading=true;
  List dataS;
  List dataV;

  Future showServices(BuildContext context) async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
      "email":localStorage.get("email"),
    });

    var dataId = json.decode(response1.body);

    final response2 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
      "idProfesionalUsuario":dataId[0]['id'],
    });

    var dataIdP = json.decode(response2.body);

   // print(dataIdP[0]['id']);

    final response3 = await http.post("http://0.0.0.0/servicio/getServices.php", body: {
      "idServicioProfesional": dataIdP[0]['id'],
    });

    final response4 = await http.post("http://0.0.0.0/servicio/showVentaPend.php", body: {
      "idUsuarioProfesional":dataId[0]['id'],
    });
    dataV=(json.decode(response4.body) as List).map((e) => Venta.fromJson(e)).toList();
    dataS=(json.decode(response3.body) as List).map((e) => Servicio.fromJson(e)).toList();

    setState(() {
      loading=false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showServices(context);
  }

  @override
  Widget build(BuildContext context) {

    final title = Container(
      margin: EdgeInsets.only(top:30.0),
      child: Center(
        child:Text(
          "Mis Servicios",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,  
          ),
        ),
      ),
    );


    return Builder(
      builder: (BuildContext context){
        return loading
        ?UtilityWidget.containerloadingIndicator(context)
        :Scaffold(
        appBar: AppBar(
            title: Text("Mis servicios", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
            backgroundColor: Color(0xFF32bcd1),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage())),
            ),
            actions: <Widget>[
              //IconButton(icon: Icon(Icons.arrow_back), onPressed: (){}),
              IconButton(icon: Icon(dataV.length>0?Icons.notifications_active:Icons.notifications), onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => NotificacionPage()));
              })
            ],
        ),
          body: Builder(
            builder: (BuildContext context){
              return Container(
                child: ListView(
                  children:<Widget>[
                    Container(
                      child: ListView.builder(
                        itemCount: dataS.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,i){
                          return ServiceReview(dataS[i].categoria, dataS[i].subcategoria,dataS[i].descripcion,dataS[i].id, dataS[i].dias, dataS[i].horario);
                        },
                      ),
                      
                    ),
                  ]
                ),
              );
            }
          
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              //increment<6 && increment>=0
              //increment==1
              //print(dataS.length);
              if(dataS.length<5 && dataS.length>=0){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Services()),);
              }else{
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Alerta"),
                    content: Text("Supero la cantidad maxima de servicios (Cantidad maxima 5)"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Aceptar"),
                        onPressed:(){
                          Navigator.of(context).pop("Aceptar");
                        }
                      ),
                    ],
                  ),
                );
                //Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()),);
              }
            },
            tooltip: 'Add',
            child: Icon(Icons.add,),
          ),
        );
      }
    );
  }
}