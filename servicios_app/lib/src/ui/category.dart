import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gps/gps.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/ui/filterPage.dart';
import 'package:servicios_app/src/ui/review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UtilityWidgets.dart';

class Categoryy extends StatefulWidget {
  Categoryy({Key key, this.namecategory, this.category, this.images}) : super(key: key);

  final String namecategory;
  final String images;
  final String category;
  

  @override
  _CategoryyState createState() => _CategoryyState();
}

class _CategoryyState extends State<Categoryy> {  

  List dataS;
  bool loading=true;

  LocationData myLocation;
  String error;
  Location location=new Location();

  double result=0;
  double latitud=0;
  double longitud=0;
  
  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    
    latitud=localStorage.getDouble("latitud");
    longitud=localStorage.getDouble("longitud");

    final response = await http.post("http://0.0.0.0/servicio/getDataService.php", body: {
      "subcategoria": widget.namecategory,
    });

    dataS=(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();

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
    final image_up = Container(
      //width: 20.0,
      height: 200.0,
      decoration: BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
          image: AssetImage(widget.images),
          fit: BoxFit.fill,
        ),
      ),
    );

    final title = Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width * 1,
      margin: EdgeInsets.only(top:130.0),
      decoration: BoxDecoration(
        color:Colors.black45,
      ),
      child: Column(
        children:<Widget>[
          Text(
            widget.category,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:25.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.namecategory,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:25.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]
      )
    );

    return Builder(
      builder: (context) {
        return Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Servicios", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.tune), onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context){
                    return FilterPage();
                  })).then((value){
                    if(result!=null){
                      setState(() {
                        //result =19.0;
                        result=value;
                      });
                    }
                  });
              })
            ],
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
              ?UtilityWidget.containerloadingIndicator(context)
              :Container(
                /*width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,*/
                decoration: BoxDecoration(
                  //color: Colors.pink,
                ),
                child: ListView(
                  children:<Widget>[
                    Stack(
                      children:<Widget>[
                        image_up,
                        title,
                      ]
                    ),
                    //image_up,
                    ListView.builder(
                      itemCount: dataS.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,i){
                        return Review(id:dataS[i].id,idServicioProfesional: dataS[i].idServicioProfesional,stars: 4, coment:dataS[i].descripcion, precio:dataS[i].precio, latitud: latitud,longitud: longitud,max:result);
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