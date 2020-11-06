import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:servicios_app/src/blocs/bloc_cliente.dart';
import 'package:servicios_app/src/blocs/bloc_usuario.dart';
import 'package:servicios_app/src/ui/confirmationScreen.dart';
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:servicios_app/src/ui/forgotPassword.dart';
import 'package:servicios_app/src/ui/homePage.dart';
import 'package:servicios_app/src/ui/login.dart';
import 'package:servicios_app/src/ui/categoryPage.dart';
import 'ui/loginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//import 'UI/login/LoginScreen.dart';
//import 'UI/tabs/HomeScreen.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate,GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('es')],
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/loginPage': (BuildContext context) => new LoginPage(),
          '/login': (BuildContext context) => new Login(),
          '/forgotPassword': (BuildContext context) => new ForgotPassword(),
          '/homePage': (BuildContext context) => new HomePage(),
          '/categoria': (BuildContext context) => new CategoryPage(),
          '/servicios': (BuildContext context) => new ServicesPage(),
        },
      );
  }
}
