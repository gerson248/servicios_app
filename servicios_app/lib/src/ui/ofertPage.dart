import 'package:flutter/material.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/ui/ofert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UtilityWidgets.dart';

class OfertPage extends StatefulWidget {
  OfertPage({Key key}) : super(key: key);

  @override
  _OfertPageState createState() => _OfertPageState();
}

class _OfertPageState extends State<OfertPage> {

  List dataO;
  bool loading=true;
  bool view=true;
  
  Future getData() async{
    
    final response = await http.post("http://0.0.0.0/servicio/getOfert.php", body: {
      "id": "2",
    });

    var dataofer = json.decode(response.body);
    
    if(dataofer.length!=0){
      dataO=(dataofer as List).map((e) => Servicio.fromJson(e)).toList();
    }
    
    setState(() {
      if(dataofer.length==0){
        view=false;
      }
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("¿Buscás alguna oferta?",style: TextStyle(color:Color(0xff392850), fontSize: 25), textAlign: TextAlign.center,),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
              ?UtilityWidget.containerloadingIndicator(context)
              :Container(
                child: ListView(
                  children:<Widget>[
                    view?ListView.builder(
                        itemCount: dataO.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,i){
                          if((DateTime.now().year == (DateTime.parse(dataO[i].fechaCad)).year) ){
                            if(DateTime.now().month == (DateTime.parse(dataO[i].fechaCad)).month){
                              if(DateTime.now().day > (DateTime.parse(dataO[i].fechaCad)).day){
                                return Container();
                              }else{

                                return Ofert(id:dataO[i].id,idServicioProfesional: dataO[i].idServicioProfesional);
                              }
                            }else{
                              if((DateTime.parse(dataO[i].fechaCad)).month < DateTime.now().month){

                                return Container();
                              }else{

                                return Ofert(id:dataO[i].id,idServicioProfesional: dataO[i].idServicioProfesional);
                              }
                            }
                          }else{
                            if((DateTime.now().year>(DateTime.parse(dataO[i].fechaCad)).year)){

                              return Container();
                            }else{
                              return Ofert(id:dataO[i].id,idServicioProfesional: dataO[i].idServicioProfesional);
                            }
                          }
                        },
                    ):Container(),
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