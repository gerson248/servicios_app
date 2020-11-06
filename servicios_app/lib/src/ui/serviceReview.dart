import 'package:flutter/material.dart';
import 'package:servicios_app/src/ui/services.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:servicios_app/src/ui/updateInfoPage.dart';
import 'package:servicios_app/src/ui/updateService.dart';
import 'dart:convert';
import 'notification_dialog.dart';

class ServiceReview extends StatelessWidget {
  String category;
  String subcategory;
  String description;
  int id;
  String dias;
  String horario;
  DateTime selectedDate = DateTime.now();

  ServiceReview(this.category,this.subcategory, this.description,this.id, this.dias, this.horario);

  Future deleteService(BuildContext context) async{

    final response = await http.post("http://0.0.0.0/servicio/deleteVerificar.php", body: {
      "idServicio": id.toString(), 
      "estado": '0',
    });
    var datauser = json.decode(response.body);
  
    final response3 = await http.post("http://0.0.0.0/servicio/ventaIdUsuario.php", body: {
      "idServicio": id.toString(), 
    });
    var datauser2 = json.decode(response3.body);

    if(datauser2.length==0){
     // print(id);
      final response1 = await http.post("http://0.0.0.0/servicio/deleteService.php", body: {
        "id":id.toString(),
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicesPage()));
    }else{
      if(datauser.length!=0){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(child: Text("Aviso")),
            content: Text(
                  "No se puede eliminar este servicio, se encuentra pendiente a realizar aún; Realizar el servicio para poder eliminarse"
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
      }else{

        final response3 = await http.post("http://0.0.0.0/servicio/deleteVenta.php", body: {
          "idServicio": id.toString(), 
          "estado": '1',
        });
       // print(id);
        final response1 = await http.post("http://0.0.0.0/servicio/deleteService.php", body: {
          "id":id.toString(),
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicesPage()));

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final _category = Container(
      margin: EdgeInsets.only(left:20.0,top:20.0),
      //alignment: Alignment.s,
      //decoration: BoxDecoration(color:Colors.red),
      child: Text(
        category,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize:17.0,
          color: Colors.purple,
          fontWeight: FontWeight.w600,  
        ),
        //textAlign: TextAlign.start,
      ),
    );

    final _subcategory = Container(
      margin: EdgeInsets.only(left:20.0,top:60.0),
      child: Text(
        subcategory,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize:17.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,  
        ),
      ),
    );

    final _description = Container(
      margin: EdgeInsets.only(left:20.0,top:100.0,right:20.0),
      child: Text(
        description,
        style: TextStyle(
          fontSize:15.0,
          color: Colors.black,
          //fontWeight: FontWeight.w600,  
        ),
        textAlign: TextAlign.justify,
      ),
    );

    final _buttoncalendar = 
    Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right:10,top: 0.0),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.greenAccent,
          mini: true,
          //tooltip: "Fav",
          onPressed: ()async {
              showDateTimeDialog(context, initialDate: selectedDate,
                  onSelectedDate: (selectedDate) {
                /*setState(() {
                  this.selectedDate = selectedDate;
                });*/
              }, id: id.toString(), dias: dias.toString(), horario: horario.toString());
            },
          child: Icon(
            Icons.calendar_today,
          ),
        ),
      ),
    );

    final _buttoneliminate = 
    Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right:10,top: 50.0),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.red,
          mini: true,
          //tooltip: "Fav",
          onPressed: () {
            deleteService(context);
          },
          child: Icon(
            Icons.delete,
          ),
        ),
      ),
    );

    final serviceCard = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
      color: Colors.white,
      margin: EdgeInsets.all(10),
      //clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      elevation: 8,
      child: InkWell(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateInfoPage(id:id.toString()))),
        //onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateService(id:id.toString()))),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Column(
                  children:<Widget>[
                    SizedBox(height:200.0),
                  ]
                ),
                _category,
                _subcategory,
                _description,
                _buttoneliminate,
                _buttoncalendar,
              ],
            ),
          ],
        ),
      ),
    );

    return serviceCard;

  }
}