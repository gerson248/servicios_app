import 'package:flutter/material.dart';
import 'package:servicios_app/src/ui/infoAdditional.dart';
import 'package:servicios_app/src/ui/updateService.dart';

class UpdateInfoPage extends StatefulWidget {
  UpdateInfoPage({Key key, this.id}) : super(key: key);
  String id;

  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Mis servicios", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  //color: Colors.pink,
                ),
                child: ListView(
                  children:<Widget>[
                    SizedBox(height:40.0),
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
                            image: AssetImage("assets/images/update.png"),
                            colorFilter: ColorFilter.mode (Colors.white.withOpacity (0.45), BlendMode.dstATop),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:40.0,top:80.0,right:40.0),
                              child: Text(
                                "ACTUALIZAR DATOS DEL SERVICIO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,                              
                                ),
                              ),
                            ),
                            SizedBox(height:70.0),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateService(id:widget.id))),
                    ),
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
                            image: AssetImage("assets/images/add.png"),
                            colorFilter: ColorFilter.mode (Colors.white.withOpacity (0.45), BlendMode.dstATop),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,top:80.0,right:20.0),
                              child: Text(
                                "AÑADIR O ACTUALIZAR INFORMACION OPCIONAL DEL SERVICIO",
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InfoAdditional(id:widget.id))),
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