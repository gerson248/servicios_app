import 'package:flutter/material.dart';
import 'package:servicios_app/src/ui/categoryPage.dart';
import 'package:servicios_app/src/ui/loginPage.dart';
import 'package:servicios_app/src/ui/ofertPage.dart';
import 'package:servicios_app/src/ui/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  List<Widget> _children = [
    Profile(),
    CategoryPage(),
    OfertPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: _children[_currentIndex],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.purple,
              ),
              child: 
            BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              elevation: 100,
              unselectedItemColor: Colors.orangeAccent[200],
              selectedItemColor: Colors.orange[700],
              type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,color:Color(0xFF32bcd1),
                    ),
                    title: Text("Mi perfil", style: TextStyle(color:Color(0xFF32bcd1), fontSize: 10,))),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,color:Color(0xFF32bcd1),
                    ),
                    title: Text("Home",style: TextStyle(color:Color(0xFF32bcd1), fontSize: 10,))),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.local_offer_outlined,color:Color(0xFF32bcd1),
                    ),
                    title: Text("Ofertas",style: TextStyle(color:Color(0xFF32bcd1), fontSize: 10,))),
              ],
            ),
          )
        )
      );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}