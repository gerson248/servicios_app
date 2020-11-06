import 'package:flutter/material.dart';


class FilterPage extends StatefulWidget {
  FilterPage({Key key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  
  double _currentSliderValue=0;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Aplicar", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
            leading: IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: (){Navigator.of(context).pop(_currentSliderValue);}),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                height: 150,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Rango de distancia en KMs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:20.0),
                    Container(
                      //decoration: BoxDecoration(color:Colors.red),
                      margin: EdgeInsets.only(right:22,left:22.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            //SizedBox(width: 15,),
                            Icon(Icons.location_on,color:Color(0xFF32bcd1),size: 20.0,),
                            Container(
                              //decoration: BoxDecoration(color:Colors.red),
                              width: MediaQuery.of(context).size.width * 0.55,
                              child:Slider(
                                value: _currentSliderValue,
                                min: 0,
                                max: 300,
                                activeColor: Colors.purple,
                                inactiveColor:Colors.purple[50],
                                divisions: 100,
                                label: _currentSliderValue.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _currentSliderValue = value;
                                  });
                                },
                              ),
                            ),
                            Icon(Icons.location_on,color:Color(0xFF32bcd1), size: 35.0,)
                          ],
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