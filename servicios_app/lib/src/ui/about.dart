import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Acerca de", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  //color: Colors.pink,
                ),
                child: ListView(
                  children:<Widget>[
                    SizedBox(height:20.0),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Acerca de ...",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:20.0,
                          color: Color(0xFF32bcd1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 250.0,
                      margin: EdgeInsets.only(
                        right:120.0,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/escudo.png"),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20.0),
                      child: Text(
                        "Diseño y desarrollo de software",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),                      
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Ramses Consulting",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:25.0,
                          color: Color(0xFF32bcd1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),                      
                    ), 
                    Container(
                      padding: EdgeInsets.only(left:20.0),
                      child: Text(
                        "www.ramsesconsulting.com",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:22.0,
                          color: Color(0xFF32bcd1),
                          fontWeight: FontWeight.w500,
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