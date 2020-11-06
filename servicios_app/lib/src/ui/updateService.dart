
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:servicios_app/src/ui/location.dart';
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;
import 'package:servicios_app/src/ui/notificacionPage.dart';
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;
import 'SnackBars.dart';
import 'UtilityWidgets.dart';

class UpdateService extends StatefulWidget {
  UpdateService({Key key, this.id}) : super(key: key);
  String id;
  @override
  _UpdateServiceState createState() => _UpdateServiceState();
}

class _UpdateServiceState extends State<UpdateService> {

  var selectedCurrency, selectedType;

  var category = "";
  var subcategory="";
  var precio = "";
  int mes=0;


  File _archiveFile;

  List _subcategory;
  DateTime _dateTime;

  List dataS;
  bool loading=true;

  TextEditingController controllerCategory = new TextEditingController();
  TextEditingController controllerSubcategory = new TextEditingController();
  TextEditingController controllerCantidadSoles;
  TextEditingController controllerPorcentaje;
  TextEditingController controllerDirection;
  TextEditingController controllerDescription;
  TextEditingController controllerPrice;
  TextEditingController controllerOpcionA;
  TextEditingController controllerOpcionB;
  TextEditingController controllerFechaCad = new TextEditingController();

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
                final response = await http.post("http://0.0.0.0/servicio/updateService.php", body: {
                  "categoria": controllerCategory.text, 
                  "subcategoria": controllerSubcategory.text,
                  "direccion": controllerDirection.text, 
                  "descripcion": controllerDescription.text,
                  "precio": controllerPrice.text,
                  "opcionA": controllerOpcionA.text,
                  "opcionB": controllerOpcionB.text,
                  "id": widget.id,
                });
                Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));  
                //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text))));
              } else {
                if(controllerFechaCad.text.isNotEmpty){
                  if(controllerPorcentaje.text.isEmpty && double.parse(controllerCantidadSoles.text)<double.parse(controllerPrice.text)){
                   // print("Guardo con cantidad ");
                    //print(double.parse(controllerCantidadSoles.text));
                    final response = await http.post("http://0.0.0.0/servicio/updateService.php", body: {
                      "categoria": controllerCategory.text, 
                      "subcategoria": controllerSubcategory.text,
                      "direccion": controllerDirection.text, 
                      "descripcion": controllerDescription.text,
                      "precio": controllerPrice.text,
                      "cantidad": controllerCantidadSoles.text,
                      "fechaCad": controllerFechaCad.text,
                      "opcionA": controllerOpcionA.text,
                      "opcionB": controllerOpcionB.text,
                      "id": widget.id,
                    });
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage())); 
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => Location(category: controllerCategory.text, subcategory: controllerSubcategory.text, direction: controllerDirection.text, description: controllerDescription.text, price: double.parse(controllerPrice.text), cantidad: double.parse(controllerCantidadSoles.text),)));
                  }else{
                    if (controllerCantidadSoles.text.isEmpty && double.parse(controllerPorcentaje.text)<100) {
                     // print("Guardo con porcentaje");
                      //print(controllerPorcentaje.text);  
                      final response = await http.post("http://0.0.0.0/servicio/updateService.php", body: {
                        "categoria": controllerCategory.text, 
                        "subcategoria": controllerSubcategory.text,
                        "direccion": controllerDirection.text, 
                        "descripcion": controllerDescription.text,
                        "precio": controllerPrice.text,
                        "porcentaje": controllerPorcentaje.text,
                        "opcionA": controllerOpcionA.text,
                        "opcionB": controllerOpcionB.text,
                        "fechaCad": controllerFechaCad.text,
                        "id": widget.id,
                      });
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));  
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
             // print("sin precio"); 
              final response = await http.post("http://0.0.0.0/servicio/updateService.php", body: {
                "categoria": controllerCategory.text, 
                "subcategoria": controllerSubcategory.text,
                "direccion": controllerDirection.text, 
                "descripcion": controllerDescription.text,
                "opcionA": controllerOpcionA.text,
                "opcionB": controllerOpcionB.text,
                "id": widget.id,
              });
              Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()));  
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
        controllerOpcionA.text="0";
      }
     // print(controllerOpcionA.text.isEmpty ? "null" : controllerOpcionA.text);
      //print(_isCheckedA);
    });
  }

  void onChangedB(bool value){
    setState(() {
      _isCheckedB = value;
      if (_isCheckedB==true) {
        controllerOpcionB.text="En mi domicilio";
      } else {
        controllerOpcionB.text="0";
      }
      //print(controllerOpcionB.text.isEmpty ? "null": controllerOpcionB.text);
     // print(_isCheckedB);
    });
  }

  Future getData() async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id":widget.id,
    });

    dataS=(json.decode(response.body) as List).map((e) => Servicio.fromJson(e)).toList();

    controllerDirection = TextEditingController(text: "${dataS[0].direccion}");
    controllerCantidadSoles = TextEditingController(text: dataS[0].cantidad == "0" ? null : dataS[0].cantidad);
    controllerPorcentaje= TextEditingController(text: dataS[0].porcentaje == "0" ? null : dataS[0].porcentaje);
    controllerDescription= TextEditingController(text: "${dataS[0].descripcion}");
    controllerPrice= TextEditingController(text: dataS[0].precio == "0" ? null : dataS[0].precio);
    controllerOpcionA = TextEditingController(text: "${dataS[0].opcionA}");
    controllerOpcionB = TextEditingController(text: "${dataS[0].opcionB}");

    setState(() {
      loading=false;
      _isCheckedA = dataS[0].opcionA == "0" ? false : true;
      _isCheckedB = dataS[0].opcionB == "0" ? false : true;
      category = dataS[0].categoria;
      controllerCategory.text = dataS[0].categoria;
      subcategory = dataS[0].subcategoria;
      controllerSubcategory.text = dataS[0].subcategoria;
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

    Widget title_service(){return Container(
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
    );}

    Widget dropDownCategory(){return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left:15.0),
          child: Icon(Icons.category_sharp, color:Colors.black45),
          ),
        Padding(
          padding: const EdgeInsets.only(top:10.0, left: 5.0),
          child: Text(
              category == ""
                ? dataS[0].categoria
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
    );}

    Widget dropDownSubCategory(){ return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left:15.0),
          child: Icon(Icons.category_sharp, color:Colors.black45),
          ),
        Padding(
          padding: const EdgeInsets.only(top:10.0, left: 5.0),
          child: Text(
              subcategory == ""
                ? dataS[0].subcategoria
                : subcategory,
              style: TextStyle(color: Colors.black54, fontSize: 17),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right:20.0),
          child: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: Colors.black45,),
              onPressed: () {
               // print("hola");
                //print(category);
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
    );}

    Widget location(){ return Padding(
      padding: const EdgeInsets.only(right:0.0),
      child: ListTile(
        leading: const Icon(Icons.location_city),
        title: TextField(
          //initialValue: dataS[0].direccion,
          decoration: InputDecoration(
            hintText: 'Dirección*',
          ),
          keyboardType: TextInputType.text,
          controller: controllerDirection,
        ),
      ),
    );}

    Widget description(){return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(Icons.description),
        title: TextField(
          //initialValue: dataS[0].descripcion,
          decoration: InputDecoration(
            hintText: 'Descripción del servicio*',
          ),
          keyboardType: TextInputType.text,
          controller: controllerDescription,
        ),
      ),
    );}



    Widget price(){return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: TextField(
          //initialValue: dataS[0].precio == null ? "" : dataS[0].precio,
          decoration: InputDecoration(
            hintText: 'Precio',
            labelText: 'Precio (Opcional)'
          ),
          keyboardType: TextInputType.number,
          controller: controllerPrice,
        ),
      ),
    );}

    Widget title_ofert(){return Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Descuento (Opcional) - Oferta",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );}


    Widget fechaCad(){return Container(
      padding: EdgeInsets.all(8.0),
      height: 120,
      child: CupertinoDatePicker( 
        mode: CupertinoDatePickerMode.date,
        //initialDateTime: dataS[0].fechaCad,
        initialDateTime: dataS[0].fechaCad == "" ? DateTime.now() : DateTime.parse(dataS[0].fechaCad),
        onDateTimeChanged: (DateTime newDateTime) {
          //print(DateTime.now().year);
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
    );}

    Widget ofert(){ return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              autocorrect: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              cursorColor: Colors.black,
              cursorRadius: Radius.circular(16),
              cursorWidth: 4.0,
              controller: controllerCantidadSoles,
              decoration: InputDecoration(
                  hintText: "Cantidad Soles",
                  labelText: "Cantidad Soles",
                  border: OutlineInputBorder( borderSide: BorderSide(color:Colors.yellow)),
                  fillColor: Colors.white,
              ),
              ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              autocorrect: false,
              //autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              //style: blackText(),
              //initialValue: dataS[0].porcentaje == null ? "" : dataS[0].porcentaje,
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
              /*validator: (value) {
                return value.isEmpty?"incompleto":value;
              }*/
              ),
          ),
        ),
      ],
    );}

    Widget saveOfert(){ return Padding(
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
                //print(precio);
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
    );}

    return Builder( 
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text("Mis servicios", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
            backgroundColor: Color(0xFF32bcd1),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.notifications), onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => NotificacionPage()));
              })
            ],
          ),
          body: Builder(
            builder: (BuildContext context){
              return loading
            ?UtilityWidget.containerloadingIndicator(context)
            :Container(
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
                          title_service(),
                          SizedBox(height:20.0),                    
                          dropDownCategory(),
                          dropDownSubCategory(),
                          location(),
                          Padding(
                            padding: const EdgeInsets.only(left:60.0),
                            child: Row(
                              children:<Widget>[
                                Checkbox(
                                  value: _isCheckedA, 
                                  onChanged: (bool value){
                                    onChangedA(value);
                                  }
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
                                  onChanged: (bool value){
                                    onChangedB(value);
                                  }
                                ),
                                Text(
                                  "En mi domicilio",
                                  style: TextStyle(color: Colors.black54, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          //location,
                          description(),
                          price(),
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
                          title_ofert(),
                          SizedBox(height:20.0),
                          ofert(),
                          saveOfert(),
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
                          fechaCad(),
                          //saveOfert,
                          SizedBox(height:40.0),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Nota 1: La fecha de caducidad no debe ser mayor a 3 meses",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height:5.0),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Nota 2: Para eliminar el descuento actualizar a un dia antes del dia actual",
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
                                              Text('Actualizar Servicio',style: TextStyle(color: Colors.white))
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
                              "Nota: Se actualizara el servicio",
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