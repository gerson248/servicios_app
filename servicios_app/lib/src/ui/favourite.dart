import 'package:flutter/material.dart';
import 'package:gps/gps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location/location.dart';
import 'package:servicios_app/src/models/favorito.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/ui/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UtilityWidgets.dart';
class Favourite extends StatefulWidget {
  Favourite({Key key}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  
  List dataF;

  Location location = new Location();
  LocationData _locationData;

  bool loading=true;
  double latitud=0;
  double longitud=0;

  Future getData() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    
    latitud=localStorage.getDouble("latitud");
    longitud=localStorage.getDouble("longitud");
    
    final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
      "email":localStorage.get("email"),
    });

    var dataId = json.decode(response1.body);
    
    final response = await http.post("http://0.0.0.0/servicio/getDataFav.php", body: {
      "idUsuarioFav": dataId[0]['id'],
    });

    dataF=(json.decode(response.body) as List).map((e) => Favorito.fromJson(e)).toList();

    //_locationData = await location.getLocation();


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
            title: Text("Favoritos", style: TextStyle(color: Colors.white,),),
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
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Lista de favoritos",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize:20.0,
                            color: Color(0xFF32bcd1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:10.0),
                    ListView.builder(
                      itemCount: dataF.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,i){
                        return Container(
                          margin: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [new BoxShadow(          //SOMBRA
                              color: Color(0xffA4A4A4),
                              offset: Offset(1.0, 5.0),
                              blurRadius: 3.0,
                            ),],
                          ),
                          child: Review(id:dataF[i].idServicioFav,idServicioProfesional: dataF[i].idServicioProfesionalFav,stars: 4, latitud: latitud,longitud:longitud,max:0)
                        );
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
