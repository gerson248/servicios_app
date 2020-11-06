import 'package:flutter/material.dart';
import 'package:servicios_app/src/ui/loginPage.dart';
import 'package:servicios_app/src/ui/singUpScreenClient.dart';
import 'package:servicios_app/src/ui/singUpScreenProfesio.dart';

class SingUpScreenPage extends StatefulWidget {
  SingUpScreenPage({Key key}) : super(key: key);

  @override
  _SingUpScreenPageState createState() => _SingUpScreenPageState();
}

class _SingUpScreenPageState extends State<SingUpScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                width:MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: Color(0xFF5D6CD4),
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: 344.0,
                      height: 229.5,
                      margin: EdgeInsets.only(
                        top: 110.0,
                        left: 35.0,
                        right: 35.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF32bcd1),
                        image: DecorationImage(
                          image: AssetImage('assets/images/solicitante.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: StadiumBorder(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,
                                left: 45.0,
                                right: 45.0,
                              ),
                              child: Text(
                                'CLIENTE',
                                style: TextStyle(color: Colors.white, fontSize: 25.0),
                              ),
                            ),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpScreenClient())),
                            color: Color(0xFF32bcd1),   
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 344.0,
                      height: 229.5,
                      margin: EdgeInsets.only(
                        top: 100.0,
                        left: 35.0,
                        right: 35.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF32bcd1),
                        image: DecorationImage(
                          image: AssetImage('assets/images/profesional.png'),
                          fit: BoxFit.cover,
                        ),
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
                                  'PROFESIONAL',
                                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                                ),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpScreenProfesio())),
                              color: Color(0xFF32bcd1),
                            
                        ),
                        ],
                      ),
                    ),
                    Container(
                      width: 49.0,
                      height: 49.5,
                      margin: EdgeInsets.only(
                        top: 20.0,
                        left: 290.0,
                        right: 0.0,
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF32bcd1),
                        mini: true,
                        //tooltip: "Fav",
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                        child: Icon(
                          Icons.arrow_back,
                        ),
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
