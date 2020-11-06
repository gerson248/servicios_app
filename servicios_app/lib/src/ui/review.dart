import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/profileProfesio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UtilityWidgets.dart';




class Review extends StatefulWidget {
   Review({Key key, this.id,this.latitud,this.longitud, this.idServicioProfesional, this.stars, this.coment, this.precio, this.max}) : super(key: key);

  final String precio;
  final String coment;
  final int stars;
  final double latitud;
  final double longitud;
  final int id;
  final int idServicioProfesional;
  final double max;
 
  @override
  _ReviewState createState() => _ReviewState();
}
 
class _ReviewState extends State<Review> {

  List dataU;
  List dataS;
  List dataV;
  List dataP;

  bool loading=true;
  //LocationData myLocation;
  //Location location = new Location();
  String error;
  double valor;
  Distance distance = new Distance();
  double km=0.0;
  double starss;
  int recomendar;
  bool visibility=false;
  bool visibility1=false;
   
  Future getData() async{

    final response1 = await http.post("http://0.0.0.0/servicio/showStar.php", body: {
        "idServicio":widget.id.toString(),
    });
    var dataVenta = json.decode(response1.body);
    double sta=0.0;
    int ac=0;
    int reco=0;
    if(dataVenta.length!=0){
      dataV=(dataVenta as List).map((e) => Venta.fromJson(e)).toList();
      for(int i=0;i<dataV.length;i++){
        if(dataV[i].calificar!="0"){
          sta=sta+double.parse(dataV[i].calificar);
          ac= ac+1;
        }
      }
      starss=ac!=0?sta/ac:0;
      for(int i=0;i<dataV.length;i++){
        reco=reco+int.parse(dataV[i].recomendar);
      }
      recomendar=reco;
    }else{
      starss=0;
      recomendar=0;
    }

    final response = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id": widget.id.toString(),
    });

    final response2 = await http.post("http://0.0.0.0/servicio/getIdProfesionalByIdService.php", body: {
      "idServicioProfesional": widget.idServicioProfesional.toString(),
    });

    var idUsuario = json.decode(response2.body);

    final response3 = await http.post("http://0.0.0.0/servicio/getUsuariolByIdProfUsuario.php", body: {
      "idProfesionalUsuario": idUsuario[0]['idProfesionalUsuario'],
    });
    final response4 = await http.post("http://0.0.0.0/servicio/getProfesional.php", body: {
      "idServicioProfesional": widget.idServicioProfesional.toString(),
    });

    dataP=(json.decode(response4.body) as List).map((e) => Profesional.fromJson(e)).toList();
    dataS=(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();
    dataU=(json.decode(response3.body) as List).map((e) => Usuario.fromJson(e)).toList();


    km = distance.as(LengthUnit.Kilometer,
      LatLng(double.parse(dataS[0].latitud),double.parse(dataS[0].longitud)),
      LatLng(widget.latitud,widget.longitud)
    );

    setState(() {
      if(dataS[0].certificado==1){
        visibility=true;
      }
      if(dataP[0].verificado==1){
        visibility1=true;
      }
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

    final star_border = Container(
      margin: EdgeInsets.only(
        left: 0.00, 
      ),
      child: Icon(Icons.star_border,
      color: Colors.yellow),
    );

    final star = Container(
      margin: EdgeInsets.only(
        left: 0.00, 
      ),
      child: Icon(Icons.star,
      color: Colors.yellow),
    );


    List<Widget> printStars(){
      List<Widget> estrella = new List<Widget>();
      for(int i=0; i<starss.round(); i++){
        estrella.add(star);
      }
      for(int j= starss.round(); j<5; j++){
        estrella.add(star_border);
      }
      return estrella;
    }

    Widget userComent(){return Container(
      margin: EdgeInsets.only(
        left: 100.00,
        right: 20.0
      ),
      child: Text("${dataS[0].descripcion}",
        style: TextStyle(
          //fontFamily: "Lato",
          fontSize: 13.0,
          fontWeight: FontWeight.w900,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.justify,
      ),
    );}

    Widget recomend(){return Container(
      margin: EdgeInsets.only(
        left: 4.0,
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.thumb_up,
                  color: Colors.blueAccent
                ),
              ),

              Container(
                margin: EdgeInsets.all(3.0),
                child: Text(
                  "${recomendar} recomendaciones",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    //fontFamily: "Lato",
                    fontSize: 13.0,
                    color: Colors.black38,
                  ),
                ),
              ),
              
            ],
          ),
        ],
      ),
    );}

    Widget price(){return Container(
      margin: EdgeInsets.only(
        left: 4.0,
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.green
                ),
              ),
              Container(
                margin: EdgeInsets.all(3.0),
                child: Text(
                  dataS[0].precio=="0" ? "A convenir" : "${dataS[0].precio} soles",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    //fontFamily: "Lato",
                    fontSize: 13.0,
                    color: Colors.black38,
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );}

    Widget userName(){return Container(
      margin: EdgeInsets.only(
        top:0.0,
        left: 0.00,
      ),
      child: Text(
        //"Kevin",
        dataU[0].nombre,
        textAlign: TextAlign.left,
        style: TextStyle(
          //fontFamily: "Lato",
          fontSize: 17.0,
        ),
      ),
    );}

    Widget primer_file() {return Container(
      //decoration: BoxDecoration(color:Colors.blueAccent),
      margin: EdgeInsets.only(left: 5.0,),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.33,
                //decoration: BoxDecoration(color:Colors.green),
                //margin: EdgeInsets.only(right: 40),
                child: userName()
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Container(
                margin: EdgeInsets.only(left: 30.0),
                child: Icon(Icons.directions_car)
              )

            ],
          ),
        ],
      ),
    );}

    Widget second_file(){return Container(
      //decoration: BoxDecoration(color:Colors.blueAccent),
            margin: EdgeInsets.only(
              left: 4.0,
            ),
            child: Row(
              children:<Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.375,
                  //margin: EdgeInsets.only(right: 40),
                  child: Row(
                    children: printStars(),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.043),
                dataS[0].latitud != '0' && widget.latitud != 0? Container(
                  width: 70,
                  height:30,
                  margin: const EdgeInsets.only(left:10,right:10,),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(16.0),
                    color: Color(0xFF32bcd1),
                  ),
                  child: Center(
                    child: Text(
                      '${km} KM',
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ),
                ):Container(),
              ]
            ),
          );}

    Widget userDetails(){return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //userName,
            SizedBox(height:20.0),
            primer_file(),
            second_file(),
            recomend(),
            price(),
          ],
        ),
    );}

    Widget photo(){return Container(
      //decoration: BoxDecoration(color:Colors.red),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top:20.0,left:0.0),
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,//cubre todo 
                image: NetworkImage("http://0.0.0.0/servicio/${dataU[0].foto}"),
              ),
            ),
          ),
          visibility1 ? Container(
            width: 50.0,
            height: 80.0,
            padding: EdgeInsets.only(top:25,left:0.0,right:15.0,bottom: 15.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,//cubre todo 
                  image: AssetImage("assets/images/verificado.png"),
                ),
              ),
            ),
          ) : Container(),
          visibility ? Container(
            width: 50.0,
            height: 80.0,
            padding: EdgeInsets.only(top:25,left:0.0,right:15.0,bottom: 10.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,//cubre todo 
                  image: AssetImage("assets/images/certified.png"),
                ),
              ),
            ),
          ) : Container(),
        ],
      ),
    );}

    /*return Row(
      children: <Widget>[
        photo,
        userDetails,
      ],
    );*/

    return loading
      ?UtilityWidget.containerloadingIndicator(context)
      :Container(
      //decoration: BoxDecoration(color:Colors.red),
      margin: EdgeInsets.only(left:2.0, right: 0.0, top:4.0),
      child: Column(
        children: <Widget>[
          widget.max==0 ? InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileProfesio(id: widget.id,idServicioProfesional: widget.idServicioProfesional))),
            splashColor: Colors.black12,
            child: Column(
              children:<Widget>[
                Row(
                  children: <Widget>[
                    photo(),
                    userDetails(),
                  ],
                ),
                userComent(),
                SizedBox(height:10),
              ]
            )
          ): km<widget.max ? InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileProfesio(id: widget.id,idServicioProfesional: widget.idServicioProfesional))),
            splashColor: Colors.black12,
            child: Column(
              children:<Widget>[
                Row(
                  children: <Widget>[
                    photo(),
                    userDetails(),
                  ],
                ),
                userComent(),
              ]
            )
          ):Container(),
        ],
      ),
    );
  }
}
/*
*/