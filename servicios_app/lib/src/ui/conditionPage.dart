import 'package:flutter/material.dart';

class ConditionPage extends StatefulWidget {
  ConditionPage({Key key}) : super(key: key);

  @override
  _ConditionPageState createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Condiciones generales", style: TextStyle(color: Colors.white,),),
            backgroundColor: Color(0xFF32bcd1),
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
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
                        "Condiciones generales",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:22.0,
                          color: Color(0xFF32bcd1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left:20.0,right:20.0),
                      child: Text(
                        "Política de privacidad",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        """La autenticidad y veracidad del Contenido generado por el Usuario es responsabilidad exclusiva de la persona que lo haya originado y, por lo tanto, CÍVICO no garantiza la autenticidad ni la veracidad de dichos Contenidos, ni la autoría de los mismos. Como consecuencia de lo anterior, el Usuario entiende y reconoce que accede y usa el Contenido disponible en la Plataforma bajo su propia cuenta y riesgo y, por lo tanto, el Usuario será el único responsable por cualquier daño o perjuicio que se cause a sí mismo o que les cause a terceros como consecuencia del uso del Contenido.
 
Al aceptar estos Términos de Uso, el Usuario acuerda y permite que CÍVICO pueda utilizar el Contenido generado por el Usuario de varias formas distintas en relación con la Plataforma, los Servicios, y su objeto social en general, según lo determine CÍVICO a su entera discreción, incluyendo, sin carácter restrictivo, publicándolo, reformateándolo, incorporándolo en material de marketing, publicidad y otros trabajos, creando trabajos derivados de él, promocionándolo, distribuyéndolo y permitiendo que otros Usuarios o terceros hagan lo mismo en relación con sus propios sitios web, plataformas multimedia y/o aplicaciones (los “Medios de Terceros”).
 
Al producir o enviar el Contenido generado por el Usuario a la Plataforma a través de los Servicios, el Usuario cede a favor de CÍVICO todos los derechos patrimoniales de autor sobre el Contenido, en toda la extensión y en las condiciones permitidas por la ley, y otorga una licencia mundial gratuita y sin límite de tiempo a favor de CÍVICO sobre cualquier derecho de propiedad industrial incorporado al Contenido que él genere, para que CÍVICO, directamente o a través o en asocio con terceros, (incluidos los demás Usuarios, los Medios de Terceros, clientes y/o los aliados de CIVICO), use, copie, edite, modifique, reproduzca, distribuya, prepare trabajos derivados, muestre, ejecute y explote el Contenido generado por el Usuario en relación con la Plataforma, los Servicios y el objeto social  de CÍVICO (y sus sucesores y cesionarios), entre otras finalidades, para la promoción y redistribución de parte o la totalidad de CÍVICO (y trabajos derivados del mismo), o de los Servicios en cualquier formato multimedia y a través de cualquier canal multimedia (incluyendo, entre otros, sitios web y feeds de terceros), o cualquier medio impreso, televisión y/o radio, entre otros canales de comunicación, o para cualquier otro propósito de carácter económico, cultural, político o de cualquier forma autorizada por CÍVICO, a los terceros y a los Medios de Terceros. Por este Contenido generado por el Usuario, el Usuario no recibirá contraprestación alguna por parte de CÍVICO.
 
La cesión de la titularidad sobre el Contenido implica, además, la renuncia expresa de los derechos del Usuario sobre el mismo, particularmente, el derecho a usar el Contenido por él generado con fines comerciales (salvo que medie autorización previa, expresa y escrita por parte de CÍVICO).
 
Al aceptar los presentes Términos de Uso, el Usuario además declara y garantiza que es titular de todos los derechos sobre el Contenido que ha generado y enviado a la Plataforma y que, por lo tanto, está legitimado para cederlos y/o licenciarlos a CÍVICO, sin infringir ni violar los derechos de terceros.
 
Al cerrar o eliminar la cuenta del Usuario por cualquier razón, el Contenido generado por el Usuario permanecerá en las bases de datos de CÍVICO por el tiempo que se considere pertinente por CÍVICO, excepto en el caso de los datos personales del Usuario, los cuales serán eliminados a la brevedad posible.
 
CÍVICO no está obligado a conservar una copia, en ningún medio o formato, del Contenido generado por el Usuario. El Usuario es responsable por la conservación de la versión original del Contenido que origine.
 
El Contenido generado por el Usuario, directamente o a través de la publicación que haga CÍVICO por instrucción del Usuario o en ejecución del contrato de fichas de negocio, es responsabilidad exclusiva del Usuario, cualquiera sea la naturaleza del Usuario o la calidad en que actúe el mismo. CÍVICO no se hace responsable por la veracidad, autenticidad, precisión y oportunidad del Contenido generado por el Usuario, ni por los daños o perjuicios que éste pueda causar a los Usuarios o a cualquier persona. CÍVICO tampoco se hace responsable por la veracidad, autenticidad, precisión y oportunidad del cumplimiento de los ofrecimientos, ofertas, promociones y demás publicaciones que hagan, ni sobre la calidad y oportunidad en el """,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:15.0,
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