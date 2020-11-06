import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/ui/UtilityWidgets.dart';
import 'package:servicios_app/src/ui/contract.dart';
import 'package:servicios_app/src/ui/pago.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ContractPage extends StatefulWidget {
  ContractPage({Key key,this.idServicio,this.idUsuario, this.idUsuarioProfesional, this.precioT}) : super(key: key);

  final int idServicio;
  final int idUsuario;
  final int idUsuarioProfesional;
  final double precioT;

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {

  List dataP;
  bool loading=true;
  bool loading2=true;

  Future getData() async{
    

    final response = await http.post("http://0.0.0.0/servicio/getIdProfesionalByIdService.php", body: {
      "idServicioProfesional": widget.idServicio.toString(),
    });

    dataP=(json.decode(response.body) as List).map((e) => Profesional.fromJson(e)).toList();

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
            title: Text("Adquirir servicio", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
              ?UtilityWidget.containerloadingIndicator(context)
              :Container(
                child: ListView(
                  children:<Widget>[
                    SizedBox(height:35.0),
                    widget.precioT!=0?InkWell(
                      child: Container(
                        margin: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [new BoxShadow(          //SOMBRA
                            color: Color(0xffA4A4A4),
                            offset: Offset(1.0, 5.0),
                            blurRadius: 3.0,
                          ),],
                          image: DecorationImage(
                            fit: BoxFit.cover,//cubre todo 
                            image: AssetImage("assets/images/tarjeta.png"),
                            colorFilter: ColorFilter.mode (Colors.white.withOpacity (0.45), BlendMode.dstATop),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,top:80.0,right:20.0),
                              child: Text(
                                "PAGO ONLINE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,                              
                                ),
                              ),
                            ),
                            SizedBox(height:80.0),
                            Text(
                              "Nota: Se le aplicara una comision por pagos online el cual sera un adicional de 4%",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                            SizedBox(height:10.0),
                          ],
                        ),
                      ),
                      onTap:(){
                        if(dataP[0].online=="SI"){
                          if(widget.precioT>12){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Pago(idServicio: widget.idServicio,idUsuario:widget.idUsuario, idUsuarioProfesional:widget.idUsuarioProfesional, precioT:widget.precioT)));
                          }else{
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Center(child: Text("Aviso")),
                                content: Text(
                                  'No se pueden realizar pagos menores a 3 dolares',
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
                          }
                        }else{
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Center(child: Text("Aviso")),
                              content: Text(
                                'El profesional del servicio no cuenta con este metodo de pago.',
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
                        }

                      },
                    ):Container(), 
                    SizedBox(height:20.0),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [new BoxShadow(          //SOMBRA
                            color: Color(0xffA4A4A4),
                            offset: Offset(1.0, 5.0),
                            blurRadius: 3.0,
                          ),],
                          image: DecorationImage(
                            fit: BoxFit.cover,//cubre todo 
                            image: AssetImage("assets/images/pago.png"),
                            colorFilter: ColorFilter.mode (Colors.white.withOpacity (0.45), BlendMode.dstATop),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,top:80.0,right:20.0),
                              child: Text(
                                "PAGO DIRECTO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,                              
                                ),
                              ),
                            ),
                            SizedBox(height:80.0),
                          ],
                        ),
                      ),
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Contract(idServicio: widget.idServicio,idUsuario:widget.idUsuario, idUsuarioProfesional:widget.idUsuarioProfesional, precioT:widget.precioT)));
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