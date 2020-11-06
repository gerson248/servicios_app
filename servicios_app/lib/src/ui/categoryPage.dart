import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/gps.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/ui/about.dart';
import 'package:servicios_app/src/ui/favourite.dart';
import 'package:servicios_app/src/ui/review.dart';
import 'package:servicios_app/src/ui/serviceContractPage.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:servicios_app/src/ui/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locate/locate.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:convert';
import 'package:location/location.dart';

import 'UtilityWidgets.dart';
class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  List<Servicio> _notes = List<Servicio>();
  List<Servicio> _notesForDisplay = List<Servicio>();

  List dataU;
  List dataS;

  Location location = new Location();
  //LocationData _locationData;
  LocationData myLocation;
  String error;

  bool loading=true;
  bool loading2=true;
  bool visibility=true;
  bool _folded = true;
  bool value=true;

  double latitud=0;
  double longitud=0;


  List _autos = ["Lavado de autos", "Mecánico", "Mensajería", "Remises / Combis / Fletes"];
  List _clases = ["Biología", "Ciencias Sociales","Dibujo técnico", "Física", "Francés", "Historia", "Ingles", "Italiano", "Lengua / Literatura", "Matematica", "Quimica", "Filosofía y Psicologia", "Geografía", "Portugués"];
  List _deporte = ["Crossfit", "Karate", "Kick Boxing", "Personal Trainer", "Pilates", "Tenis", "Boxeo", "Danza", "Golf", "Judo", "Kitesurf", "Natación", "Taekwondo"];
  List _estetica = ["Estilista", "Manicure", "Maquilladora", "Masajista", "Pedicure", "Podólogo", "Reiki", "YOGA"];
  List _eventos = ["Alquiler de inflables", "Barman", "Catering", "Cocinero", "Dj", "Fotógrafo", "Mesero", "Salón / Quinta", "Salones", "Seguridad", "Alquiler de vajillas", "Distribuidor de hielo", "Salones"];
  List _hogar = ["Carpintería", "Cerrajería", "Climatizacion / Aire acondicionado", "Cuidador de niños / adultos", "Electricista", "Fumigación", "Gasista", "Herrero", "Jardinería", "Limpieza", "Pintor", "Piscinas", "Plomería / Destapaciones", "Remodelaciones /Construcciones", "Sistema de seguridad / Alarmas", "Técnico en heladeras", "Técnico en lavarropas", "Techista"];
  List _mascotas = ["Adiestrador", "Cuidador", "Estilista", "Paseador", "Veterinaria"];
  List _tecnologia = ["Técnico en computación", "Técnico en celulares", "Tecnico en televisores"];
  
  Future<List<Servicio>> getData() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    
    /*var _locate = Locate();

    _locate.requestLocationPermission().then((bool result) {
    if (result){
      // we're good to go
    }
    else{
      // let user know it's required
    }
      
    });*/
    //myLocation = await location.getLocation();

    /*print("go");
    try {
      myLocation = await location.getLocation();
      print(myLocation);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }

    if(myLocation!=null){
      latitud=myLocation.latitude;
      longitud=myLocation.longitude;      
    }*/

    var latlng = await Gps.currentGps();
    if (latlng!=null){
      latitud=double.parse(latlng.lat);
      longitud=double.parse(latlng.lng);
    }
    localStorage.setDouble("latitud", latitud);
    localStorage.setDouble('longitud', longitud);
    
    /*latitud=localStorage.getDouble("latitud");
    longitud=localStorage.getDouble("longitud");*/
    
    final response = await http.post("http://0.0.0.0/servicio/getAllService.php", body: {
      "n": "n",
    });
    dataS =(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();
    if(localStorage.get("email")!=null){
      final response1 = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
          "email":localStorage.get("email"),
      });

      dataU=(json.decode(response1.body) as List).map((e) => Usuario.fromJson(e)).toList();

    }else{
      setState(() {
        value=false;
      });
    }
        
    setState(() {
      loading=false;
    });

    return dataS;


  }
  Future _Logout( ) async{
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }


  _listItem(index) {
    return Review(id:_notesForDisplay[index].id,idServicioProfesional: _notesForDisplay[index].idServicioProfesional,stars: 4, coment:_notesForDisplay[index].descripcion, precio:_notesForDisplay[index].precio,latitud: latitud,longitud: longitud,max:0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget search(){
      return  AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: _folded ? 50 : 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: kElevationToShadow[6],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: !_folded
                    ? TextField(
                        decoration: InputDecoration(
                            hintText: 'Buscar...',
                            hintStyle: TextStyle(color: Colors.blue[300]),
                            border: InputBorder.none
                        ),
                      onChanged: (text) {
                        text = text.toLowerCase();
                        setState(() {
                          _notesForDisplay = _notes.where((dataS) {
                            var noteTitle = dataS.descripcion.toLowerCase();
                            return noteTitle.contains(text);
                          }).toList();
                        });
                      },
                    )
                    : null,
              ),
            ),
            Container(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_folded ? 32 : 0),
                    topRight: Radius.circular(32),
                    bottomLeft: Radius.circular(_folded ? 32 : 0),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      _folded ? Icons.search : Icons.close,
                      color: Colors.blue[900],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _folded = !_folded;
                      if(visibility==true){
                        visibility = false;
                      }else{
                        visibility = true;
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      );
    }

    return Builder(
      builder: (context) {
        return loading
                ?UtilityWidget.containerloadingIndicator(context)
              :Scaffold(
          appBar: AppBar(
            title: Align(alignment: Alignment.center,child: Text("Categorías",style: TextStyle(color:Color(0xff392850), fontSize: 25), textAlign: TextAlign.center,)),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          drawer: Drawer(
            child:Container(
              decoration: BoxDecoration(color:Colors.white),
              child: ListView(
                children:<Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(value==false?"........":"${dataU[0].nombre} ${dataU[0].apellido}"),
                    accountEmail: Text(value==false?"........":"${dataU[0].email}"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: value == false ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataU[0].foto}"),
                    ),
                  ),
                  value?Container():ListTile(
                    title: Text("Registrarme / Iniciar sesión"),
                    leading: Icon(Icons.login),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SingUpScreenPage()));
                    },
                  ),
                  value?ListTile(
                    title: Text("Servicios contratados"),
                    leading: Icon(Icons.history_sharp),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ServiceContractPage()));
                    },
                  ):Container(),                  
                  value?ListTile(
                    title: Text("Favoritos"),
                    leading: Icon(Icons.star),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Favourite()));
                    },
                  ):Container(),
                  ListTile(
                    title: Text("Acerca de ..."),
                    leading: Icon(Icons.error_outline),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => About()));
                    },
                  ),
                  value?ListTile(
                    title: Text("Salir"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){
                      _Logout();
                    },
                  ):Container(),
                ]
              ),
            ),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height:8),
                    visibility ? ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        search(),
                        MyMenu(category: "AUTOS / TRANSPORTE", icon: Icons.directions_car, warna: Colors.yellow, namecategory: "transporte", image: "assets/images/mecanico.png", categories: _autos,),
                        MyMenu(category: "TECNOLOGIA", icon: Icons.computer, warna: Colors.blueGrey, namecategory: "tecnologia", image: "assets/images/hardware.png", categories: _tecnologia,),
                        MyMenu(category: "CLASES PARTICULARES", icon: Icons.class_, warna: Colors.blue, namecategory: "clase", image: "assets/images/student.png", categories: _clases,),
                        MyMenu(category: "DEPORTES", icon: Icons.golf_course, warna: Colors.green, namecategory: "deporte", image: "assets/images/deporte.png", categories: _deporte,),
                        MyMenu(category: "ESTETICA", icon: Icons.spa, warna: Colors.pink, namecategory: "estetica", image: "assets/images/spa.png", categories: _estetica,),
                        MyMenu(category: "EVENTOS", icon: Icons.surround_sound, warna: Colors.orange, namecategory: "evento", image: "assets/images/evento.png", categories: _eventos,),
                        MyMenu(category: "HOGAR", icon: Icons.home, warna: Colors.purple, namecategory: "hogar", image: "assets/images/casa.png",categories: _hogar,),
                        MyMenu(category: "PETS", icon: Icons.pets, warna: Colors.brown, namecategory: "pets", image: "assets/images/pets.png", categories: _mascotas,),
                      ],
                    ):ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return index == 0 ? search() : _listItem(index-1);
                      },
                      itemCount: _notesForDisplay.length+1,
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

class MyMenu extends StatelessWidget {
  MyMenu({this.category, this.icon, this.warna, this.namecategory, this.image, this.categories});

  final String category;
  final IconData icon;
  final MaterialColor warna;
  final String namecategory;
  final String image;
  final List categories;
  @override
  Widget build(BuildContext context) {
    return  Card(
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0),),
              margin: EdgeInsets.all(6.0),
              child: InkWell(
                //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Categoryy(category: category, namecategory: namecategory, images: image))),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Subcategory(category: category, namecategory: namecategory, images: image, categories: categories))),
                splashColor: warna,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(icon, size: 70.0,color: warna,),
                      Text(category)
                    ],
                  ),
                ),
              ),
            );
  }
}