class ActiveSession {
  final String descripcion;
  final String nombrePlan;
  final String idPlan;
  final List<Exercises> ejercicios;

  ActiveSession({
    required this.descripcion,
    required this.nombrePlan,
    required this.ejercicios,
    required this.idPlan
  });
  factory ActiveSession.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['ejercicios'] as List;
    List<Exercises> exerciceList = list.map((i) => Exercises.fromJson(i)).toList();
    return ActiveSession(
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