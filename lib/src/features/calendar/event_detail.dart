import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/features/calendar/event_detail_dto.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../providers/notification_helper.dart';

class EventDetail extends StatefulWidget {
  final ActiveSession session;
  final int index;
  final int totalDuration;
  const EventDetail({super.key, required this.index, required this.session, required this.totalDuration});

  @override
  State<EventDetail> createState() {
    return _EventDetailState();
  }
}

class _EventDetailState extends State<EventDetail> {
  final ApiProvider _apiProvider = ApiProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool startButton = false;
  bool timerOnce = true;
  bool exerciseStop = false;
  late int minutes;
  int seconds = 0;
  int vo2 = 0;
  int ftp = 0;
  String isZero = '0';
  Random rand = Random();

  @override
  void initState() {
    super.initState();
    minutes = widget.totalDuration;
    LocalNotification.initialize();
    if (context.mounted) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        LocalNotification.showNotification(message, context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _startTimer().cancel();
    _startSendingMetrics().cancel();
  }

  // Future<void> _saveActiveSession(token) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   Map<String, dynamic> activeSession = {
  //     "index": widget.index,
  //     'totalTime': widget.totalTime,
  //     'timeRemain': widget.timeRemain,
  //     'session': widget.singlePlan
  //   };
  //   await pref.setString('activeSession', jsonEncode(activeSession));
  // }
  Future<void> _startExercice() async {
    final client = http.Client();
    final String? deviceId = await _firebaseMessaging.getToken();
    dynamic data = {
      'planId': widget.session.idSession,
      'deviceId': deviceId
    };
    dynamic res = await _apiProvider.startSession(context, client, data);
  }

  Future<void> _stopExercice() async {
    final client = http.Client();
    DateTime today = DateTime.now();
    dynamic data = {
      'planId': widget.session.idSession,
      'fecha_inicio': today.toString(),
      'fecha_fin': today.toString()
    };
    dynamic res = await _apiProvider.stopSession(context, client, data);
    dynamic food = {};
    if (res['success'] == false) {
      print('error en la obtencion de la lista de calendario');
    } else {
      food['alimentos'] = [];
      food['metricas'] = [];
      Map<String, dynamic> data = res['response']['result'];
      for (var element in data['alimentos']) {
        food['alimentos'].add("alimento: ${element['menu_nombre']}, calorias: ${element['menu_calorias']}");
      }
      food['metricas'].add("ftp: ${data['ftp']}");
      food['metricas'].add("vo2: ${data['vo2']}");
      _showResume(context, food);
    }
  }

  Future<void> _sendMetrics(incomingData) async {
    final client = http.Client();
    dynamic data = {
      'planId': widget.session.idSession,
      'vo2': incomingData['vo2'],
      'ftp': incomingData['ftp']
    };
    dynamic res = await _apiProvider.sendMetric(context, client, data);
  }

  void startSendingMetrics() {
    setState(() {
      startButton = !startButton;
    });
    if (startButton & timerOnce) {
      timerOnce = false;
      _startExercice();
      _startSendingMetrics();
      _startTimer();
    }
  }

  Future<void> _showResume(BuildContext context, data) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Resumen de la actividad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Medidas tomadas',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            for (var i = 0; i < data['metricas'].length; i++) Text(data['metricas'][i]),
            const SizedBox(
              height: 15,
            ),
            const Text(
                'Alimentos recomendados',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            for (var i = 0; i < data['alimentos'].length; i++) Text(data['alimentos'][i])
          ],
        ),
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

  Future<void> _showMessage(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.api_loader_title),
        content: Text(AppLocalizations.of(context)!.active_session_dialog_message),
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

  void _doBeforeBack() {
    if (exerciseStop || timerOnce) {
      Navigator.pop(context);
      return;
    }
    _showMessage(context);
  }

  void stopSession() {
    setState(() {
      exerciseStop = true;
    });
    _stopExercice();
  }

  Timer _startTimer () {
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!startButton || exerciseStop) {
        return;
      }
      if (seconds == 0) {
        minutes--;
        isZero = '';
        seconds= 60;
      }
      if (minutes <= 0) {
        return;
      }
      if (seconds < 11) {
        isZero = '0';
      }
      if (mounted) {
        setState(() {
          seconds--;
        });
      }
    });

    return timer;
  }

  Timer _startSendingMetrics () {
    var timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!startButton || exerciseStop) {
        return;
      }
      vo2 = rand.nextInt(50) + 30;
      ftp = rand.nextInt(50) + 30;
      dynamic data = {
        'vo2': vo2,
        'ftp': ftp
      };
      if (mounted) {
        _sendMetrics(data);
        setState(() {
          vo2;
          ftp;
        });
      }
    });

    return timer;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _doBeforeBack();
      },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.menu_sport_plan_page),
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    widget.session.nombrePlan,
                    style: const TextStyle(
                        fontSize: 28
                    ),
                  ),
                ),
                Text(widget.session.descripcion),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    "Duracion total: ${widget.totalDuration.toString()}",
                    style: TextStyle(
                        backgroundColor: Colors.purple.shade100,
                        fontSize: 25
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '$minutes:$isZero$seconds',
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 60
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Vo2: $vo2',
                      style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30
                      ),
                    ),
                    Text(
                      'Ftp: $ftp',
                      style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        key: const Key('start_session_btn'),
                        onPressed: exerciseStop ? null : () { startSendingMetrics();},
                        child: startButton ? Text(AppLocalizations.of(context)!.active_session_pause_button) : Text(AppLocalizations.of(context)!.active_session_start_button)
                    ),
                    ElevatedButton(
                        onPressed: () {
                          stopSession();
                        },
                        child: Text(AppLocalizations.of(context)!.active_session_stop_button)
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: widget.session.ejercicios.length,
                        itemBuilder: (context, index) {
                          final item = widget.session.ejercicios[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              children: [
                                Text("Nombre: ${item.ejercicioNombre}"),
                                Text("Descripcion: ${item.ejercicioDescripcion}"),
                                Text("Duracion: ${item.ejercicioDuracion.toString()}")
                              ],
                            ),
                          );
                        }
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}

