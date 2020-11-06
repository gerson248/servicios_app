import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:servicios_app/src/ui/servicesPage.dart';

Future<TimeOfDay> _selectTime(BuildContext context,
    {@required DateTime initialDate}) {
  final now = DateTime.now();

  return showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: initialDate.hour, minute: initialDate.minute),
  );
}

Future<DateTime> _selectDateTime(BuildContext context,
    {@required DateTime initialDate}) {
  final now = DateTime.now();
  final newestDate = initialDate.isAfter(now) ? initialDate : now;

  return showDatePicker(
    context: context,
    initialDate: newestDate.add(Duration(seconds: 1)),
    firstDate: now,
    lastDate: DateTime(2100),
  );
}

Dialog showDateTimeDialog(
  BuildContext context, {
  @required ValueChanged<DateTime> onSelectedDate,
  @required DateTime initialDate,
  @required String id,
  @required String dias,
  @required String horario,
}) {
  final dialog = Dialog(
    child: DateTimeDialog(
        onSelectedDate: onSelectedDate, initialDate: initialDate, id:id, dias: dias, horario: horario,),
  );

  showDialog(context: context, builder: (BuildContext context) => dialog);
}

class DateTimeDialog extends StatefulWidget {
  final ValueChanged<DateTime> onSelectedDate;
  final DateTime initialDate;
  final String id;
  final String dias;
  final String horario;

  const DateTimeDialog({
    @required this.onSelectedDate,
    @required this.initialDate,
    @required this.id,
    @required this.dias,
    @required this.horario,
    Key key,
  }) : super(key: key);
  @override
  _DateTimeDialogState createState() => _DateTimeDialogState();
}

class _DateTimeDialogState extends State<DateTimeDialog> {

  DateTime selectedDate1;
  DateTime selectedDate2;

  Color warma= Color(0xFF32bcd1);
  Color warma1=Color(0xFF32bcd1);
  Color warma2=Color(0xFF32bcd1);
  Color warma3=Color(0xFF32bcd1);
  Color warma4=Color(0xFF32bcd1);
  Color warma5=Color(0xFF32bcd1);
  Color warma6=Color(0xFF32bcd1);

  /*TextEditingController controllerLunes = new TextEditingController();
  TextEditingController controllerMartes = new TextEditingController();
  TextEditingController controllerMiercoles= new TextEditingController();
  TextEditingController controllerJueves = new TextEditingController();
  TextEditingController controllerViernes = new TextEditingController();
  TextEditingController controllerSabado = new TextEditingController();
  TextEditingController controllerDomingo = new TextEditingController();
  TextEditingController controllerHorainicio = new TextEditingController();
  TextEditingController controllerHorafin = new TextEditingController();*/

  String controllerLunes = "";
  String controllerMartes = "";
  String controllerMiercoles= "";
  String controllerJueves = "";
  String controllerViernes = "";
  String controllerSabado = "";
  String controllerDomingo = "";
  String days;
  String controllerHorainicio = DateFormat('HH:mm').format(DateTime.now());
  String controllerHorafin = DateFormat('HH:mm').format(DateTime.now());
  
  @override
  void initState() {
    super.initState();

    selectedDate1 = widget.initialDate;
    selectedDate2 = widget.initialDate;
  }

