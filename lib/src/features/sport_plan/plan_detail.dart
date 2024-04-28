import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/features/sport_plan/active_plan.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_final_movil/src/providers/api_provider.dart';

class PlanDetail extends StatefulWidget {
  final ActivePlan singlePlan;
  final num totalTime;
  const PlanDetail({super.key, required this.singlePlan, required this.totalTime});

  @override
  State<PlanDetail> createState() {
    return _PlanDetailState();
  }
}

class _PlanDetailState extends State<PlanDetail> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addPlan(context) async {
    final client = http.Client();
    final planId = widget.singlePlan.idPlan;
    dynamic res = await _apiProvider.addPlan(context, client, planId);

    if (res['success'] == false) {
      log('error en la adición de un plan a la cuenta del usuario');
    } else {
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  widget.singlePlan.nombrePlan,
                style: const TextStyle(
                  fontSize: 28
                ),
              ),
            ),
            Text(widget.singlePlan.descripcion),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                  "Duracion total: ${widget.totalTime.toString()}",
                style: TextStyle(
                  backgroundColor: Colors.purple.shade100
                ),
              ),
            ),
            Scrollbar(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.singlePlan.ejercicios.length,
                    itemBuilder: (context, index) {
                      final item = widget.singlePlan.ejercicios[index];
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('plan_add_btn'),
        onPressed: () {
          addPlan(context);
        },
        child: const Text(
            'agregar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

