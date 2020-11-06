import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/profileProfesio.dart';
import 'dart:convert';

import 'UtilityWidgets.dart';

class Ofert extends StatefulWidget {
  Ofert({Key key, this.id, this.idServicioProfesional}) : super(key: key);
  
  final int id;
  final int idServicioProfesional;
  @override
  _OfertState createState() => _OfertState();
}

class _OfertState extends State<Ofert> {

  int stars =2;
  String descuento;
  List dataU;
  List dataS;
  List dataP;
  List dataV;
  double starss;
  bool loading=true;
  bool visibility=false;
  bool visibility1=false;

  Future getData() async{
    
    final response = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id": widget.id.toString(),
    });

    dataS=(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();

    final response2 = await http.post("http://0.0.0.0/servicio/getIdProfesionalByIdService.php", body: {
      "idServicioProfesional": widget.idServicioProfesional.toString(),
    });

    var idUsuario = json.decode(response2.body);

    final response3 = await http.post("http://0.0.0.0/servicio/getUsuariolByIdProfUsuario.php", body: {
      "idProfesionalUsuario": idUsuario[0]['idProfesionalUsuario'],
    });

    dataU=(json.decode(response3.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response4 = await http.post("http://0.0.0.0/servicio/getProfesional.php", body: {
      "idServicioProfesional": widget.idServicioProfesional.toString(),
    });

    dataP=(json.decode(response4.body) as List).map((e) => Profesional.fromJson(e)).toList();
    
    final response1 = await http.post("http://0.0.0.0/servicio/showStar.php", body: {
        "idServicio":dataS[0].id.toString(),
    });
    var dataVenta = json.decode(response1.body);
    double sta=0.0;
    int ac=0;
    if(dataVenta.length!=0){
      dataV=(dataVenta as List).map((e) => Venta.fromJson(e)).toList();
      for(int i=0;i<dataV.length;i++){
        if(dataV[i].calificar!="0"){
          sta=sta+double.parse(dataV[i].calificar);
          ac= ac+1;
        }
      }
      starss=ac!=0?sta/ac:0;
    }else{
      starss=0;
    }

    if(dataS[0].porcentaje!="0"){
      descuento = (double.parse(dataS[0].porcentaje)).toString();
    }else{
      descuento = ((double.parse(dataS[0].cantidad) * 100.0)/double.parse(dataS[0].precio)).toString();
    }


    dataS[0].precio == "";

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
  }

  @override
  Widget build(BuildContext context) {

    Widget photo(){ return Container(
      //decoration: BoxDecoration(color:Colors.red),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(8.0,),
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

    Widget userComent(){ return Container(
      margin: EdgeInsets.only(
        top:40.0,
        right:10.0,
        left:110.0
      ),
      child: Text("${dataS[0].descripcion}",
        style: TextStyle(
          fontSize: 13.0,
        ),
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );}

    Widget subcategory(){ return  Container(
      margin: EdgeInsets.only(left: 110.0),
      child: Text(
        "${dataS[0].subcategoria}",
        textAlign: TextAlign.left,
        style: TextStyle(
          //fontFamily: "Lato",
          fontSize: 17.0,
        ),
      ),
    );}

    Widget fechCad(){ return  Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        height: 20,
        //208
        margin: EdgeInsets.only(left:0,right:0.0,top:90.0),
        decoration: BoxDecoration(color:Colors.yellowAccent, border: Border.all(color:Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("Válido hasta el ${DateTime.parse(dataS[0].fechaCad).day}/${DateTime.parse(dataS[0].fechaCad).month}/${DateTime.parse(dataS[0].fechaCad).year}",
            style: TextStyle(
              //fontFamily: "Lato",
              fontSize: 13.0,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );}

    Widget verificate(){ return Container(
      width: 90.0,
      height: 20,
      margin: EdgeInsets.only(top:90.0),
      decoration: BoxDecoration(color:Colors.greenAccent),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("Certificado",
          style: TextStyle(
            //fontFamily: "Lato",
            fontSize: 13.0,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );}

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


    Widget desPorcentaje(){ return Container(
      width: 90.0,
      height: 20,
      margin: EdgeInsets.only(right:100.0),
      decoration: BoxDecoration(color:Colors.redAccent),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("${descuento} % dscto",
          style: TextStyle(
            //fontFamily: "Lato",
            fontSize: 13.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );}
    
    /*Widget oferDetails(){ 
      return Expanded(child: userComent());
    }*/

    return loading
        ?UtilityWidget.containerloadingIndicator(context)
        :Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
          ),
          margin: EdgeInsets.only(left:5.0, right: 5.0, top:4.0),
          child: InkWell(
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    subcategory(),
                    Container(
                      margin: EdgeInsets.only(
                        left:110.0,
                        top:18.0,
                      ),
                      child: Row(
                        children:printStars(),
                      ),
                    ),
                    photo(),
                    userComent(),
                    fechCad(),
                    desPorcentaje(),
                    visibility ? verificate() : Container(),
                  ],
                ),
              ],
            ),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileProfesio(id:dataS[0].id,idServicioProfesional: dataS[0].idServicioProfesional)));
            },
          ),
        );
  }
}
