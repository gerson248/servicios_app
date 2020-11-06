import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/ui/infoAdditional.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SnackBars.dart';
import 'UtilityWidgets.dart';



class Location extends StatefulWidget {
  Location({Key key,this.id}) : super(key: key);

  //final LatLng toPoint  = LatLng(-9.189967, -75.015152);
  final String id;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  GoogleMapController _mapController;
  //LatLng fromPoint  = LatLng(	-12.04318, -77.02824);

  List dataS;
  bool loading=true;

  TextEditingController controllerLatitud = new TextEditingController();
  TextEditingController controllerLongitud = new TextEditingController();

  Future _addData(BuildContext context) async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
      "email":localStorage.get("email"),
    });

    var dataId = json.decode(response1.body);

    if( 
      !controllerLatitud.text.isEmpty ||
      !controllerLatitud.text.isEmpty
    ){
      final response = await http.post("http://0.0.0.0/servicio/addUbicacion.php", body: {
        "latitud": controllerLatitud.text,
        "longitud": controllerLongitud.text,
        "id": widget.id,
      });
      Navigator.push(context,MaterialPageRoute(builder: (context) => InfoAdditional(id: widget.id,)));
    }else{
      SnackBars.showOrangeMessage(context, "Debe seleccionar un punto en el mapa (mover el amrcador)");
    }

  }

  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id":widget.id,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicacion de mi servicio"),
        backgroundColor: Color(0xFF32bcd1),
      ),
      body: Builder(
        builder: (BuildContext context){
          return loading
            ?UtilityWidget.containerloadingIndicator(context)
            :Container(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(	dataS[0].latitud == "0" ? -12.04318 : double.parse(dataS[0].latitud), dataS[0].longitud == "0" ? -77.02824 : double.parse(dataS[0].longitud)),
                    zoom: 11.5,
                  ),
                  markers: Set<Marker>.of(
                    <Marker>[
                      Marker(
                        onTap: (){
                          print("PUNTO TOCADO");
                        },
                        draggable: true,
                        markerId: MarkerId("fromPoint"),
                        position: LatLng(	dataS[0].latitud == "0" ? -12.04318 : double.parse(dataS[0].latitud), dataS[0].longitud == "0" ? -77.02824 : double.parse(dataS[0].longitud)),
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: InfoWindow(title: "Ubicación"),
                        onDragEnd: ((value){
                          controllerLatitud.text = value.latitude.toString();
                          controllerLongitud.text = value.longitude.toString();
                            print(controllerLatitud.text);
                            print(controllerLatitud.text);
                          }
                        ),
                      ),
                    ],
                  ),
                  onMapCreated: (GoogleMapController controller){
                    _mapController  = controller;
                  },
                  //onTap: _handleTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top:630.0,
                    right: 150.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: StadiumBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.save, color: Colors.white,),
                                    SizedBox(width: 8,),
                                    Text('Guardar ubicación',style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            onPressed: (){
                              _addData(context);
                            },
                            color: Color(0xFF32bcd1),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }

}
