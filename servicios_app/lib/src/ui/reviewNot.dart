import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/serviceNot.dart';
import 'UtilityWidgets.dart';
import 'dart:convert';

class ReviewNot extends StatefulWidget {
  ReviewNot({Key key,this.idVenta}) : super(key: key);
  
  final int idVenta;

  @override
  _ReviewNotState createState() => _ReviewNotState();
}

class _ReviewNotState extends State<ReviewNot> {
  
  bool loading=true;
  List dataV;
  List dataS;
  List dataU;
  
  Future getData() async{

    final response = await http.post("http://0.0.0.0/servicio/ventaId.php", body: {
      "id":widget.idVenta.toString(),
    });

    dataV=(json.decode(response.body) as List).map((e) => Venta.fromJson(e)).toList();

    final response1 = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id":dataV[0].idServicio.toString(),
    });

    dataS=(json.decode(response1.body) as List).map((e) => Servicio.fromJson(e)).toList();

    final response2 = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id":dataV[0].idUsuario.toString(),
    });

    dataU=(json.decode(response2.body) as List).map((e) => Usuario.fromJson(e)).toList();

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
    return loading
    ?UtilityWidget.containerloadingIndicator(context)
    :InkWell(
      child: Container(
        //height: 50.0,
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [new BoxShadow(          //SOMBRA
            color: Color(0xffA4A4A4),
            offset: Offset(1.0, 5.0),
            blurRadius: 3.0,
          ),],
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left:3),
              width: 350.0,
              //decoration: BoxDecoration(color:Colors.blue),
              padding: EdgeInsets.only(top:10.0),
              child: Row(
                children: [
                  Container(
                    width: 250.0,
                    //decoration: BoxDecoration(color:Colors.greenAccent),
                    child: Text(
                      "${dataS[0].categoria}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize:20.0,
                        color:Color(0xFF652dc1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  /*ontainer(
                    //decoration: BoxDecoration(color:Colors.green),
                    padding: EdgeInsets.only(),
                    child: Text(
                      "${DateTime.parse(dataV[0].dia).day}/${DateTime.parse(dataV[0].dia).month}/${DateTime.parse(dataV[0].dia).year}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize:15,
                        color:Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            Container(
              width: 350.0,
              margin: EdgeInsets.only(top:5.0,left:3),
              //decoration: BoxDecoration(color:Colors.red),
              child: Text(
                "${dataS[0].subcategoria}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize:20.0,
                  color:Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 350.0,
              margin: EdgeInsets.only(top:5.0,left:3),
              //decoration: BoxDecoration(color:Colors.red),
              child: Text(
                "Cliente: ${dataU[0].nombre} ${dataU[0].apellido}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize:20.0,
                  color:Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            dataV[0].estado=="0"?Container(
              width: 350.0,
              margin: EdgeInsets.only(top:5.0,left:3),
              //decoration: BoxDecoration(color:Colors.red),
              child: Text(
                "Estado: Pendiente",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize:20.0,
                  color:Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ):Container(
              width: 350.0,
              margin: EdgeInsets.only(top:5.0,left:3),
              //decoration: BoxDecoration(color:Colors.red),
              child: Text(
                "Estado: Realizado",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize:20.0,
                  color:Colors.greenAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              width: 350.0,
              margin: EdgeInsets.only(top:5.0,left:3),
              //decoration: BoxDecoration(color:Colors.red),
              child: Text(
                "costo: ${dataV[0].pago}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize:18.0,
                  color:Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),  
            SizedBox(height:15)          
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => ServiceNot(idVenta:widget.idVenta,fecha: dataV[0].dia,idServicio: dataV[0].idServicio,idUsuario: dataV[0].idUsuario)));
      },
    );
  }
}