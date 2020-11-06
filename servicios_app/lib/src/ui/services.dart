
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/models/venta.dart';
import 'package:servicios_app/src/ui/homePage.dart';
import 'package:servicios_app/src/ui/location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:servicios_app/src/ui/notificacionPage.dart';
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'SnackBars.dart';
import 'UtilityWidgets.dart';

class Services extends StatefulWidget {
  Services({Key key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {

  var selectedCurrency, selectedType;

  TextEditingController controllerCategory = new TextEditingController();
  TextEditingController controllerSubcategory = new TextEditingController();
  TextEditingController controllerCantidadSoles = new TextEditingController();
  TextEditingController controllerPorcentaje = new TextEditingController();
  TextEditingController controllerDirection = new TextEditingController();
  TextEditingController controllerDescription= new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerOpcionA= new TextEditingController();
  TextEditingController controllerOpcionB = new TextEditingController();
  TextEditingController controllerFechaCad = new TextEditingController();

  var category = "";
  var subcategory="";
  var precio = "";
  int mes=0;

  final picker = ImagePicker();

  File _image1;
  File _image2;
  File _image3;

  File _archiveFile;

  List _subcategory;

//addservicio

  List _category = [
    'AUTOS / TRANSPORTE',
    'TECNOLOGIA',
    'CLASES PARTICULARES',
    'DEPORTES',
    'ESTETICA',
    'EVENTOS',
    'HOGAR',
    'PETS',
  ];
  List _autos = ["Lavado de autos", "Mecánico", "Mensajería", "Remises / Combis / Fletes"];
  List _clases = ["Biología", "Ciencias Sociales","Dibujo técnico", "Física", "Francés", "Historia", "Ingles", "Italiano", "Lengua / Literatura", "Matematica", "Quimica", "Filosofía y Psicologia", "Geografía", "Portugués"];
  List _deporte = ["Crossfit", "Karate", "Kick Boxing", "Personal Trainer", "Pilates", "Tenis", "Boxeo", "Danza", "Golf", "Judo", "Kitesurf", "Natación", "Taekwondo"];
  List _estetica = ["Estilista", "Manicure", "Maquilladora", "Masajista", "Pedicure", "Podólogo", "Reiki", "YOGA"];
  List _eventos = ["Alquiler de inflables", "Barman", "Catering", "Cocinero", "Dj", "Fotógrafo", "Mesero", "Salón / Quinta", "Salones", "Seguridad", "Alquiler de vajillas", "Distribuidor de hielo", "Salones"];
  List _hogar = ["Carpintería", "Cerrajería", "Aire acondicionado", "Cuidador de niños / adultos", "Electricista", "Fumigación", "Gasista", "Herrero", "Jardinería", "Limpieza", "Pintor", "Piscinas", "Plomería / Destapaciones", "Remodelaciones /Construcciones", "Sistema de seguridad / Alarmas", "Técnico en heladeras", "Técnico en lavarropas", "Techista"];
  List _mascotas = ["Adiestrador", "Cuidador", "Estilista", "Paseador", "Veterinaria"];
  List _tecnologia = ["Técnico en computación", "Técnico en celulares", "Tecnico en televisores"];

  Future _saveService(BuildContext context) async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
      "email":localStorage.get("email"),
    });

    var dataId = json.decode(response1.body);

    final response2 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
      "idProfesionalUsuario":dataId[0]['id'],
    });

    var dataIdP = json.decode(response2.body);


    if( 
      controllerCategory.text.isEmpty ||
      controllerSubcategory.text.isEmpty ||
      controllerDirection.text.isEmpty ||
      controllerDescription.text.isEmpty 
    ){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos de servicio");
    }else{
      if(controllerDescription.text.length>200){
        SnackBars.showOrangeMessage(context, "La descripción supera los 200 caracteres");
      }else{
        if (controllerDirection.text.length>100) {
          SnackBars.showOrangeMessage(context, "La dirección supera los 100 caracteres");
        } else {
          //SnackBars.showOrangeMessage(context, "Paso");
          if (!controllerPrice.text.isEmpty) {
            if(!controllerPorcentaje.text.isEmpty && !controllerCantidadSoles.text.isEmpty){
              //print("2 campos llenos");
              SnackBars.showOrangeMessage(context, "Los campos de cantidad y porcentaje estan llenos");
            }else{
              if (controllerPorcentaje.text.isEmpty && controllerCantidadSoles.text.isEmpty) {
                //print("con precio");
                if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isEmpty) {
                      final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                        "categoria": controllerCategory.text, 
                        "subcategoria": controllerSubcategory.text,
                        "direccion": controllerDirection.text, 
                        "descripcion": controllerDescription.text,
                        "precio": controllerPrice.text,
                        "opcionA": controllerOpcionA.text,
                        "idServicioProfesional": dataIdP[0]['id'],
                      });
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));    
                } else {
                  if (controllerOpcionB.text.isNotEmpty && controllerOpcionA.text.isEmpty) {
                      final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                        "categoria": controllerCategory.text, 
                        "subcategoria": controllerSubcategory.text,
                        "direccion": controllerDirection.text, 
                        "descripcion": controllerDescription.text,
                        "precio": controllerPrice.text,
                        "opcionB": controllerOpcionB.text,
                        "idServicioProfesional": dataIdP[0]['id'],
                      });
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));     
                  } else {
                    if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isNotEmpty) {
                      final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                        "categoria": controllerCategory.text, 
                        "subcategoria": controllerSubcategory.text,
                        "direccion": controllerDirection.text, 
                        "descripcion": controllerDescription.text,
                        "precio": controllerPrice.text,
                        "opcionA": controllerOpcionA.text,
                        "opcionB": controllerOpcionB.text,
                        "idServicioProfesional": dataIdP[0]['id'],
                      });
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));     
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), opcionA: controllerOpcionA.text, opcionB: controllerOpcionB.text,)));
                    } else {
                        final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                          "categoria": controllerCategory.text, 
                          "subcategoria": controllerSubcategory.text,
                          "direccion": controllerDirection.text, 
                          "descripcion": controllerDescription.text,
                          "precio": controllerPrice.text,
                          "idServicioProfesional": dataIdP[0]['id'],
                        });
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));   
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text))));
                    }
                  }
                }
                //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text))));
              } else {
                if(controllerFechaCad.text.isNotEmpty){
                  if(controllerPorcentaje.text.isEmpty && double.parse(controllerCantidadSoles.text)<double.parse(controllerPrice.text)){
                    //print("Guardo con cantidad ");
                    //print(double.parse(controllerCantidadSoles.text));
                    if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isEmpty) {
                          final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                            "categoria": controllerCategory.text, 
                            "subcategoria": controllerSubcategory.text,
                            "direccion": controllerDirection.text, 
                            "descripcion": controllerDescription.text,
                            "precio": controllerPrice.text,
                            "cantidad": controllerCantidadSoles.text,
                            "opcionA": controllerOpcionA.text,
                            "fechaCad": controllerFechaCad.text,
                            "idServicioProfesional": dataIdP[0]['id'],
                          });
                          Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));  
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text), opcionA: controllerOpcionA.text)));
                    } else {
                      if (controllerOpcionB.text.isNotEmpty && controllerOpcionA.text.isEmpty) {
                          final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                            "categoria": controllerCategory.text, 
                            "subcategoria": controllerSubcategory.text,
                            "direccion": controllerDirection.text, 
                            "descripcion": controllerDescription.text,
                            "precio": controllerPrice.text,
                            "cantidad": controllerCantidadSoles.text,
                            "fechaCad": controllerFechaCad.text,
                            "opcionB": controllerOpcionB.text,
                            "idServicioProfesional": dataIdP[0]['id'],
                          });
                          Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));    
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text), opcionB: controllerOpcionB.text,)));
                      } else {
                        if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isNotEmpty) {
                            final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                              "categoria": controllerCategory.text, 
                              "subcategoria": controllerSubcategory.text,
                              "direccion": controllerDirection.text, 
                              "descripcion": controllerDescription.text,
                              "precio": controllerPrice.text,
                              "cantidad": controllerCantidadSoles.text,
                              "fechaCad": controllerFechaCad.text,
                              "opcionA": controllerOpcionA.text,
                              "opcionB": controllerOpcionB.text,
                              "idServicioProfesional": dataIdP[0]['id'],
                            });
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage())); 
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text), opcionA: controllerOpcionA.text, opcionB: controllerOpcionB.text,)));
                        } else {
                            final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                              "categoria": controllerCategory.text, 
                              "subcategoria": controllerSubcategory.text,
                              "direccion": controllerDirection.text, 
                              "descripcion": controllerDescription.text,
                              "precio": controllerPrice.text,
                              "fechaCad": controllerFechaCad.text,
                              "cantidad": controllerCantidadSoles.text,
                              "idServicioProfesional": dataIdP[0]['id'],
                            });
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));  
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text),)));
                        }
                      }
                    }
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text),)));
                  }else{
                    if (controllerCantidadSoles.text.isEmpty && double.parse(controllerPorcentaje.text)<100) {
                      //print("Guardo con porcentaje");
                     // print(controllerPorcentaje.text);  
                      if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isEmpty) {
                            final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                              "categoria": controllerCategory.text, 
                              "subcategoria": controllerSubcategory.text,
                              "direccion": controllerDirection.text, 
                              "descripcion": controllerDescription.text,
                              "precio": controllerPrice.text,
                              "porcentaje": controllerPorcentaje.text,
                              "opcionA": controllerOpcionA.text,
                              "fechaCad": controllerFechaCad.text,
                              "idServicioProfesional": dataIdP[0]['id'],
                            });
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage())); 
                        //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), porcentaje: double.parse(controllerPorcentaje.text), opcionA: controllerOpcionA.text)));
                      } else {
                        if (controllerOpcionB.text.isNotEmpty && controllerOpcionA.text.isEmpty) {
                            final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                              "categoria": controllerCategory.text, 
                              "subcategoria": controllerSubcategory.text,
                              "direccion": controllerDirection.text, 
                              "descripcion": controllerDescription.text,
                              "precio": controllerPrice.text,
                              "porcentaje": controllerPorcentaje.text,
                              "opcionB": controllerOpcionB.text,
                              "fechaCad": controllerFechaCad.text,
                              "idServicioProfesional": dataIdP[0]['id'],
                            });
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));   
                          //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), porcentaje: double.parse(controllerPorcentaje.text), opcionB: controllerOpcionB.text,)));
                        } else {
                          if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isNotEmpty) {
                            //print("PASANDO");
                              final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                                "categoria": controllerCategory.text, 
                                "subcategoria": controllerSubcategory.text,
                                "direccion": controllerDirection.text, 
                                "descripcion": controllerDescription.text,
                                "precio": controllerPrice.text,
                                "porcentaje": controllerPorcentaje.text,
                                "opcionA": controllerOpcionA.text,
                                "opcionB": controllerOpcionB.text,
                                "fechaCad": controllerFechaCad.text,
                                "idServicioProfesional": dataIdP[0]['id'],
                              });
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));   
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), porcentaje: double.parse(controllerPorcentaje.text), opcionA: controllerOpcionA.text, opcionB: controllerOpcionB.text,)));
                          } else {
                              final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                                "categoria": controllerCategory.text, 
                                "subcategoria": controllerSubcategory.text,
                                "direccion": controllerDirection.text, 
                                "descripcion": controllerDescription.text,
                                "precio": controllerPrice.text,
                                "porcentaje": controllerPorcentaje.text,
                                "fechaCad": controllerFechaCad.text,
                                "idServicioProfesional": dataIdP[0]['id'],
                              });
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));    
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), porcentaje: double.parse(controllerPorcentaje.text),)));
                          }
                        }
                      }
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), porcentaje: double.parse(controllerPorcentaje.text),)));                  
                    } else {
                      SnackBars.showOrangeMessage(context, "Uno de los campos de descuento supero el limite");
                    }
                  }
                }else{
                  SnackBars.showOrangeMessage(context, "Ingresar fecha de caducidad valida");
                }

              }
            }
          } else {
            if (!controllerPorcentaje.text.isEmpty || !controllerCantidadSoles.text.isEmpty) {
              SnackBars.showOrangeMessage(context, "Estas agregando un descuento y no haz fijado un precio");
            } else {
              //print("sin precio");
              if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isEmpty) {
                        final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                          "categoria": controllerCategory.text, 
                          "subcategoria": controllerSubcategory.text,
                          "direccion": controllerDirection.text, 
                          "descripcion": controllerDescription.text,
                          "opcionA": controllerOpcionA.text,
                          "idServicioProfesional": dataIdP[0]['id'],
                        });
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));      
                //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, opcionA: controllerOpcionA.text)));
              } else {
                if (controllerOpcionB.text.isNotEmpty && controllerOpcionA.text.isEmpty) {
                        final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                          "categoria": controllerCategory.text, 
                          "subcategoria": controllerSubcategory.text,
                          "direccion": controllerDirection.text, 
                          "descripcion": controllerDescription.text,
                          "opcionB": controllerOpcionB.text,
                          "idServicioProfesional": dataIdP[0]['id'],
                        });
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage())); 
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, opcionB: controllerOpcionB.text,)));
                } else {
                  if (controllerOpcionA.text.isNotEmpty && controllerOpcionB.text.isNotEmpty) {
                        final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                          "categoria": controllerCategory.text, 
                          "subcategoria": controllerSubcategory.text,
                          "direccion": controllerDirection.text, 
                          "descripcion": controllerDescription.text,
                          "opcionA": controllerOpcionA.text,
                          "opcionB": controllerOpcionB.text,
                          "idServicioProfesional": dataIdP[0]['id'],
                        });
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));   
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, opcionA: controllerOpcionA.text, opcionB: controllerOpcionB.text,)));
                  } else {
                        final response = await http.post("http://0.0.0.0/servicio/addservicio.php", body: {
                          "categoria": controllerCategory.text, 
                          "subcategoria": controllerSubcategory.text,
                          "direccion": controllerDirection.text, 
                          "descripcion": controllerDescription.text,
                          "idServicioProfesional": dataIdP[0]['id'],
                        });
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));      
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text,)));
                  }
                }
              }
              //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text,)));
            }
            
          }
        }
      }
    }
  }


  bool _isCheckedA = false;
  bool _isCheckedB = false;

  void onChangedA(bool value){
    setState(() {
      _isCheckedA = value;
      if (_isCheckedA==true) {
        controllerOpcionA.text="Voy a domicilio";
      } else {
        controllerOpcionA=new TextEditingController();
      }
      //print(controllerOpcionA.text.isEmpty ? "null" : controllerOpcionA.text);
      //print(_isCheckedA);
    });
  }

  void onChangedB(bool value){
    setState(() {
      _isCheckedB = value;
      if (_isCheckedB==true) {
        controllerOpcionB.text="En mi domicilio";
      } else {
        controllerOpcionB=new TextEditingController();
      }
     // print(controllerOpcionB.text.isEmpty ? "null": controllerOpcionB.text);
     // print(_isCheckedB);
    });
  }
  
  List dataU2;
  List dataV2;
  bool loading=true;

  Future getData() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    dataU2=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

    //print(dataU2[0].id.toString());
    final response1 = await http.post("http://0.0.0.0/servicio/showVentaPend.php", body: {
      "idUsuarioProfesional":dataU2[0].id.toString(),
    });

    dataV2=(json.decode(response1.body) as List).map((e) => Venta.fromJson(e)).toList();

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

    final title_service = Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Servicio",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
        ),
      ),
    );

    final dropDownCategory = Row(
      children: [
        Container(
          margin: EdgeInsets.only(left:15.0),
          child: Icon(Icons.category_sharp, color:Colors.black45),
          ),
        Padding(
          padding: const EdgeInsets.only(top:10.0, left: 5.0),
          child: Text(
              category == ""
                ? "Categoria*"
                : category,
              style: TextStyle(color: Colors.black54, fontSize: 17),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right:20.0),
          child: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: Colors.black45,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.38,                        
                        child: ListView(
                          children: <Widget>[
                        ListView.builder(
                          itemCount: _category.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i){
                            return Center(
                              child: Container(
                                height: 20.0,
                                margin: EdgeInsets.only(top:15.0),
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      category=_category[i];
                                      controllerCategory.text=_category[i];
                                      //print(category);
                                      subcategory="";
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(
                                    _category[i],
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
          ),
        )
      ],
    );

    final dropDownSubCategory = Row(
      children: [
        Container(
          margin: EdgeInsets.only(left:15.0),
          child: Icon(Icons.category_sharp, color:Colors.black45),
          ),
        Padding(
          padding: const EdgeInsets.only(top:10.0, left: 5.0),
          child: Text(
              subcategory == ""
                ? "Subcategoria*"
                : subcategory,
              style: TextStyle(color: Colors.black54, fontSize: 17),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right:20.0),
          child: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: Colors.black45,),
              onPressed: () {
                //print("hola");
               // print(category);
                if (category==_category[0]) {
                  _subcategory=_autos;
                } else {
                  if (category==_category[1]) {
                    _subcategory=_tecnologia;
                  } else {
                    if (category==_category[2]) {
                      _subcategory=_clases;
                    } else {
                      if (category==_category[3]) {
                        _subcategory=_deporte;
                      } else {
                        if (category==_category[4]) {
                          _subcategory=_estetica;
                        } else {
                          if (category==_category[5]) {
                            _subcategory=_eventos;
                          } else {
                            if (category==_category[6]) {
                              _subcategory=_hogar;
                            } else {
                              if (category==_category[7]) {
                                _subcategory=_mascotas;
                              } else {
                                _subcategory=[];
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                };
                showDialog(
                  context: context,
                  builder: (context){
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Container(
                        //margin: EdgeInsets.only(top:20.0),
                        height: MediaQuery.of(context).size.height*0.25,
                        child: ListView(
                          children:<Widget>[
                            ListView.builder(
                              itemCount: _subcategory.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i){
                                return Center(
                                  child: Container(
                                    height: 20.0,
                                    margin: EdgeInsets.only(top:15.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          subcategory=_subcategory[i];
                                          controllerSubcategory.text=_subcategory[i];
                                         // print(subcategory);
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        _subcategory[i],
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20.0,),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
          ),
        )
      ],
    );

    final location = Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(Icons.location_city),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Dirección*',
            labelText: 'Dirección*',
            /*suffixIcon: IconButton(
              icon: Icon(Icons.location_on),
              onPressed:(){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Location()));
              },
            )*/
          ),
          keyboardType: TextInputType.text,
          controller: controllerDirection,
        ),
      ),
    );

    final description = Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Descripción del servicio*',
            labelText: 'Descripción del servicio*'
          ),
          keyboardType: TextInputType.text,
          controller: controllerDescription,
        ),
      ),
    );



    var price = Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Precio',
            labelText: 'Precio (Opcional)'
          ),
          keyboardType: TextInputType.number,
          controller: controllerPrice,
        ),
      ),
    );

    final title_ofert = Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Descuento (Opcional)",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
        ),
      ),
    );


    final fechaCad = Container(
      padding: EdgeInsets.all(8.0),
      height: 120,
      child: CupertinoDatePicker( 
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (DateTime newDateTime) {
         // print(DateTime.now().year);
         // print("${newDateTime.year}-${newDateTime.month}-${newDateTime.day}");
          //controllerFechaCad.text="${newDateTime.year}-${newDateTime.month}-${newDateTime.day}";
          
          if(newDateTime.year==DateTime.now().year){
            if(DateTime.now().month<=9){
              if((newDateTime.month-DateTime.now().month)<4 && (newDateTime.month-DateTime.now().month)>=0){
                controllerFechaCad.text="${newDateTime}";              
              }else{
                controllerFechaCad=TextEditingController();
              }
            }else{
              if(DateTime.now().month==10){
                if((newDateTime.month-DateTime.now().month)<3 && (newDateTime.month-DateTime.now().month)>=0){
                  controllerFechaCad.text="${newDateTime}";
                }else{
                  controllerFechaCad=TextEditingController();
                }
              }else{
                if(DateTime.now().month==11){
                  if((newDateTime.month-DateTime.now().month)<2 && (newDateTime.month-DateTime.now().month)>=0){
                    controllerFechaCad.text="${newDateTime}";
                  }else{
                    controllerFechaCad=TextEditingController();
                  }
                }else{
                  if(DateTime.now().month==12){
                    if((newDateTime.month-DateTime.now().month)==0 && (newDateTime.month-DateTime.now().month)>=0){
                      controllerFechaCad.text="${newDateTime}";
                    }else{
                      controllerFechaCad=TextEditingController();
                    }
                  }
                }
              }
            }
          }else{
            if(newDateTime.year==DateTime.now().year+1 && DateTime.now().month>10){
              if(DateTime.now().month==10){
                if((DateTime.now().month-newDateTime.month)==9){
                  controllerFechaCad.text="${newDateTime}";
                }else{
                  controllerFechaCad=TextEditingController();
                }
              }else{
                if(DateTime.now().month==11){
                  if((DateTime.now().month-newDateTime.month)==10 || (newDateTime.month-DateTime.now().month)==9){
                    controllerFechaCad.text="${newDateTime}";
                  }else{
                    controllerFechaCad=TextEditingController();
                  }
                }else{
                  if(DateTime.now().month==12){
                    if((DateTime.now().month-newDateTime.month)==9 || (DateTime.now().month-newDateTime.month)==10 || (DateTime.now().month-newDateTime.month)==11 ){
                      controllerFechaCad.text="${newDateTime}";
                    }else{
                      controllerFechaCad=TextEditingController();
                    }
                  }
                }
              }
            }else{
              controllerFechaCad=TextEditingController();
            }
          }
        },             
      ),
    );

    final ofert = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              autocorrect: false,
              //autofocus: true,
              keyboardType: TextInputType.number,
              //keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              //style: TextStyle(color:Colors.red),
              //style: blackText(),
              //initialValue: initial,
              cursorColor: Colors.black,
              cursorRadius: Radius.circular(16),
              cursorWidth: 4.0,
              controller: controllerCantidadSoles,
              decoration: InputDecoration(
                  hintText: "Cantidad Soles",
                  labelText: "Cantidad Soles",
                  //hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                  fillColor: Colors.white,
              ),
              validator: (value) {
                return value.isEmpty?"incompleto":value;
              }),
          ),
        ),

        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              autocorrect: false,
              //autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              //style: blackText(),
              //initialValue: initial,
              cursorColor: Colors.black,
              cursorRadius: Radius.circular(16),
              cursorWidth: 4.0,
              controller: controllerPorcentaje,
              decoration: InputDecoration(
                  hintText: "Porcentaje %",
                  labelText: "Porcentaje %",
                  //hintStyle: greyText(),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white
              ),
              validator: (value) {
                return value.isEmpty?"incompleto":value;
              }),
          ),
        ),
      ],
    );

    final saveOfert = Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          RaisedButton(
            shape: StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Calcular',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            onPressed: () {
              setState(() {
                precio=controllerPrice.text;
                if(!controllerCantidadSoles.text.isEmpty){
                  precio= (double.parse(controllerPrice.text) - double.parse(controllerCantidadSoles.text)).toString();
                  //controllerCantidadSoles = new TextEditingController();
                }else{
                 // print("dasdas");
                  if(!controllerPorcentaje.text.isEmpty){
                    precio= (((100.0 - double.parse(controllerPorcentaje.text)) * double.parse(controllerPrice.text))/100).toString();
                    //controllerPorcentaje = new TextEditingController();
                  }
                }
                print(precio);
                //Navigator.pop(context);
              });
            },
            color: Color(0xFF32bcd1),
          ),
          SizedBox(width:20.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              precio == "" ? "Precio Total: " : "Precio Total: $precio",
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
          ),
        ]
      )
    );



    return Builder(
      builder: (BuildContext context){
        return loading
          ?UtilityWidget.containerloadingIndicator(context)
          :Scaffold(
          appBar: AppBar(
            title: Text("Mis servicios", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
            backgroundColor: Color(0xFF32bcd1),
            actions: <Widget>[
              IconButton(icon: Icon(dataV2.length>0?Icons.notifications_active:Icons.notifications), onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => NotificacionPage()));
              })
            ],
          ),
          body: Builder(
            builder: (BuildContext context){
              return Container(
                child: ListView(
                  children:<Widget>[
                  Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          title_service,
                          SizedBox(height:20.0),                    
                          dropDownCategory,
                          dropDownSubCategory,
                          location,
                          Padding(
                            padding: const EdgeInsets.only(left:60.0),
                            child: Row(
                              children:<Widget>[
                                Checkbox(
                                  value: _isCheckedA, 
                                  onChanged: (bool value){onChangedA(value);}
                                ),
                                Text(
                                  "Voy a domicilio",
                                  style: TextStyle(color: Colors.black54, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:60.0),
                            child: Row(
                              children:<Widget>[
                                Checkbox(
                                  value: _isCheckedB, 
                                  onChanged: (bool value){onChangedB(value);}
                                ),
                                Text(
                                  "En mi domicilio",
                                  style: TextStyle(color: Colors.black54, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          //location,
                          description,
                          price,
                          //file,
                          //saveService,
                          SizedBox(height:10.0), 
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Nota: Debe escoger una categoria para mostrar las subcategorias",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height:10.0),  
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          title_ofert,
                          SizedBox(height:20.0),
                          ofert,
                          saveOfert,
                          /*Center(child: Text("Fecha de caducidad", style:TextStyle(fontSize:20.0, color:Colors.black, fontWeight: FontWeight.w400)),),
                          SizedBox(height:10.0),
                          fechaCad,*/
                          SizedBox(height: 20.0,),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Nota: La cantidad no debe superar al precio y el porcentaje no debe superar al 100% (Solo llenar uno de los 2 campos)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          Center(child: Text("Fecha de caducidad", style:TextStyle(fontSize:22.0, color:Colors.black, fontWeight: FontWeight.w700)),),
                          SizedBox(height:10.0),
                          fechaCad,
                          //saveOfert,
                          SizedBox(height:40.0),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Nota: La fecha de caducidad no debe ser mayor a 3 meses",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height:30.0),
                        ],
                      ),
                    ),               
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    RaisedButton(
                                      shape: StadiumBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.save, color: Colors.white,),
                                              SizedBox(width: 8,),
                                              Text('Agregar Servicio',style: TextStyle(color: Colors.white))
                                            ],
                                          ),
                                        ),
                                      ),
                                      onPressed:(){
                                        _saveService(context);
                                      },
                                      //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                                      color: Color(0xFF32bcd1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Nota: Se guardara el servicio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ),
                  ]
                ),
                
              );
            }
          
          ),
        );
      }
    );
  }
}