import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:servicios_app/src/models/profesional.dart';
import 'package:servicios_app/src/models/servicio.dart';
import 'package:servicios_app/src/ui/servicesPage.dart';
import 'package:servicios_app/src/ui/singUpScreenPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servicios_app/src/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SnackBars.dart';
import 'UtilityWidgets.dart';
import 'package:file_picker/file_picker.dart';


class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool passwordVisible1 = true;
  bool passwordVisible2 = true;
  List dataS;
  List dataS2;
  List dataS3;
  List dataS4;
  List dataP;
  List ver=["0","0","0","0","0"];
  bool loading=true;
  bool loading1=true;
  bool _rememberMe = false;

  File _archiveDNI;
  File _archiveRecibo;

  var controllerAddress = GlobalKey<FormFieldState>();
  var controllerPhone = GlobalKey<FormFieldState>();
  var controllerPassword = GlobalKey<FormFieldState>();
  var controllerPasswordOld = GlobalKey<FormFieldState>();
  var controllerCuentaBancaria = GlobalKey<FormFieldState>();
  var controllerOnline = GlobalKey<FormFieldState>();

  Future _Logout(BuildContext context) async{
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  Future showProfile(BuildContext context) async{
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();


    if(localStorage.get("email")==null){
      Navigator.push(context,MaterialPageRoute(builder: (context) => SingUpScreenPage()));
    }else{

      String correo = localStorage.get("email");
      //if (!mounted) return;
      final response = await http.post("http://0.0.0.0/servicio/getUsuario.php", body: {
        "email":correo,
      });
      //if (!mounted) return;
      dataS=(json.decode(response.body) as List).map((e) => Usuario.fromJson(e)).toList();

      if(dataS[0].tipo!="c"){
        final response2 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
          "idProfesionalUsuario":dataS[0].id.toString(),
        });

        dataP=(json.decode(response2.body) as List).map((e) => Profesional.fromJson(e)).toList();

        setState(() {
          _rememberMe=dataP[0].online=="SI"?true:false;
        });
      }
      setState(() {
        if(dataS[0].tipo=="c"){
          loading1=false;
        }
        loading=false;
      });

    }
  }

  Future updateUser(BuildContext context) async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if(controllerAddress.currentState.value.toString().isEmpty ||
    controllerPhone.currentState.value.toString().isEmpty
    ){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos para actualizar");
    }else{
      final response = await http.post("http://0.0.0.0/servicio/updateUsuario.php", body: {
        "email":localStorage.get("email"),
        "direccion":controllerAddress.currentState.value.toString(),
        "telefono":controllerPhone.currentState.value.toString(),
      });
      SnackBars.showOrangeMessage(context, "Se actualizo correctamente");
    }

  }

  Future changePassword(BuildContext context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(controllerPassword.currentState.value.toString().isEmpty || controllerPasswordOld.currentState.value.toString().isEmpty){
      SnackBars.showOrangeMessage(context, "Debe completar todos los campos para actualizar contraseña");
    }else{
      if(controllerPassword.currentState.value.toString().length<8){
        SnackBars.showOrangeMessage(context, "Tu contraseña debe tener 8 caracteres como mínimo");
      }else{
        if(controllerPasswordOld.currentState.value.toString()==localStorage.get("password")){
          final response = await http.post("http://0.0.0.0/servicio/changePassword.php", body: {
            "email":localStorage.get("email"),
            "password":controllerPassword.currentState.value.toString(),
          });
          localStorage.setString('password', controllerPassword.currentState.value.toString());
           SnackBars.showOrangeMessage(context, "Se realizo el cambio de la contraseña");
        }else{
          SnackBars.showOrangeMessage(context, "La contraseña ingresada no es la correcta");
        }

      }
    }
  }

  Future uploadVer(BuildContext context)async{
    // Datos del profesional y de los servicios que tiene.
    final response2 = await http.post("http://0.0.0.0/servicio/getUsuarioById.php", body: {
      "id":dataS[0].id.toString(),
    });

    dataS2=(json.decode(response2.body) as List).map((e) => Usuario.fromJson(e)).toList();

    final response3 = await http.post("http://0.0.0.0/servicio/getidProf.php", body: {
      "idProfesionalUsuario":dataS2[0].id.toString(),
    });

    var dataIdP = json.decode(response3.body);
    dataS4=(dataIdP as List).map((e) => Profesional.fromJson(e)).toList();

    final response4 = await http.post("http://0.0.0.0/servicio/getServices.php", body: {
      "idServicioProfesional":dataIdP[0]['id'],
    });

    dataS3=(json.decode(response4.body) as List).map((e) => Servicio.fromJson(e)).toList();

    for(int i=0;i<dataS3.length;i++){
      ver[i]="1";
    }
    //print(ver);
    
    if(dataS4[0].dni!='' && dataS4[0].recibo!=''){
      final response5 = await http.post("http://0.0.0.0/servicio/correoEditado.php", body: {
        "nombre":dataS2[0].nombre,
        "apellido":dataS2[0].apellido,
        "email":dataS2[0].email,
        "telefono":dataS2[0].telefono,
        "direccion":dataS2[0].direccion,
        "link_dni":"http://0.0.0.0/servicio/${dataS4[0].dni}",
        "link_recibo":"http://0.0.0.0/servicio/${dataS4[0].recibo}",
        "idProf":dataS4[0].id.toString(),
        "servicio1":ver[0]=="1"?"http://0.0.0.0/servicio/${dataS3[0].archivo}":"",
        "idS1":ver[0]=="1"?dataS3[0].id.toString():"",
        "servicio2":ver[1]=="1"?"http://0.0.0.0/servicio/${dataS3[1].archivo}":"",
        "idS2":ver[1]=="1"?dataS3[1].id.toString():"",
        "servicio3":ver[2]=="1"?"http://0.0.0.0/servicio/${dataS3[2].archivo}":"",
        "idS3":ver[2]=="1"?dataS3[2].id.toString():"",
        "servicio4":ver[3]=="1"?"http://0.0.0.0/servicio/${dataS3[3].archivo}":"",
        "idS4":ver[3]=="1"?dataS3[3].id.toString():"",
        "servicio5":ver[4]=="1"?"http://0.0.0.0/servicio/${dataS3[4].archivo}":"",
        "idS5":ver[4]=="1"?dataS3[4].id.toString():"",
      });
      SnackBars.showOrangeMessage(context, "Se realizo su pedido");
    }else{
      SnackBars.showOrangeMessage(context, "No encontramos Recibo o DNI que haya subido");
    }

  }
  
  Future uploadCuentaBancaria(BuildContext context)async{
    if(controllerCuentaBancaria.currentState.value.toString().isNotEmpty){
      final response = await http.post("http://0.0.0.0/servicio/updateBanco.php", body: {
        "idProfesionalUsuario":dataS[0].id.toString(),
        "cuentaBancaria":controllerCuentaBancaria.currentState.value.toString(),
        "online":_rememberMe==true?"SI":"NO",
      });
      SnackBars.showOrangeMessage(context, "Se guardaron los datos satisfactoriamente");
    }else{
      SnackBars.showOrangeMessage(context, "Ingrese una cuenta bancaria");
    }
  }
  Future getDNIUpload(BuildContext context) async{

    final file = await FilePicker.getFile(type: FileType.custom);

    if(file!= null){
      _archiveDNI = file ;

      var stream= new http.ByteStream(DelegatingStream.typed(_archiveDNI.openRead()));
      var length = await _archiveDNI.length();
      var url = Uri.parse("http://0.0.0.0/servicio/addFile.php");
      var request = new http.MultipartRequest("POST", url);
      var multipartFile = new http.MultipartFile("dni", stream, length, filename: basename(_archiveDNI.path));
      request.fields["tipo"] = "DNI";
      request.fields["id"] = dataS[0].id.toString();
      request.files.add(multipartFile);

      var response = await request.send();


      SnackBars.showOrangeMessage(context, "Se agrego un DNI");
    }else{
      SnackBars.showOrangeMessage(context, "No se escogio un DNI");
    }
    //function call
  }

  Future getReciboUpload(BuildContext context) async{

    final file = await FilePicker.getFile(type: FileType.custom);

    if(file!= null){
      _archiveRecibo = file ;

      var stream= new http.ByteStream(DelegatingStream.typed(_archiveRecibo.openRead()));
      var length = await _archiveRecibo.length();
      var url = Uri.parse("http://0.0.0.0/servicio/addFile.php");
      var request = new http.MultipartRequest("POST", url);
      var multipartFile = new http.MultipartFile("recibo", stream, length, filename: basename(_archiveRecibo.path));
      request.fields["tipo"] = "recibo";
      request.fields["id"] = dataS[0].id.toString();
      request.files.add(multipartFile);

      var response = await request.send();
      SnackBars.showOrangeMessage(context, "Se agrego un Recibo");
    }else{
      SnackBars.showOrangeMessage(context, "No se escogio un Recibo");
    }
    //function call
  }

  void _launchURL(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      throw 'No se encontro la url';
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProfile(this.context);
  }

  @override
  Widget build(BuildContext context) {

    Widget uploadDni(BuildContext context) { 
      return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.upload_file, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Agregar DNI',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed:(){
                  getDNIUpload(context);
                },
                //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

    Widget uploadRecibo(BuildContext context) { 
      return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.upload_file, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Agregar Recibo',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed:(){
                  getReciboUpload(context);
                  
                },
                //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

    Widget uploadFiles(BuildContext context) { 
      return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.verified,color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Solicitar Verificación',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed:(){
                  uploadVer(context);
                  
                },
                //onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Location()),),
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

    Widget direction() { return Padding(
      padding: const EdgeInsets.all(2.0),                        
      child: ListTile(
        leading: const Icon(Icons.home),
        title: TextFormField(
          initialValue: dataS[0].direccion,
          decoration: InputDecoration(
            //hintText: 'Direccion',
            labelText: 'Dirección'
          ),
          keyboardType: TextInputType.text,
          key: controllerAddress,
        ),
      ),
    );}

    Widget telephone() { return Padding(
      padding: const EdgeInsets.all(2.0),                        
      child: ListTile(
        leading: const Icon(Icons.phone),
        title: TextFormField(
          initialValue: dataS[0].telefono,
          decoration: InputDecoration(
            //hintText: 'Direccion',
            labelText: 'Telefono'
          ),
          keyboardType: TextInputType.text,
          key: controllerPhone,
        ),
      ),
    );}

    Widget password() {return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        leading: const Icon(Icons.lock),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Contraseña antigua',
            //labelText: 'Contraseña',
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible1
                ? Icons.visibility
                : Icons.visibility_off,
                color: Colors.purple[200],
              ),
              onPressed: () {
                  setState(() {
                    passwordVisible1 = !passwordVisible1;
                  });
              },
            ),
          ),
          obscureText: passwordVisible1,
          key: controllerPasswordOld,
        ),
      ),
    );}

    Widget newPassword(){return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        leading: const Icon(Icons.lock),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: 'Contraseña nueva',
            //labelText: 'Contraseña',
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible2
                ? Icons.visibility
                : Icons.visibility_off,
                color: Colors.purple[200],
              ),
              onPressed: () {
                  setState(() {
                    passwordVisible2 = !passwordVisible2;
                  });
              },
            ),
          ),
          obscureText: passwordVisible2,
          key: controllerPassword,
        ),
      ),
    );}

    Widget services() {return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.store_mall_directory, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Agregar servicios',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ServicesPage()),);
                },
                color: Color(0xFF32bcd1),
              ),
            ],
          )
        ],
      ),
    );}

    Widget salir() {return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,20,20,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.close, color: Colors.white,),
                        SizedBox(width: 8,),
                        Text('Cerrar sesión',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  _Logout(context);
                },
                color: Colors.redAccent,
              ),
            ],
          )
        ],
      ),
    );}

    Widget guardar(){return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              updateUser(context);
            },
            color: Color(0xFF32bcd1),
          )
        ]
      )
    );}

    Widget change() {return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cambiar contraseña',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              changePassword(context);
            },
            color: Color(0xFF32bcd1),
          )
        ]
      )
    );}

    Widget contact_emergency() {return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Correo secundario',style: TextStyle(color:Color(0xFF32bcd1), fontSize: 20.0, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextFormField(
                decoration: InputDecoration(
                  hintText: 'correo secundario',
                  labelText: 'Correo'),
                  //initialValue: emergencia=="none"?"":emergencia,
                  keyboardType: TextInputType.text,
                  //key: _formEmergencyKey
              )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                        shape: StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Guardar',style: TextStyle(color: Colors.white))
                        ),
                        onPressed: (){},
                        color: Color(0xFF32bcd1),
                  )
                ]
              )
            ),
          ],
        ),
    );}
    //loading?ProgressIndicators.smallProgressIndicator(context):

    Widget pagoOnline() {return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
        color: Colors.white,
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        elevation: 8,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Pago Online',style: TextStyle(color:Color(0xFF32bcd1), fontSize: 20.0, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on_sharp),
              title: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cuenta Bancaria',
                  labelText: 'Cuenta Bancaria'),
                  initialValue: dataP[0].cuentaBancaria=="0"?'':dataP[0].cuentaBancaria,
                  keyboardType: TextInputType.text,
                  //key: _formEmergencyKey
                  key: controllerCuentaBancaria,
              )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    //height: 20.0,
                    margin: EdgeInsets.only(right:10),
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
                          'Habilitar Pago Online',
                          style: TextStyle(
                            color: Color(0xFF32bcd1),
                            fontWeight: FontWeight.bold,
                            //fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:10),
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Guardar',style: TextStyle(color: Colors.white))
                    ),
                    onPressed: (){
                      uploadCuentaBancaria(context);
                    },
                    color: Color(0xFF32bcd1),
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Nota 1: Para deshabilitar la opcion de pago online seleccionar guardar y para habilitarlo igualmente",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize:15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,                              
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Nota 2: Al habilitar el pago online este esta sujeto a descuentos de IGV y más",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize:15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,                              
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  child:Text("más información sobre los descuentos (Tocar)",style:TextStyle(color:Colors.blue)),
                  onTap: (){
                    _launchURL("https://culqi.zendesk.com/hc/es/articles/115004689893--Cómo-calculo-la-comisión-precio-de-Culqi-#:~:text=La%20comisión%20de%20Culqi%20es,0.98).");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Nota 3: El pago se le depositara en el transcurso del mes o a fines",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize:15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,                              
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
    );}

    return Builder(
      builder: (BuildContext context){
        return Scaffold(
          //resizeToAvoidBottomInset: false,
          body: Builder(
            builder: (BuildContext context) {
              return loading
            ?UtilityWidget.containerloadingIndicator(context)
            :Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondoRegistrar.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:25),
                      child: Center(
                        child: Stack(children: <Widget>[
                          CircleAvatar(
                            radius: 80.0,
                            backgroundImage: NetworkImage("http://0.0.0.0/servicio/${dataS[0].foto}"),
                          ),
                        ],
                        ),
                      ),
                    ),
                    Container(
                      height: 70.0,
                      width:500.0,
                      margin: EdgeInsets.only(top:10.0),
                      child: Column(
                        children:<Widget>[
                          Text(
                            dataS[0].nombre,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            dataS[0].email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,                              
                            ),
                          ),
                        ]
                      )
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          direction(),
                          telephone(),
                          guardar(),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          password(),
                          newPassword(),
                          change(),
                        ],
                      ),
                    ),
                    loading1?pagoOnline():Container(),
                    //contact_emergency(),
                    loading1?Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          uploadDni(context),
                          Text(
                            "Subir tu DNI",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(
                            "Nota: Subir archivos PDF ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ):Container(),
                    loading1?Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          uploadRecibo(context),
                          Text(
                            "Subir tu Recibo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 8,),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Escoger cualquier recibo de agua luz o telefono para verificar al usuario",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(
                            "Nota: Subir archivos PDF ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ):Container(),
                    loading1?Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          uploadFiles(context),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Nota: para solicitar verificación debe haber agregado su DNI y Recibo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,                              
                              ),
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ):Container(),
                    loading1?Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          services(),
                          Text(
                            "Agregar servicios",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(
                            "Esta opcion te permitira agregar sericios como maximo 5",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,                              
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ):Container(),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                      color: Colors.white,
                      margin: EdgeInsets.all(12),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      semanticContainer: true,
                      elevation: 8,
                      child: Column(
                        children: <Widget>[
                          salir(),
                          //SizedBox(height: 8,),
                          SizedBox(height: 18,),
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
    );
  }
}