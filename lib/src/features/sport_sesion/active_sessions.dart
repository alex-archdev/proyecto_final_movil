class ActiveSessionPlanList {
  final List<ActiveSessionPlan> plans;
  ActiveSessionPlanList({required this.plans});
  factory ActiveSessionPlanList.fromJson(List<dynamic> parsedJson) {
    List<ActiveSessionPlan> activePlans = parsedJson.map((i) => ActiveSessionPlan.fromJson(i)).toList();
    return ActiveSessionPlanList(plans: activePlans);
  }
}

class ActiveSessionPlan {
  final String descripcion;
  final String nombrePlan;
  final String idPlan;
  final List<Exercises> ejercicios;

  ActiveSessionPlan({
    required this.descripcion,
    required this.nombrePlan,
    required this.ejercicios,
    required this.idPlan
  });
  factory ActiveSessionPlan.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['ejercicios'] as List;
    List<Exercises> exerciceList = list.map((i) => Exercises.fromJson(i)).toList();
    return ActiveSessionPlan(
        descripcion: parsedJson['descripcion'],
        nombrePlan: parsedJson['nombre_plan'],
        idPlan: parsedJson['id_plan'],
        ejercicios: exerciceList
    );
  }
}

class Exercises {
  final String deporteId;
  final String deporteNombre;
  final String ejercicioDescripcion;
  final int ejercicioDuracion;
  final String ejercicioId;
  final String ejercicioNombre;

  Exercises({
    required this.deporteId,
    required this.deporteNombre,
    required this.ejercicioDescripcion,
    required this.ejercicioDuracion,
    required this.ejercicioId,
    required this.ejercicioNombre
  });

  factory Exercises.fromJson(Map<String, dynamic> parsedJson) {
    return Exercises(
      deporteId: parsedJson['deporte_id'],
      deporteNombre: parsedJson['deporte_nombre'],
      ejercicioDescripcion: parsedJson['deporte_nombre'],
      ejercicioDuracion: parsedJson['ejercicio_duracion'],
      ejercicioId: parsedJson['ejercicio_id'],
      ejercicioNombre: parsedJson['ejercicio_nombre']
    );
  }
}