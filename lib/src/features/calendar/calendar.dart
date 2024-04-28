import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_final_movil/src/features/calendar/agendar_event.dart';
import 'package:proyecto_final_movil/src/features/calendar/event.dart';
import 'package:proyecto_final_movil/src/features/calendar/event_detail.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'event_detail_dto.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final ApiProvider _apiProvider = ApiProvider();
  late int totalDuration = 0;
  List<Event>? manyEventSameDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late ActiveSession session = ActiveSession(descripcion: '', nombrePlan: '', ejercicios: [], idPlan: '');
  Map<DateTime, List<Event>> events = {};
  /*Map<DateTime, List<Event>> events = {
    DateTime.parse('2024-04-20 00:00:00.000Z'): [
      Event('prueba uno'),
      Event('prueba dos')
    ],
    DateTime.parse('2024-04-22 00:00:00.000Z'): [
      Event('prueba tres'),
      Event('prueba cuatro')
    ]
  };*/

  @override
  void initState() {
    super.initState();
    getSessions(context);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _showMessage(BuildContext context, message) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.api_loader_title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok')
          )
        ],
      );
    });
  }

  Future<void> getSessions(context) async {
    final client = http.Client();
    Map<DateTime, List<Event>> convertedData = {};
    dynamic res = await _apiProvider.myScheduledPlans(context, client);

    if (res['success'] == false) {
      log('error en la obtencion de la lista de calendario');
    } else {
      List<dynamic> data = res['response']['result'];
      for (var element in data) {
        if (element['fecha_sesion'] == null) {
          continue;
        }
        String onlyDate = element['fecha_sesion'].split('T')[0];
        String sessionDate = "$onlyDate 00:00:00.000Z";
        if (element['fecha_inicio'] == null) {
          element['fecha_inicio'] = '';
        }
        if (element['fecha_fin'] == null) {
          element['fecha_fin'] = '';
        }
        if (convertedData[DateTime.parse(sessionDate)] == null) {
          convertedData[DateTime.parse(sessionDate)] = [];
        }
        convertedData[DateTime.parse(sessionDate)]?.add(Event(title: element['estado'], startTime: element['fecha_inicio'], endTime: element['fecha_fin'], planId: element['id_plan_deportista']));
      }
   }
    setState(() {
      events = convertedData;
    });
  }

  Future<void> getSingleSession(context, planId, state, index) async {
    if (state == 'finalizada') {
      _showMessage(context, 'Este evento ya ha finalizado');
      return;
    }

    final client = http.Client();
    dynamic res = await _apiProvider.myScheduledSingleSession(context, client, planId);

    if (res['success'] == false) {
      print('error obteniendo la sesion individual para comenzar el ejercicio');
      return;
    }

    if (res['response'].isEmpty) {
      _showMessage(context, 'No existen datos de la sesion');
      print('ho hay datos en la sesion individual');
      return;
    }

    // var data = {
    //   "descripcion": "Combina Carrera de Fartlek, Entrenamiento de Intervalos y Recuperación activa para mejorar la resistencia y velocidad.",
    //   "ejercicios": [
    //     {
    //       "deporte_id": "fda259e4-e392-480b-99f6-1f5ffaa30134",
    //       "deporte_nombre": "Atletismo",
    //       "ejercicio_descripcion": "Entrenamiento de carrera que combina intervalos de velocidad variable con períodos de carrera continua.",
    //       "ejercicio_duracion": 20,
    //       "ejercicio_id": "07b2bc68-cc38-4158-ad2b-c7856c701208",
    //       "ejercicio_nombre": "Carrera de Fartlek"
    //     },
    //     {
    //       "deporte_id": "fda259e4-e392-480b-99f6-1f5ffaa30134",
    //       "deporte_nombre": "Atletismo",
    //       "ejercicio_descripcion": "Mejora la resistencia y la velocidad.",
    //       "ejercicio_duracion": 25,
    //       "ejercicio_id": "2c2f702c-37ed-4177-b3da-98fae152144c",
    //       "ejercicio_nombre": "Entrenamiento de Intervalos"
    //     },
    //     {
    //       "deporte_id": "fda259e4-e392-480b-99f6-1f5ffaa30134",
    //       "deporte_nombre": "Atletismo",
    //       "ejercicio_descripcion": "Sesión de recuperación ligera. Trote suave y estiramientos para facilitar la recuperación muscular.",
    //       "ejercicio_duracion": 30,
    //       "ejercicio_id": "e6635689-6142-4ac7-96c5-e6428653891f",
    //       "ejercicio_nombre": "Recuperación activa runner"
    //     }
    //   ],
    //   "id_plan": "e5e0b1cc-dd13-43eb-bf9c-49bca0951101",
    //   "nombre_plan": "Resistencia Runner",
    //   "vo2": 45
    // };

    setState(() {
      session = ActiveSession.fromJson(res['response']);
    });
    int total = 0;
    for(var singleExercise in session.ejercicios) {
      total = total + singleExercise.ejercicioDuracion;
    }
    setState(() {
      totalDuration = total;
    });

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventDetail(session: session, totalDuration: totalDuration, index:index)));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // log("day is $day");
    // retrieve all event from the selected day
    return events[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = DateTimeRange(start: start, end: end);

    return [
      for (final d in days.toString().characters) ..._getEventsForDay(d as DateTime),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Future<void> _navigateScheduleEvent(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScheduleEvent())
    );
    if (!context.mounted) return;
    getSessions(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.menu_sport_calendar),
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
            onPressed: () {
              _navigateScheduleEvent(context);
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         scrollable: true,
              //         title: Text('event name'),
              //         content: Padding(
              //           padding: EdgeInsets.all(8),
              //           child: TextField(
              //             controller: _eventController,
              //           )
              //         ),
              //         actions: [
              //           ElevatedButton(
              //               onPressed: () {
              //                 if (events[_selectedDay] != null) {
              //                   manyEventSameDay = events[_selectedDay]!;
              //                   events.addAll({
              //                     _selectedDay!: [
              //                       ...manyEventSameDay!,
              //                       ...[Event(_eventController.text)]
              //                     ],
              //                   });
              //                 } else {
              //                   events.addAll({
              //                     _selectedDay!: [Event(_eventController.text)],
              //                   });
              //                 }
              //                 _eventController.text = "";
              //                 Navigator.of(context).pop();
              //                 _selectedEvents.value = _getEventsForDay(_selectedDay!);
              //               },
              //               child: const Text('Submit')
              //           )
              //         ],
              //       );
              // });
            },
            child: const Icon(Icons.add)
        ),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            key: const Key('session_plan_calendar'),
            locale: locale,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2050, 10, 16),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => {
                          getSingleSession(context, value[index].planId, value[index].title, index)
                        },
                        title: Column(
                          children: [
                            Text("${AppLocalizations.of(context)!.event_description}: ${value[index].title}"),
                            Text("${AppLocalizations.of(context)!.event_init_time}: ${value[index].startTime}"),
                            Text("${AppLocalizations.of(context)!.event_end_time}: ${value[index].endTime}")
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}