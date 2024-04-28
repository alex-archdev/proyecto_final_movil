import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/features/sport_plan/active_plan.dart';
import 'package:proyecto_final_movil/src/features/sport_plan/plan_detail.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SportPlan extends StatefulWidget {
  const SportPlan({super.key});

  @override
  State<SportPlan> createState() {
    return _SportPlanState();
  }
}

class _SportPlanState extends State<SportPlan> {
  late List<ActivePlan> items = [];
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
        items = ActivePlanList.fromJson(res['response']).plans;
      });
    }

  }

  num _getTotal(exercises) {
    num total = 0;
    for(var singleExercice in exercises) {
      total = total + singleExercice.ejercicioDuracion;
    }
    return total;
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
                  key: const Key('sport_plan_item'),
                  leading: const Icon(
                      Icons.run_circle_outlined,
                    size: 60,
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanDetail(singlePlan: item, totalTime: _getTotal(item.ejercicios))))
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

