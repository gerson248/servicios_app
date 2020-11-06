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
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/ui/location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'SnackBars.dart';
import 'UtilityWidgets.dart';

class InfoAdditional extends StatefulWidget {
  InfoAdditional({Key key, this.id}) : super(key: key);
  String id;

  @override
  _InfoAdditionalState createState() => _InfoAdditionalState();
}

class _InfoAdditionalState extends State<InfoAdditional> {

  var selectedCurrency, selectedType;


  var category = "";
  var subcategory="";
  var precio = "";
  int mes=0;

  final picker = ImagePicker();

  File _image1;
  File _image2;
  File _image3;

  File _archiveFile;

  List dataS;
  List dataS2;
  List dataS3;
  List dataS4;
  List dataS5;
  List ver=["0","0","0","0","0"];
  bool loading=true;

  Future _addImage(BuildContext context) async{

      if(_image1!=null && _image2==null && _image3==null){
        //imagen 1 disponible
        var stream1= new http.ByteStream(DelegatingStream.typed(_image1.openRead()));
        var length1 = await _image1.length();

        var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
        var request = new http.MultipartRequest("POST", url);
        var galeria1 = new http.MultipartFile("galeria1", stream1, length1, filename: basename(_image1.path));
        request.fields['id'] = widget.id;
        request.files.add(galeria1);

        var response = await request.send();
        SnackBars.showOrangeMessage(context, "Imagenes agregadas"); 
      }else{
        if(_image1==null && _image2!=null && _image3==null){
          //imagen 2 disponible
          var stream2= new http.ByteStream(DelegatingStream.typed(_image2.openRead()));
          var length2 = await _image2.length();

          var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
          var request = new http.MultipartRequest("POST", url);
          var galeria2 = new http.MultipartFile("galeria2", stream2, length2, filename: basename(_image2.path));
          request.fields['id'] = widget.id;
          request.files.add(galeria2);

          var response = await request.send();
          SnackBars.showOrangeMessage(context, "Imagenes agregadas"); 

        }else{
          if(_image1==null && _image2==null && _image3!=null){
            //imagen 3 disponible
            var stream3= new http.ByteStream(DelegatingStream.typed(_image3.openRead()));
            var length3 = await _image3.length();

            var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
            var request = new http.MultipartRequest("POST", url);
            var galeria3 = new http.MultipartFile("galeria3", stream3, length3, filename: basename(_image3.path));
            request.fields['id'] = widget.id;
            request.files.add(galeria3);

            var response = await request.send();
            SnackBars.showOrangeMessage(context, "Imagenes agregadas"); 

          }else{
            if(_image1!=null && _image2!=null && _image3==null){
              //imagen 1 y 2 disponible
              var stream1= new http.ByteStream(DelegatingStream.typed(_image1.openRead()));
              var stream2= new http.ByteStream(DelegatingStream.typed(_image2.openRead()));
              var length1 = await _image1.length();
              var length2 = await _image2.length();
              var galeria1 = new http.MultipartFile("galeria1", stream1, length1, filename: basename(_image1.path));
              var galeria2 = new http.MultipartFile("galeria2", stream2, length2, filename: basename(_image2.path));
              var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
              var request = new http.MultipartRequest("POST", url);
              request.fields['id'] = widget.id;
              request.files.add(galeria1);
              request.files.add(galeria2);

              var response = await request.send();
              SnackBars.showOrangeMessage(context, "Imagenes agregadas"); 

            }else{
              if(_image1==null && _image2!=null && _image3!=null){
                //imagen 2 y 3 disponible
                var stream3= new http.ByteStream(DelegatingStream.typed(_image3.openRead()));
                var stream2= new http.ByteStream(DelegatingStream.typed(_image2.openRead()));
                var length3 = await _image3.length();
                var length2 = await _image2.length();
                var galeria3 = new http.MultipartFile("galeria3", stream3, length3, filename: basename(_image3.path));
                var galeria2 = new http.MultipartFile("galeria1", stream2, length2, filename: basename(_image2.path));
                var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
                var request = new http.MultipartRequest("POST", url);
                request.fields['id'] = widget.id;
                request.files.add(galeria3);
                request.files.add(galeria2);

                var response = await request.send();
                SnackBars.showOrangeMessage(context, "Imagenes agregadas");

              }else{
                if(_image1!=null && _image2==null && _image3!=null){
                  //imagen 1 y 3 disponible
                  var stream1= new http.ByteStream(DelegatingStream.typed(_image1.openRead()));
                  var stream3= new http.ByteStream(DelegatingStream.typed(_image3.openRead()));
                  var length1 = await _image1.length();
                  var length3 = await _image3.length();
                  var galeria1 = new http.MultipartFile("galeria1", stream1, length1, filename: basename(_image1.path));
                  var galeria3 = new http.MultipartFile("galeria3", stream3, length3, filename: basename(_image3.path));
                  var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
                  var request = new http.MultipartRequest("POST", url);
                  request.fields['id'] = widget.id;
                  request.files.add(galeria1);
                  request.files.add(galeria3);

                  var response = await request.send();
                  SnackBars.showOrangeMessage(context, "Imagenes agregadas");

                }else{
                  if(_image1!=null && _image2!=null && _image3!=null){
                    //imagen 1 2 y 3 disponible

                    var stream1= new http.ByteStream(DelegatingStream.typed(_image1.openRead()));
                    var stream2= new http.ByteStream(DelegatingStream.typed(_image2.openRead()));
                    var stream3= new http.ByteStream(DelegatingStream.typed(_image3.openRead()));
                    var length1 = await _image1.length();
                    var length2 = await _image2.length();
                    var length3 = await _image3.length();
                    var galeria1 = new http.MultipartFile("galeria1", stream1, length1, filename: basename(_image1.path));
                    var galeria2 = new http.MultipartFile("galeria2", stream2, length2, filename: basename(_image2.path));
                    var galeria3 = new http.MultipartFile("galeria3", stream3, length3, filename: basename(_image3.path));
                    var url = Uri.parse("http://0.0.0.0/servicio/addImage.php");
                    var request = new http.MultipartRequest("POST", url);
                    request.fields['id'] = widget.id;
                    request.files.add(galeria1);
                    request.files.add(galeria2);
                    request.files.add(galeria3);

                    var response = await request.send();
                    SnackBars.showOrangeMessage(context, "Imagenes agregadas");

                  }else{
                    SnackBars.showOrangeMessage(context, "No se agrego ninguna imagen");
                  }
                }
              }
            }
          }
        }
      }
  }

