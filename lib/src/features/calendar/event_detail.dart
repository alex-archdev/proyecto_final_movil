import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/features/calendar/event_detail_dto.dart';

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
  bool startButton = false;
  bool timerOnce = true;
  bool exerciseStop = false;
  late int minutes;
  int seconds = 0;
  String isZero = '0';

  @override
  void initState() {
    super.initState();
    minutes = widget.totalDuration;
  }

  @override
  void dispose() {
    super.dispose();
    _startTimer().cancel();
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

  void startSendingMetrics() {
    setState(() {
      startButton = !startButton;
    });
    if (startButton & timerOnce) {
      timerOnce = false;
      _startTimer();
    }
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
    exerciseStop = true;
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
                    ElevatedButton(
                        key: const Key('start_session_btn'),
                        onPressed: () {
                          startSendingMetrics();
                        },
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

