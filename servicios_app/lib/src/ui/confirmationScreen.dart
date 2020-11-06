import 'package:flutter/material.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'SnackBars.dart';

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen({Key key, this.email, this.pass}) : super(key: key);
  
  final String email;
  final String pass;


  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {

  String code=" ";
  
  //TextEditingController controllerMail = new TextEditingController();
  //TextEditingController controllerCode = new TextEditingController();

  var controllerMail = GlobalKey<FormFieldState>();
  var controllerCode = GlobalKey<FormFieldState>();

  
  var _formKey = GlobalKey<FormFieldState>();

  _generateCode(BuildContext context)async{
    
    if(controllerMail.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, "Ingresar un correo");
    }else{

      var codigo = new Math.Random().nextInt(100000);
      code = codigo.toString();

      final response = await http.post("http://0.0.0.0/servicio/correo.php", body: {
        "email": controllerMail.currentState.value.toString(),
        "code": code,
      });


    }
  }

  initCode()async{
    if(widget.email!=null){
      var codigo = new Math.Random().nextInt(100000);
      code = codigo.toString();


      final response2 = await http.post("http://0.0.0.0/servicio/correo.php", body: {
        "email": widget.email,
        "code": code,
      });
    }
  }

  _codeConfirmation(BuildContext context) async{
    if (code==controllerCode.currentState.value.toString()) {
      final confirmate = await http.post("http://0.0.0.0/servicio/confirmar.php", body: {
        "email": controllerMail.currentState.value.toString(),
      });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setBool("isLogin", true);
      localStorage.setString('email', controllerMail.currentState.value.toString());
      Navigator.pushReplacementNamed(context, '/homePage'); 
    } else {
      SnackBars.showOrangeMessage(context, 'Codigo incorrecto');
    }
  }

  @override
  void initState() {
    super.initState();
    initCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(
        key: _formKey,
        builder: (BuildContext context){
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondoRegistrar.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              children:<Widget>[
                Container(
                  width: 10.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.0),
                  child: Text('Confirmación de correo', 
                    style: TextStyle(
                      color:Colors.white, 
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  width: 158.0,
                  height: 65.0,
                  padding: EdgeInsets.only(
                    top:80.0
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/email.png')
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),                        
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: TextFormField(
                      initialValue: widget.email,
                      decoration: InputDecoration(
                        hintText: 'example@hotmail.com',
                        labelText: 'Email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      key: controllerMail,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.lock),
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Código de confirmación'),
                      key: controllerCode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top:50.0,
                    left:20.0,
                    right:20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[RaisedButton(
                        shape: StadiumBorder(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 0.0,
                              left: 10.0,
                                right: 10.0,
                          ),
                              child: Text(
                              'VALIDAR CUENTA',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        onPressed:() {
                          _codeConfirmation(context);
                        },
                        color: Color(0xFF32bcd1),
                    ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top:25.0,
                    left:20.0,
                    right:20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[RaisedButton(
                        shape: StadiumBorder(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 0.0,
                              left: 10.0,
                                right: 10.0,
                          ),
                              child: Text(
                              'REENVIAR CODIGO',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        onPressed:() {
                          _generateCode(context);
                        },
                          color: Color(0xFF32bcd1),
                    ),
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
}