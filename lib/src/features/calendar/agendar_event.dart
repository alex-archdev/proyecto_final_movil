import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:http/http.dart' as http;

import '../sport_sesion/active_sessions.dart';

class ScheduleEvent extends StatefulWidget {
  const ScheduleEvent({super.key});

  @override
  State<ScheduleEvent> createState() {
    return _ScheduleEventState();
  }
}

class _ScheduleEventState extends State<ScheduleEvent> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay _time1 = const TimeOfDay(hour: 7, minute: 15);
  TimeOfDay _time2 = const TimeOfDay(hour: 7, minute: 15);
  final TextEditingController _eventDescription = TextEditingController();
  final TextEditingController _eventDate = TextEditingController();
  final TextEditingController _eventInitTime = TextEditingController();
  final TextEditingController _eventEndTime = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();
  late List<ActiveSessionPlan> items = [];
  late ActiveSessionPlan selectedPlan;

  String planName = '';

  @override
  void initState() {
    super.initState();
    getItems(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getItems(context) async {
    final client = http.Client();
    dynamic res = await _apiProvider.myPlans(context, client);

    if (res['success'] == false) {
      log('error en la obtencion de la lista de calendario');
    } else {
      setState(() {
        items = ActiveSessionPlanList.fromJson(res['response']).plans;
      });
    }

  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _eventDate.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _selectTimeOne() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time1,
    );
    if (newTime != null) {
      setState(() {
        _time1 = newTime;
        _eventInitTime.text = _time1.format(context);
      });
    }
  }

  void _selectTimeTwo() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time2,
    );
    if (newTime != null) {
      setState(() {
        _time2 = newTime;
        _eventEndTime.text = _time2.format(context);
      });
    }
  }

  Future<void> schedulePlan(context) async {
    final client = http.Client();
    String planId = selectedPlan.idPlan;
    String date = _eventDate.text;
    dynamic res = await _apiProvider.schedulePlan(context, client, planId, date);
    if (res['success'] == false) {
      log('error en la obtencion de la lista de calendario');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.schedule_event_title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: Scrollbar(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            key: const Key('sport_plan_item'),
                            leading: const Icon(
                              Icons.run_circle_outlined,
                              size: 60,
                            ),
                            onTap: () => {
                              _eventDescription.text = item.descripcion,
                              selectedPlan = item
                            },
                            title: Text("${AppLocalizations.of(context)!.event_description} ${item.descripcion}"),
                            subtitle: Text(
                              "${AppLocalizations.of(context)!.plan_name} ${item.nombrePlan}",
                            ),
                            shape: const Border(bottom: BorderSide()),
                          );
                        }))),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 5,
              endIndent: 5,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                children: [
                  TextFormField(
                    maxLines: null,
                    readOnly: true,
                    controller: _eventDescription,
                    canRequestFocus: false,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.event_description,
                      labelStyle: const TextStyle(color: Colors.purple),
                      // prefixIcon: Icon(
                      //   Icons.mail,
                      //   size: SizeConfig.defaultSize * 2,
                      //   color: Colors.purple,
                      // ),
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.deepPurple)),
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _eventDate,
                    canRequestFocus: false,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.event_date,
                        labelStyle: const TextStyle(color: Colors.purple),
                        // prefixIcon: Icon(
                        //   Icons.mail,
                        //   size: SizeConfig.defaultSize * 2,
                        //   color: Colors.purple,
                        // ),
                        filled: false,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple)),
                        suffixIcon: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.edit),
                        )),
                  ),
                  // TextFormField(
                  //   readOnly: true,
                  //   controller: _eventInitTime,
                  //   canRequestFocus: false,
                  //   decoration: InputDecoration(
                  //       labelText:
                  //           AppLocalizations.of(context)!.event_init_time,
                  //       labelStyle: const TextStyle(color: Colors.purple),
                  //       // prefixIcon: Icon(
                  //       //   Icons.mail,
                  //       //   size: SizeConfig.defaultSize * 2,
                  //       //   color: Colors.purple,
                  //       // ),
                  //       filled: false,
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //           borderSide:
                  //               const BorderSide(color: Colors.deepPurple)),
                  //       suffixIcon: IconButton(
                  //         onPressed: _selectTimeOne,
                  //         icon: Icon(Icons.edit),
                  //       )),
                  // ),
                  // TextFormField(
                  //   readOnly: true,
                  //   controller: _eventEndTime,
                  //   canRequestFocus: false,
                  //   decoration: InputDecoration(
                  //       labelText:
                  //           AppLocalizations.of(context)!.event_end_time,
                  //       labelStyle: const TextStyle(color: Colors.purple),
                  //       // prefixIcon: Icon(
                  //       //   Icons.mail,
                  //       //   size: SizeConfig.defaultSize * 2,
                  //       //   color: Colors.purple,
                  //       // ),
                  //       filled: false,
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //           borderSide:
                  //               const BorderSide(color: Colors.deepPurple)),
                  //       suffixIcon: IconButton(
                  //         onPressed: _selectTimeTwo,
                  //         icon: Icon(Icons.edit),
                  //       )),
                  // ),
                ],
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _eventDate.text != '',
        child: FloatingActionButton(
          onPressed: () {
            schedulePlan(context);
          },
          child: const Icon(Icons.save),
        ),
      )
    );
  }
}
