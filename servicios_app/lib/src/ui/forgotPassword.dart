import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'SnackBars.dart';

class ForgotPassword extends StatefulWidget {
  //ForgotPassword({Key key}) : super(key: key);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  
  String code=" ";
  
  //TextEditingController controllerMail = new TextEditingController();
  //TextEditingController controllerCode = new TextEditingController();

  var controllerMail = GlobalKey<FormFieldState>();
  var controllerCode = GlobalKey<FormFieldState>();
  var controllerPassword = GlobalKey<FormFieldState>();

  bool _passwordVisible = true;

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

  _codeConfirmation(BuildContext context) async{
    if (code==controllerCode.currentState.value.toString()) {
      final confirmate = await http.post("http://0.0.0.0/servicio/updatePassword.php", body: {
        "email": controllerMail.currentState.value.toString(),
        "password": controllerPassword.currentState.value.toString(),
      });
      print("contra canviada !!!!!!!");
      Navigator.pushReplacementNamed(context, '/login'); 
      //SnackBars.showOrangeMessage(context, 'Codigo incorrecto');
    } else {
      SnackBars.showOrangeMessage(context, 'Codigo incorrecto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      //future: null,
      builder: (context){
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondoP.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ListView(
                  children:<Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 0.0,
                        right: 320.0
                      ),
                      child: IconButton(
                        icon: new Image.asset("assets/images/arrow_back.png"),
                        onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 220.0,
                      ),
                      child:  ListTile(                      
                        leading: const Icon(Icons.email),
                        title: TextFormField(
                          initialValue:"",
                          decoration: InputDecoration(
                            hintText: "gerson@hotmail.com",
                            labelText: 'email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          key: controllerMail,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[RaisedButton(
                              shape: StadiumBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Solicitar codigo',
                                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                                ),
                              ),
                              onPressed: () {
                                _generateCode(context);
                              },
                              color: Color(0xFF32bcd1),
                            ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                      ),
                      child:  ListTile(                      
                        leading: const Icon(Icons.lock),
                        title: TextFormField(
                          initialValue:"",
                          decoration: InputDecoration(
                            hintText: "nueva contraseña",
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility, color:Color(0xFF32bcd1),), 
                              onPressed: (){
                                setState(() {_passwordVisible = !_passwordVisible;});
                              }
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _passwordVisible,
                          key: controllerPassword,
                        ),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'codigo',
                          labelText: 'Codigo',
                          ),
                        keyboardType: TextInputType.text,
                        key: controllerCode,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[RaisedButton(
                              shape: StadiumBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Cambiar contraseña',
                                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                                ),
                              ),
                              onPressed: () {
                                _codeConfirmation(context);
                              },
                              color: Color(0xFF32bcd1),
                            ),
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