import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/features/sport_sesion/active_sessions.dart';
import 'package:proyecto_final_movil/src/features/sport_sesion/session_detail.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SessionPlan extends StatefulWidget {
  const SessionPlan({super.key});

  @override
  State<SessionPlan> createState() {
    return _SessionPlanState();
  }
}

class _SessionPlanState extends State<SessionPlan> {
  late List<ActiveSessionPlan> items = [];
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    getActivePlans(context);
  }

  Future<void> getActivePlans(context) async {
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

  int _getTotal(exercises) {
    num total = 0;
    for(var singleExercise in exercises) {
      total = total + singleExercise.ejercicioDuracion;
    }
    return total.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Scrollbar(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  key: const Key('session_plan_item'),
                  leading: const Icon(
                      Icons.run_circle_outlined,
                    size: 60,
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SessionDetail(singlePlan: item, totalTime: _getTotal(item.ejercicios), timeRemain: 0, index:index)))
                  },
                  title: Text("${AppLocalizations.of(context)!.event_description} ${item.descripcion}"),
                  subtitle: Text(
                      "${AppLocalizations.of(context)!.plan_name} ${item.nombrePlan}",
                  ),
                  shape: const Border(bottom: BorderSide()),
                );
              }
          )
      )
    );
  }
}

