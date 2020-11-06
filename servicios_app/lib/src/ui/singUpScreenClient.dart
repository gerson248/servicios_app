import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servicios_app/src/ui/conditionPage.dart';

import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

import 'SnackBars.dart';
import 'confirmationScreen.dart';



class SingUpScreenClient extends StatefulWidget {
  SingUpScreenClient({Key key}) : super(key: key);

  @override
  _SingUpScreenClientState createState() => _SingUpScreenClientState();
}

class _SingUpScreenClientState extends State<SingUpScreenClient> {
  File _imageFile;
  File _selectedPicture;
  bool _isChecked = false;
  String token;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController controllerMail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerLastName = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();

  var _formKey = GlobalKey<FormFieldState>();
  

  Future _addData(BuildContext context) async{

    if( 
      controllerName.text.isEmpty ||
      controllerLastName.text.isEmpty ||
      controllerMail.text.isEmpty ||
      controllerPassword.text.isEmpty ||
      controllerAddress.text.isEmpty ||
      controllerPhone.text.isEmpty ||
      _imageFile == null
    ){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos y agregar foto");
    }else{
      if(!controllerMail.text.toString().contains("@")){
        SnackBars.showOrangeMessage(context, "Ingrese un correo valido");
      }else{
        if(controllerPhone.text.length<9){
          SnackBars.showOrangeMessage(context, "Tu numero de telefono no cuenta con los digitos necesarios");
        }else{
          if(controllerPassword.text.length<8){
            SnackBars.showOrangeMessage(context, "Tu contraseña debe tener 8 caracteres como mínimo");
          }else{
            if(_isChecked==false){
              SnackBars.showOrangeMessage(context, "Aceptar los terminos y condiciones");
            }else{

              final response5 = await http.post("http://0.0.0.0/servicio/correoDuplicado.php", body: {
                "email": controllerMail.text, 
              });
              var datauser = json.decode(response5.body);

              if(datauser.length!=0){
                SnackBars.showOrangeMessage(context, "Este correo ya ha sido registrado");
              }else{
                var stream= new http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
                var length =  await _imageFile.length();
                var url = Uri.parse("http://0.0.0.0/servicio/adddata.php");

                var request = new http.MultipartRequest("POST", url);

                var multipartFile = new http.MultipartFile("foto", stream, length, filename: basename(_imageFile.path));

                request.fields['nombre'] = controllerName.text;
                request.fields['apellido'] = controllerLastName.text;
                request.fields['email'] = controllerMail.text;
                request.fields['password'] = controllerPassword.text;
                request.fields['direccion'] = controllerAddress.text;
                request.fields['telefono'] = controllerPhone.text;
                request.fields['token'] = token;
                request.fields['tipo'] = "c";
                request.files.add(multipartFile);

                var response = await request.send();

                if(response.statusCode==200){
                  print("Image Uploaded");
                }else{
                  print("Upload Failed");
                }

                response.stream.transform(utf8.decoder).listen((value) {print(value);});

                var response1 = await http.post("http://0.0.0.0/servicio/getid.php", body: {
                  "email":controllerMail.text,
                });

                var dataId = json.decode(response1.body);

                final response2 = await http.post("http://0.0.0.0/servicio/addcliente.php", body: {
                  "idClienteUsuario": dataId[0]['id'],
                });
                //print(controllerMail.text);
                Navigator.push(context,MaterialPageRoute(builder: (context) => ConfirmationScreen(email: controllerMail.text)),);
              }
            }
          }
        }
      }
    }

  }

  void onChanged(bool value){
    setState(() {
      _isChecked = value;
    });
  }
  
  bool passwordVisible = true;
  final ImagePicker _picker = ImagePicker();

  initNotifications()async {
    _firebaseMessaging.requestNotificationPermissions();
    token = await _firebaseMessaging.getToken();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(
        key: _formKey, //añadido
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            padding: EdgeInsets.only(top:20.0,),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoRegistrar.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              children:<Widget>[
                Center(
                  child: Stack(children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: _imageFile == null
                        ? AssetImage("assets/images/profile.png")
                        : FileImage(File(_imageFile.path)),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 25.0,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()),
                          );
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          color: Color(0xFF32bcd1),
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top:20.5,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: 'ejemplo@hotmail.com', labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: controllerMail,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.lock),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password!',
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.purple[200],
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: passwordVisible,
                      controller: controllerPassword,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'nombre',
                          labelText: 'Nombre'),
                      keyboardType: TextInputType.text,
                      controller: controllerName,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'apellido',
                          labelText: 'Apellido'),
                      keyboardType: TextInputType.text,
                      controller: controllerLastName,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'direccion',
                          labelText: 'Dirección'),
                      keyboardType: TextInputType.text,
                      controller: controllerAddress,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'telefono',
                          labelText: 'Telefono'),
                      keyboardType: TextInputType.phone,
                      controller: controllerPhone,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Container(
                  //decoration: BoxDecoration(color:Colors.red),
                  margin: EdgeInsets.only(left:22,right: 0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        //SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                        Checkbox(
                          value: _isChecked, 
                          activeColor: Color(0xFF32bcd1),
                          onChanged: (bool value){
                           // print(value);
                            onChanged(value);
                          }
                        ),
                        Center(
                          child: Text(
                            'Aceptar Términos y Condiciones',
                            style: TextStyle(color:Colors.black54,fontSize: 14.0),
                          ),
                        ),
                        IconButton(icon:Icon(Icons.visibility,color: Colors.black54,), onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => ConditionPage()));})
                      ]
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                Container(
                  //decoration: BoxDecoration(color:Colors.red),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: MediaQuery.of(context).size.width * 0.085),
                        RaisedButton(
                            shape: StadiumBorder(),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Registrar',
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                            onPressed:() {
                              _addData(context);
                            },
                            color: Color(0xFF32bcd1),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.06,),
                        RaisedButton(
                            shape: StadiumBorder(),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                            onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpScreenPage())),
                            color: Color(0xFF32bcd1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: 200.0,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      if(pickedFile!=null){
        _imageFile = File(pickedFile.path);
      }else{
        print("imagen no seleccionada");
      }
    });
  }
}