  Future uploadCer(BuildContext context)async{
    // Datos del profesional y de los servicios que tiene.
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
      "email":localStorage.get("email"),
    });

    var dataIdU = json.decode(response.body);

    final response2 = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id":dataIdU[0]['id'],
    });

    dataS2=(json.decode(response2.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response3 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
      "idProfesionalUsuario":dataS2[0].id.toString(),
    });

    var dataIdP = json.decode(response3.body);
    dataS4=(dataIdP as List).map((e) => Profesional.fromJson(e)).toList();

    final response4 = await http.post("http://0.0.0.0/servicio/getServices.php", body: {
      "idServicioProfesional":dataIdP[0]['id'],
    });

    dataS3=(json.decode(response4.body) as List).map((e) => Servicio.fromJson(e)).toList();

    final response1 = await http.post("http://0.0.0.0/servicio/getServiceById.php", body: {
      "id":widget.id,
    });

    dataS5=(json.decode(response1.body) as List).map((e) => Servicio.fromJson(e)).toList();

    for(int i=0;i<dataS3.length;i++){
      ver[i]="1";
    }
    //print(ver);

    if(dataS5[0].archivo==''){
      SnackBars.showOrangeMessage(context, "Debe subir un archivo para solicitar certificación");
    }else{
      if(dataS4[0].dni!='' && dataS4[0].recibo!=''){
        final response5 = await http.post("http://0.0.0.0/servicio/correoEditado.php", body: {
          "nombre":dataS2[0].nombre,
          "apellido":dataS2[0].apellido,
          "email":dataS2[0].email,
          "telefono":dataS2[0].telefono,
          "direccion":dataS2[0].direccion,
          "link_dni":"http://0.0.0.0/servicio/${dataS4[0].dni}",
          "link_recibo":"http://0.0.0.0/servicio/${dataS4[0].recibo}",
          "idProf":dataS4[0].id.toString(),
          "servicio1":ver[0]=="1"?"http://0.0.0.0/servicio/${dataS3[0].archivo}":"",
          "idS1":ver[0]=="1"?dataS3[0].id.toString():"",
          "servicio2":ver[1]=="1"?"http://0.0.0.0/servicio/${dataS3[1].archivo}":"",
          "idS2":ver[1]=="1"?dataS3[1].id.toString():"",
          "servicio3":ver[2]=="1"?"http://0.0.0.0/servicio/${dataS3[2].archivo}":"",
          "idS3":ver[2]=="1"?dataS3[2].id.toString():"",
          "servicio4":ver[3]=="1"?"http://0.0.0.0/servicio/${dataS3[3].archivo}":"",
          "idS4":ver[3]=="1"?dataS3[3].id.toString():"",
          "servicio5":ver[4]=="1"?"http://0.0.0.0/servicio/${dataS3[4].archivo}":"",
          "idS5":ver[4]=="1"?dataS3[4].id.toString():"",
        });
        //SnackBars.showOrangeMessage(context, "Se realizo su pedido");
      }else{
        SnackBars.showOrangeMessage(context, "Para solicitar certificacion recuerde vericarse primero (Subir Dni y Recibo)");
      }
    }
  }

  Future getPdfAndUpload(BuildContext context) async{

    final file = await FilePicker.getFile(type: FileType.custom);
    if(file!= null){
      _archiveFile = file ;

      var stream= new http.ByteStream(DelegatingStream.typed(_archiveFile.openRead()));
      var length = await _archiveFile.length();
      var url = Uri.parse("http://0.0.0.0/servicio/addCertificado.php");
      var request = new http.MultipartRequest("POST", url);
      var multipartFile = new http.MultipartFile("archivo", stream, length, filename: basename(_archiveFile.path));
      request.fields["id"] = widget.id;
      request.files.add(multipartFile);

      var response = await request.send();
      SnackBars.showOrangeMessage(context, "Se agrego un certificado");
    }else{
      SnackBars.showOrangeMessage(context, "No se escogio un certificado");
    }

  }

  Future getImage(String number) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(number=="1"){
      setState(() {
        if (pickedFile != null) {
          _image1 = File(pickedFile.path);
        } else {
          print('No imagen seleccioanda.');
        }
      });
    }else{
      if(number=="2"){
        setState(() {
          if (pickedFile != null) {
            _image2 = File(pickedFile.path);
          } else {
            print('No imagen seleccioanda.');
          }
        });
      }else{
        if(number=="3"){
          setState(() {
            if (pickedFile != null) {
              _image3 = File(pickedFile.path);
            } else {
              print('No imagen seleccioanda.');
            }
          });
        }
      }
    }
  }

  Future getData() async{

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

    Widget title_certf(){ return Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Certificado (Opcional)",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
        ),
      ),
    );}

    Widget title_galeria(){ return  Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Galería",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
        ),
      ),
    );}

    Widget title_ubication(){ return  Container(
      margin: EdgeInsets.only(top:20.0),
      child: Center(
        child:Text(
          "Ubicación (Opcional)",
          style: TextStyle(
            fontSize:24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,  
          ),
        ),
      ),
    );}

    Widget uploadService(BuildContext context) { 
      return Padding(
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
                        Icon(Icons.archive, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Agregar Certificado',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed:(){
                  getPdfAndUpload(context);
                  
                },
                //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

  Widget uploadCertifi(BuildContext context) { 
      return Padding(
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
                        Icon(Icons.verified, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Solicitar Certificación',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed:(){
                  uploadCer(context);
                },
                //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

    Widget galeria1(BuildContext context){return  Center(
      child: Stack(
        children:<Widget>[
          Container(
              margin: EdgeInsets.all(4.0),
              width:150,
              //height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black12,
              image: DecorationImage(
                image: _image1 == null
                ? (dataS[0].galeria1 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria1}"))
                : FileImage(_image1),
                fit: BoxFit.cover,
              ),
            ),
            /*child: _image==null
            ? AssetImage("assets/images/fondoGaleria.png")
            : Image.file(_image),*/
          ),
          Positioned(
            bottom: 50.0,
            right: 50.0,
            child: InkWell(
              onTap: (){
                getImage("1");
              },
              child: Icon(
                Icons.add,
                color: Color(0xFF32bcd1),
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );}

    
    Widget galeria2(BuildContext context){return   Center(
      child: Stack(
        children:<Widget>[
          Container(
              margin: EdgeInsets.all(4.0),
              width:150,
              //height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black12,
              image: DecorationImage(
                image: _image2 == null
                ? (dataS[0].galeria2 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria2}"))
                : FileImage(_image2),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            right: 50.0,
            child: InkWell(
              onTap: () {
                getImage("2");
              },
              child: Icon(
                Icons.add,
                color: Color(0xFF32bcd1),
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );}

    
    Widget galeria3(BuildContext context){return  Center(
      child: Stack(
        children:<Widget>[
          Container(
              margin: EdgeInsets.all(4.0),
              width:150,
              //height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black12,
              image: DecorationImage(
                image: _image3 == null
                ? (dataS[0].galeria3 == "0" ? AssetImage("assets/images/fondoGaleria.png") : NetworkImage("http://0.0.0.0/servicio/${dataS[0].galeria3}"))
                : FileImage(_image3),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            right: 50.0,
            child: InkWell(
              onTap: () {
                getImage("3");
              },
              child: Icon(
                Icons.add,
                color: Color(0xFF32bcd1),
                size: 50.0,
              ),
            ),
          ),
        ],
      ),
    );}

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
              return loading
            ?UtilityWidget.containerloadingIndicator(context)
            :Container(
                decoration: BoxDecoration(
                  //color: Colors.pink,
                ),
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
                          title_galeria(),
                          SizedBox(height:10),
                          Container(
                            height: 150.0,
                            //margin: EdgeInsets.symmetric(vertical: 20.0),
                            margin: EdgeInsets.all(4.0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:<Widget>[
                                galeria1(context),
                                galeria2(context),
                                galeria3(context),
                              ],
                            ),
                          ),
                          //SizedBox(height:10.0),
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
                                              Icon(Icons.image, color: Colors.white,),
                                              SizedBox(width: 8,),
                                              Text('Agregar imagenes',style: TextStyle(color: Colors.white))
                                            ],
                                          ),
                                        ),
                                      ),
                                      onPressed:(){
                                        _addImage(context);
                                      },
                                      color: Color(0xFF32bcd1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ), 
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Nota: Seleccionar imagenes referentes del servicio (maximo 3)",
                              textAlign: TextAlign.center,
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
                          title_certf(),
                          uploadService(context),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Seleccionar un documento que certifique el servicio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          //saveOfert,
                          SizedBox(height:40.0),
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
                          Container(
                            margin: EdgeInsets.only(top:20.0),
                            child: Center(
                              child:Text(
                                "Certificación",
                                style: TextStyle(
                                  fontSize:24.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,  
                                ),
                              ),
                            ),
                          ),
                          uploadCertifi(context),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0),
                            child: Text(
                              "Solicitar certificacion del servicio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          //saveOfert,
                          SizedBox(height:40.0),
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
                          title_ubication(),
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
                                              Icon(Icons.location_on, color: Colors.white,),
                                              SizedBox(width: 8,),
                                              Text('Agregar ubicación',style: TextStyle(color: Colors.white))
                                            ],
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location(id:widget.id)),),
                                      //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                                      color: Color(0xFF32bcd1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Fijar puesto de servicio en Google Maps",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          //SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Nota: Para mover el marcador mantenerlo presionado y deslizarlo a la dirección a ubicar",
                              textAlign: TextAlign.start,
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