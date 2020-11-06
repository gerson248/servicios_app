import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:servicios_app/src/blocs/bloc_cliente.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SnackBars.dart';
import 'UtilityWidgets.dart';
import 'forgotPassword.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

String _email='';
//SharedPreferences localStorage;

class Login extends StatefulWidget {
  
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  //SharedPreferences localStorage;

  TextEditingController user=new TextEditingController();
  TextEditingController pass=new TextEditingController();

  String msg='';

  //ClienteBloc clienteBloc;
  bool _isDataLoading = false;
  bool _isAuthenticated = false;
  bool _passwordVisible = true;
  bool isLogin = false;
  bool _rememberMe = false;
  String token;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _login(BuildContext context) async {

    
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if(user.text.isEmpty || pass.text.isEmpty){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos");
    }else{
      
      final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
        "email": user.text, 
      });
      


      var datauser = json.decode(response.body);

      if(datauser.length==0){
        //SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setBool("isLogin", false);
        SnackBars.showOrangeMessage(context, "No se encuentro al usuario en el sistema");
        setState(() {
          msg="Login Fail";
        });
      }else{

        final response9 = await http.post("http://0.0.0.0/servicio/login.php", body: {
          'email': user.text,
          'password': pass.text,  
        });

        var contra = response9.body;

        if(contra.isEmpty){
          SnackBars.showOrangeMessage(context, "contraseña incorrecta");
        }else{

          if(datauser[0]['confirmado']=="0"){
            //SharedPreferences localStorage = await SharedPreferences.getInstance();
            localStorage.setBool("isLogin", false);
            SnackBars.showOrangeMessage(context, "Verificar correo");
          }else{
            
            //SharedPreferences localStorage = await SharedPreferences.getInstance();
            //localStorage.setBool("isLogin", true);
            if(_rememberMe==true){
                localStorage.setBool("isLogin", true);
            }else{
              localStorage.setBool("isLogin", false);
            }
            localStorage.setString('email', user.text.toString());
            //localStorage.setString('password', pass.text.toString());

            final response8 = await http.post("http://0.0.0.0/servicio/updateToken.php", body: {
              "token": token,
              "email": user.text.toString(),
            });

            if(datauser[0]['tipo']=="c"){
              Navigator.pushReplacementNamed(context, '/homePage');
              localStorage.setString('tipo', "c");
            }else{
              Navigator.pushReplacementNamed(context, '/servicios');
              localStorage.setString('tipo', "p");
            }

            setState(() {
              _email= datauser[0]['email'];
            });
          }

        }
      }
    }
  }

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
    //clienteBloc = BlocProvider.of(context);
    Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value){
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              //fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondo5.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: _isDataLoading
                ?UtilityWidget.containerloadingIndicator(context)
                :ListView(
                  children:<Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 23.0,
                          left: 20.0,
                          //right: 287.0
                        ),
                        child: IconButton(
                          icon: new Image.asset("assets/images/arrow_back.png"),
                          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()),),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: EdgeInsets.only(
                        top: 25.0,
                        left: 35.0,
                        //right: 67.0,
                      ),
                      child: Text('Bienvenido!', style: TextStyle(fontSize:50.0,color: Color(0xFF652dc1) ),),
                    ),
                    ListTile(
                      
                      leading: const Icon(Icons.email),
                      title: TextFormField(
                        //initialValue: widget.email,
                        controller: user,
                        decoration: InputDecoration(
                            hintText: 'example@hotmail.com',
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: TextFormField(
                        //initialValue: widget.email,
                        controller: pass,
                        decoration: InputDecoration(
                          hintText: 'password',
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
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.only(
                          top:20,
                          //right:170,
                          left: 55,
                        ),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            //decoration: BoxDecoration(color:Colors.red),
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 25.0,),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () {
                            _login(context);
                            //Navigator.pop(context);
                          },
                          color: Color(0xFF32bcd1),   
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 20.0,
                        margin: EdgeInsets.only(left:55,top:10),
                        child: Row(
                          children: <Widget>[
                            Theme(
                              data: ThemeData(unselectedWidgetColor:Color(0xFF32bcd1)),
                              child: Checkbox(
                                value: _rememberMe,
                                checkColor: Color(0xFF652dc1),
                                activeColor: Color(0xFF32bcd1),
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value;
                                    //print(_rememberMe);
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Recordarme',
                              style: TextStyle(
                                color: Color(0xFF32bcd1),
                                fontWeight: FontWeight.bold,
                                //fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top:220.0,
                          left: 10.0,
                          //right:100.0,
                        ),
                        child: FlatButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpScreenPage())),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('You are not a remember? Register', style: TextStyle(color:Color(0xFF652dc1)),),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}