  Future addHorarioServicio() async{
    days= controllerLunes + " " + controllerMartes + " " +controllerMiercoles + " " +controllerJueves + " " +controllerViernes +
    " " +controllerSabado + " " +controllerDomingo;

    final response1 = await http.post("http://0.0.0.0/servicio/addSchedule.php", body: {
      "id":widget.id,
      "dias":days,
      "horario": controllerHorainicio + " - " + controllerHorafin,
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => ServicesPage()));

  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Seleccionar dias',
                style: Theme.of(context).textTheme.title,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: warma,
                    child: Text("Lunes",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma==Colors.purple){
                          warma=Color(0xFF32bcd1);
                          controllerLunes = "";
                        }else{
                          warma=Colors.purple;
                          controllerLunes = "lunes";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  RaisedButton(
                    color: warma1,
                    child: Text("Martes",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma1==Colors.purple){
                          warma1=Color(0xFF32bcd1);
                          controllerMartes = "";
                        }else{
                          warma1=Colors.purple;
                          controllerMartes = "Martes";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: warma2,
                    child: Text("Miercoles",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma2==Colors.purple){
                          warma2=Color(0xFF32bcd1);
                          controllerMiercoles = "";
                        }else{
                          warma2=Colors.purple;
                          controllerMiercoles = "Miercoles";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  RaisedButton(
                    color: warma3,
                    child: Text("Jueves",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma3==Colors.purple){
                          warma3=Color(0xFF32bcd1);
                          controllerJueves = "";
                        }else{
                          warma3=Colors.purple;
                          controllerJueves = "Jueves";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: warma4,
                    child: Text("Viernes",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma4==Colors.purple){
                          warma4=Color(0xFF32bcd1);
                          controllerViernes = "";
                        }else{
                          warma4=Colors.purple;
                          controllerViernes = "Viernes";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  RaisedButton(
                    color: warma5,
                    child: Text("Sabado",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma5==Colors.purple){
                          warma5=Color(0xFF32bcd1);
                          controllerSabado = "";
                        }else{
                          warma5=Colors.purple;
                          controllerSabado = "Sabado";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: warma6,
                    child: Text("Domingo",style: TextStyle(color:Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(warma6==Colors.purple){
                          warma6=Color(0xFF32bcd1);
                          controllerDomingo = "";
                        }else{
                          warma6=Colors.purple;
                          controllerDomingo = "Domingo";
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Seleccionar horario',
                style: Theme.of(context).textTheme.title,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //const SizedBox(width: 55),
                  Text(
                    'Hora inicio',
                    style: TextStyle(fontSize:15.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 35),
                  Text(
                    'Hora fin',
                    style: TextStyle(fontSize:15.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(DateFormat('HH:mm').format(selectedDate1)),
                    onPressed: () async {
                      final time =
                          await _selectTime(context, initialDate: selectedDate1);
                      if (time == null) return;

                      setState(() {
                        selectedDate1 = DateTime(
                          selectedDate1.year,
                          selectedDate1.month,
                          selectedDate1.day,
                          time.hour,
                          time.minute,
                        );
                      });

                      widget.onSelectedDate(selectedDate1);
                      controllerHorainicio = DateFormat('HH:mm').format(selectedDate1);
                      //print(DateFormat('HH:mm').format(selectedDate1) + "HOlaaaa1");
                    },
                  ),
                  const SizedBox(width: 8),
                  RaisedButton(
                    child: Text(DateFormat('HH:mm').format(selectedDate2)),
                    onPressed: () async {
                      final time =
                          await _selectTime(context, initialDate: selectedDate2);
                      if (time == null) return;

                      setState(() {
                        selectedDate2 = DateTime(
                          selectedDate2.year,
                          selectedDate2.month,
                          selectedDate2.day,
                          time.hour,
                          time.minute,
                        );
                      });

                      widget.onSelectedDate(selectedDate2);
                      controllerHorafin = DateFormat('HH:mm').format(selectedDate2);
                      print(DateFormat('HH:mm').format(selectedDate2) + "HOlaaaa2");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Horario establecido',
                style: Theme.of(context).textTheme.title,
              ),
              const SizedBox(height: 16),
              Text(
                widget.dias == "      " || widget.dias == "0"? "No se selecciono dia" : widget.dias,
                style: TextStyle(fontSize:15.0, fontWeight: FontWeight.w600,),
              ),
              const SizedBox(height: 16),
              Text(
                widget.horario == "      " || widget.horario == "0"? "No se selecciono horario" : widget.horario,
                style: TextStyle(fontSize:15.0, fontWeight: FontWeight.w600),
                //textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              RaisedButton(
                shape: StadiumBorder(),
                color: Color(0xFF32bcd1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Guardar',style: TextStyle(color: Colors.white))
                ),
                onPressed: (){
                  addHorarioServicio();
                },
              ),
            ],
          ),
        ),
      );
}