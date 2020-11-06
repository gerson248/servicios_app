import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/UtilityWidgets.dart';
import 'package:servicios_app/src/ui/reviewContract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceContractPage extends StatefulWidget {
  ServiceContractPage({Key key}) : super(key: key);

  @override
  _ServiceContractPageState createState() => _ServiceContractPageState();
}

class _ServiceContractPageState extends State<ServiceContractPage> {

  List dataV;
  List dataU;
  bool loading=true;
  
  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    dataU=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

    //print(dataU[0].id.toString());
    final responsee = await http.post("http://0.0.0.0/servicio/showVenta.php", body: {
      "idUsuario":dataU[0].id.toString(),
    });

    dataV=(json.decode(responsee.body) as List).map((e) => Venta.fromJson(e)).toList();

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
            title: Text("Historial", style: TextStyle(color: Colors.white,),),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pushReplacementNamed(context, '/homePage');}),
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
                        padding: EdgeInsets.only(top:20.0),
                        child: Text(
                          "Servicios Contratados",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize:20.0,
                            //color: Color(0xFF32bcd1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:10.0),
                    ListView.builder(
                      itemCount: dataV.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,i){
                        print("PASANDOOO");
                        return ReviewContract(idVenta:dataV[dataV.length-(i+1)].id);
                      },
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