import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:gps/gps.dart';
import 'package:servicios_app/src/blocs/bloc_usuario.dart';
import 'package:servicios_app/src/ui/categoryPage.dart';
import 'package:servicios_app/src/ui/confirmationScreen.dart';
import 'package:servicios_app/src/ui/homePage.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgotPassword.dart';

import 'login.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  double latitud=0;
  double longitud=0;

  @override
  void initState() { 
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async{
    SharedPreferences.setMockInitialValues({});
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    /*var latlng = await Gps.currentGps();
    if (latlng!=null){
      latitud=double.parse(latlng.lat);
      longitud=double.parse(latlng.lng);
    }
    localStorage.setDouble("latitud", latitud);
    localStorage.setDouble('longitud', longitud);*/

    //print(localStorage.getDouble("latitud"));
    //print(localStorage.getDouble("longitud"));
    if(localStorage.getBool("isLogin")==true){
      if(localStorage.getString("tipo")=="c"){
        Navigator.pushReplacementNamed(context, '/homePage');
      }else{
        Navigator.pushReplacementNamed(context, '/servicios');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return signIn();
  }

  Widget signIn() {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondo3.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.09,
                        margin: EdgeInsets.only(
                          top:48.0,
                          left:35.0,
                          right: 10.0,
                        ),
                        child: Text('Bienvenido!', style: TextStyle(color:Colors.white, fontSize: 50,),),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.only(
                            left:55,
                          ),
                          child: RaisedButton(
                            shape: StadiumBorder(),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              //decoration: BoxDecoration(color:Colors.red),
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 25.0,),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
                            color: Color(0xFF32bcd1),   
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          //decoration: BoxDecoration(color: Colors.red),
                          width: MediaQuery.of(context).size.width * 0.68,
                          margin: EdgeInsets.only(left:0),
                          child: FlatButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color:Color(0xFF652dc1)),)),
                              ),
                              color: Colors.transparent,
                            ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.43,),
                      Container(
                        //decoration: BoxDecoration(color: Colors.red),
                        child: Column(
                          children: [
                            RaisedButton(
                              shape: StadiumBorder(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                //decoration: BoxDecoration(color:Colors.red),
                                child: Text(
                                  'Registrarme',
                                  style: TextStyle(color: Colors.white, fontSize: 25.0,),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpScreenPage())),
                              color: Color(0xFF32bcd1),   
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                            RaisedButton(
                              shape: StadiumBorder(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                  child: Text(
                                    'Iniciar sin registro',
                                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                                  ),
                                ),
                              ),
                              onPressed: ()async { 
                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                await preferences.remove('email');
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              },
                              color: Color(0xFF32bcd1),   
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                            RaisedButton(
                              shape: StadiumBorder(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                  child: Text(
                                    'Confirmar correo',
                                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                                  ),
                                ),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationScreen(email: ""))),
                              color: Color(0xFF32bcd1),   
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}

