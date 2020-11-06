import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/contractPage.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//url_launcher: ^5.7.4
import 'dart:convert';

import 'UtilityWidgets.dart';
class ProfileProfesio extends StatefulWidget {
  ProfileProfesio({Key key, this.id, this.idServicioProfesional}) : super(key: key);
  
  final int id;
  final int idServicioProfesional;
  //final LatLng fromPoint  = LatLng(	-12.04318, -77.02824);

  @override
  _ProfileProfesioState createState() => _ProfileProfesioState();
}

class _ProfileProfesioState extends State<ProfileProfesio> {

  GoogleMapController _mapController;

  TextEditingController controllerLatitud = new TextEditingController();
  TextEditingController controllerLongitud = new TextEditingController();
  
  List dataU;
  List dataS;
  List dataP;
  List dataV;

  bool loading=true;
  bool visibility=true;
  bool visibility1=false;
  bool visibility2=false;
  bool visibility3=true;
  bool visibility4=true;
  bool visibility5=true;
  bool visibilityGalery=true;

  double precioo=0;
  double precioT=0;

  Color warma= Colors.black12;
  Color warma2= Colors.black45;

  Future contrato() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.get("email")!=null){
      final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
        "email":localStorage.get("email"),
      });

      var dataId = json.decode(response1.body);
      Navigator.push(context,MaterialPageRoute(builder: (context) => ContractPage(idServicio: dataS[0].id,idUsuario:int.parse(dataId[0]['id']),idUsuarioProfesional:dataU[0].id, precioT:precioT)));
    }else{
      Navigator.push(context,MaterialPageRoute(builder: (context) => SingUpScreenPage()));
    }
  }

  Future getData() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if(localStorage.get("email")!=null){
      //aqui
      final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
        "email":localStorage.get("email"),
      });

      var dataId = json.decode(response1.body);
      //dataId[0]['id']

      //widget.id.toString()
      final response5 = await http.post("http://0.0.0.0/servicio/getVenta.php", body: {
        "idServicio": widget.id.toString(),
        "idUsuario": dataId[0]['id'],
      });

      var dataventa= json.decode(response5.body);

      final response8 = await http.post("http://0.0.0.0/servicio/showFav.php", body: {
        "idServicioFav": widget.id.toString(),
        "idUsuarioFav": dataId[0]['id'],
      });

      var dataFav= json.decode(response8.body);

      if(dataFav.length!=0){
        warma2=Color(0xFF11DA53);
      }

      if(dataventa.length!=0){
        dataV=(dataventa as List).map((e) => Venta.fromJson(e)).toList();
        setState(() {
          if(dataV[0].recomendar=="1"){
            warma=Colors.blueAccent;
          }
        });
      }else{
        visibility3=false;
      }
    }else{
      setState(() {
        visibility3=false;
        visibility4=false;
      });
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

    if(dataS[0].precio!="0"){
      if(dataS[0].fechaCad!=""){
        if((DateTime.now().year == (DateTime.parse(dataS[0].fechaCad)).year) ){
          if(DateTime.now().month == (DateTime.parse(dataS[0].fechaCad)).month){
            if(DateTime.now().day > (DateTime.parse(dataS[0].fechaCad)).day){
              precioT=double.parse(dataS[0].precio);
              precioo=0;
            }else{
              if(dataS[0].porcentaje!="0"){
                precioo= (((100.0 - double.parse(dataS[0].porcentaje)) * double.parse(dataS[0].precio))/100);
                precioT=precioo;
              }
              if(dataS[0].cantidad!="0"){
                precioo=(double.parse(dataS[0].precio) - double.parse(dataS[0].cantidad));
                precioT=precioo;
              }
            }
          }else{
            if((DateTime.parse(dataS[0].fechaCad)).month < DateTime.now().month){
              precioT=double.parse(dataS[0].precio);
              precioo=0;
            }else{
              if(dataS[0].porcentaje!="0"){
                precioo= (((100.0 - double.parse(dataS[0].porcentaje)) * double.parse(dataS[0].precio))/100);
                precioT=precioo;
              }
              if(dataS[0].cantidad!="0"){
                precioo=(double.parse(dataS[0].precio) - double.parse(dataS[0].cantidad));
                precioT=precioo;
              }
            }
          }
        }else{
          if((DateTime.now().year>(DateTime.parse(dataS[0].fechaCad)).year)){
            precioT=double.parse(dataS[0].precio);
            precioo=0;
          }else{
            if(dataS[0].porcentaje!="0"){
              precioo= (((100.0 - double.parse(dataS[0].porcentaje)) * double.parse(dataS[0].precio))/100);
              precioT=precioo;
            }
            if(dataS[0].cantidad!="0"){
              precioo=(double.parse(dataS[0].precio) - double.parse(dataS[0].cantidad));
              precioT=precioo;
            }
          }
        }
      }else{
        precioT=double.parse(dataS[0].precio);
      }
    }
    

    setState(() {
      if(dataS[0].cantidad=="0" && dataS[0].porcentaje=="0"){
        visibility5=false;
      }
      if(dataS[0].certificado==1){
        visibility1=true;
      }
      if(dataP[0].verificado==1){
        visibility2=true;
      }
      if(dataS[0].latitud=="0"){
        visibility=false;
      }
      if(dataS[0].galeria1=="0" && dataS[0].galeria2=="0" && dataS[0].galeria3=="0"){
        visibilityGalery=false;
      }
      loading=false;
    });

  }

  Future addReco() async{
    
    if(warma == Colors.black12){
      //dataS[0].recomendar=(int.parse(dataS[0].recomendar)+1).toString();
      final response = await http.post("http://0.0.0.0/servicio/addRecomendar.php", body: {
        "idServicio":dataV[0].idServicio.toString(),
        "idUsuario":dataV[0].idUsuario.toString(),
        "recomendar":"1",
      });
    }else{
      dataS[0].recomendar=(int.parse(dataS[0].recomendar)-1).toString();
      final response = await http.post("http://0.0.0.0/servicio/addRecomendar.php", body: {
        "idServicio":dataV[0].idServicio.toString(),
        "idUsuario":dataV[0].idUsuario.toString(),
        "recomendar":"0",
      });
    }

    setState(() {
      if(warma == Colors.black12){
        warma = Colors.blueAccent;
      }else{
        warma = Colors.black12;
      }
                                  
    });

  }

  Future addFav(BuildContext context)async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
      
    final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
      "email":localStorage.get("email"),
    });

    var dataId = json.decode(response1.body);

    if(warma2 == Colors.black45){
      final response = await http.post("http://0.0.0.0/servicio/addFav.php", body: {
        "idServicioFav":dataS[0].id.toString(),
        "idUsuarioFav":dataId[0]['id'],
        "idServicioProfesionalFav":dataS[0].idServicioProfesional.toString(),
      });
    }else{
      final response2 = await http.post("http://0.0.0.0/servicio/deleteFav.php", body: {
        "idServicioFav":dataS[0].id.toString(),
        "idUsuarioFav":dataId[0]['id'],
      });
    }

    setState(() {
      if(warma2 == Colors.black45){
        warma2 = Color(0xFF11DA53);
      }else{
        warma2 = Colors.black45;
      }
                                  
    });
  }

  void _launchURL(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      throw 'No se encontro la url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {

    Widget firstContainer(){return Container(
      margin: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top:5.0,
      ),
      //decoration: BoxDecoration(color:Colors.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Container(
            //decoration: BoxDecoration(color:Colors.blue),
            margin: EdgeInsets.only(left:10,right: 10),
            child: IconButton(icon: Icon(Icons.message, color: Colors.green,), onPressed: (){
              _launchURL("sms:+51 ${dataU[0].telefono}");
            }),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Container(
            height: 150,
            //decoration: BoxDecoration(color:Colors.green,),
            //height: 80.0,
            margin: EdgeInsets.only(left:8.0,right:8.0,top:20),
            //decoration: BoxDecoration(color: Colors.red),
            child: Center(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 65.0,
                    backgroundImage: NetworkImage("http://0.0.0.0/servicio/${dataU[0].foto}"),
                    backgroundColor: Colors.blue,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 40.0,
                      top: 100,
                    ),
                    child: FloatingActionButton(
                      backgroundColor: warma2,
                      //backgroundColor: Color(0xFF11DA53),
                      tooltip: "Fav",
                      onPressed: visibility4?(){addFav(context);}:null,
                      child: Icon(
                        Icons.favorite_border,
                      ),
                    ),
                  ),
                  visibility2 ? Container(
                    //width: 50.0,
                    //height: 80.0,
                    padding: EdgeInsets.only(top:0,left:0.0,right:30.0,bottom:0.0),
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        //color:Colors.blue,
                        image: DecorationImage(
                          fit: BoxFit.cover,//cubre todo 
                          image: AssetImage("assets/images/verificado.png"),
                        ),
                      ),
                    ),
                  ) : Container(),
                  visibility1 ? Container(
                    //width: 50.0,
                    //height: 80.0,
                    padding: EdgeInsets.only(top:5,left:0.0,right:30.0,bottom: 0.0),
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
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Container(
            //decoration: BoxDecoration(color:Colors.blue),
            margin: EdgeInsets.only(left:10,right: 10),
            child: IconButton(icon: Icon(Icons.phone, color: Colors.green), onPressed: (){
              _launchURL("tel:+51 ${dataU[0].telefono}");
            }),
          ),
        ]
      ),
    );}

    Widget secondContainer(){return Container(
      height: 100.0,
      margin: EdgeInsets.only(top:10.0, bottom: 20),
      child: Column(
        children:<Widget>[
          Text(
            "${dataU[0].nombre} ${dataU[0].apellido}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:20.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              "${dataS[0].descripcion}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:14.0,
                color: Colors.black,                              
              ),
            ),
          ),
        ]
      )
    );}

    Widget containerMap(BuildContext context){ return 
    Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      height: 350,
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(	double.parse(dataS[0].latitud), double.parse(dataS[0].longitud)),
                    zoom: 16,
                  ),
                  markers: Set<Marker>.of(
                    <Marker>[
                      Marker(
                        onTap: (){
                          print("PUNTO TOCADO");
                        },
                        markerId: MarkerId("fromPoint"),
                        position: LatLng(	double.parse(dataS[0].latitud), double.parse(dataS[0].longitud)),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: InfoWindow(title: "Ubicación"),
                        onDragEnd:null,
                        visible: true,
                      ),
                    ],
                  ),
                  onMapCreated: (GoogleMapController controller){
                    _mapController  = controller;
                  },
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ],
            ),
    );}

    Widget title(String text){return Container(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:20.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );}

    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Perfil del profesional", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return loading
                ?UtilityWidget.containerloadingIndicator(context)
                :Container(
                child: ListView(
                  children:<Widget>[
                    firstContainer(),
                    secondContainer(),
                    visibility ? containerMap(context) : Container(),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      child:Column(
                        children:<Widget>[
                          SizedBox(height:20),
                          title("Servicios brindados"),                          
                          SizedBox(height:10),
                          Text(
                            "${dataS[0].categoria}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:20.0,
                              color: Colors.yellow,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height:8),
                          Text(
                            "${dataS[0].subcategoria}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height:8),
                          Text(
                            dataS[0].precio == "0" ? "A convenir" : "${dataS[0].precio} soles",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height:8),
                          visibility5?Text(
                            "precio con descuento: ${precioo} soles",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ):Container(),
                          SizedBox(height:8),
                          dataS[0].dias != "0"?Text(
                            dataS[0].dias,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ):Container(),
                          dataS[0].dias != "0"?SizedBox(height:20):Container(),
                          dataS[0].horario != "0"?Text(
                            dataS[0].horario,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ):Container(), 
                          dataS[0].horario != "0"?SizedBox(height:20):Container(),                                                   
                        ]
                      ),
                    ),    
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      child:Column(
                        children:<Widget>[
                          SizedBox(height:20),
                          title("Modo de ofrecimiento de servicios"),
                          SizedBox(height:10),
                          dataS[0].opcionA != "0"?Text(
                            dataS[0].opcionA,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ):Container(),
                          SizedBox(height:8),
                          dataS[0].opcionB != "0" ?Text(
                            dataS[0].opcionB,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ):Container(),
                          SizedBox(height:8),
                          Text(
                            dataS[0].direccion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:17.0,
                              color: Colors.black54,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height:20),                                                                              
                        ]
                      ),
                    ),
                    visibilityGalery ? Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      child:Column(
                        children:<Widget>[
                          SizedBox(height:20),
                          title("Galería"),
                          SizedBox(height:10),
                          Container(
                            height: 300,
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:<Widget>[
                                SizedBox(width:40),
                                dataS[0].galeria1 != "0" ?Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: dataS[0].galeria1 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria1}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ):Container(),
                                SizedBox(width:20),
                                dataS[0].galeria2 != "0" ?Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: dataS[0].galeria2 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria2}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ):Container(),
                                SizedBox(width:20),
                                dataS[0].galeria3 != "0" ?Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: dataS[0].galeria3 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria3}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ):Container(),
                                SizedBox(width:30),
                              ],
                            ),
                          ),
                          SizedBox(height:15),                                                                             
                        ]
                      ),
                    ) : Container(),
                    visibility3?Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      //width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(
                        left: 70.0,
                        right: 70.0,
                        top:20,
                        bottom: 20,
                      ),
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 2,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.thumb_up, color: Colors.white,),
                                SizedBox(width: 8,),
                                Center(child: Text('RECOMENDAR',style: TextStyle(color: Colors.white)))
                              ],
                            ),
                          ),
                        ),
                        onPressed: (){
                          addReco();
                        },
                        color: warma,
                      ),
                    ):Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      //width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(
                        left: 70.0,
                        right: 70.0,
                        top:20,
                        bottom: 20,
                      ),
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 2,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.thumb_up, color: Colors.white,),
                                SizedBox(width: 8,),
                                Center(child: Text('RECOMENDAR',style: TextStyle(color: Colors.white)))
                              ],
                            ),
                          ),
                        ),
                        onPressed:null,
                        color: warma,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                      child:Column(
                        children:<Widget>[
                          SizedBox(height:20),
                          Container(
                            margin: EdgeInsets.only(
                              //top:20,
                              left: 65.0,
                              right: 65.0,
                            ),
                            child: RaisedButton(
                              shape: StadiumBorder(),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.work, color: Colors.white,),
                                      SizedBox(width: 8,),
                                      Center(child: Text('CONTRATAR',style: TextStyle(color: Colors.white)))
                                    ],
                                  ),
                                ),
                              ),
                              onPressed: (){
                                contrato();
                              },
                              color: Colors.blueAccent
                            ),
                          ),
                          SizedBox(height:20),                                                                             
                        ]
                      ),
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