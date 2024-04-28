import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;

import '../features/authentication/login_register.dart';

class ApiProvider {
  static const String url = String.fromEnvironment('BASE_URL', defaultValue: 'http://k8s-ekssport-sportapp-a5d22e537b-1623025658.us-east-1.elb.amazonaws.com');

  Future<void> _saveToken(token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
  }

  Future<String?> _getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  Future<void> _deletePref(context) async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginRegister()),
            (route) => false
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.api_loader_title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<dynamic> login(BuildContext context, http.Client client, String email, String password, String deviceId) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: AppLocalizations.of(context)!.api_waiting_loader,
      hideValue: true,
    );
    try {
      String basePassword = base64.encode(utf8.encode(password));
      String loginUrl = "$url/registro-usuarios/login/deportista";
      final response = await client.post(
          Uri.parse(loginUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'contrasena': basePassword,
            'deviceId': deviceId
          })
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $loginUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          pd.close();
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          _saveToken(jsonResponse['response']['token']);
          return jsonResponse;
        case 401:
          pd.close();
          _dialogBuilder(context, AppLocalizations.of(context)!.invalid_credendials);
          jsonResponse = {'success': true, 'response': ''};
          return jsonResponse;
        case 422:
          pd.close();
          _dialogBuilder(context, AppLocalizations.of(context)!.invalid_credendials);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          pd.close();
          _dialogBuilder(context, AppLocalizations.of(context)!.invalid_credendials);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      pd.close();
      _dialogBuilder(context, AppLocalizations.of(context)!.no_internet);
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      pd.close();
      _dialogBuilder(context, AppLocalizations.of(context)!.server_error);
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> listOpenPlans(BuildContext context, http.Client client) async {
    try {
      var listaUrl = "$url/gestor-usuarios/planes/obtener_planes_deportivos";
      var authToken = _getToken() ;
      final response = await client.get(
          Uri.parse(listaUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "authorization": "Bearer $authToken"
          }
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $listaUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> addPlan(BuildContext context, http.Client client, String planId) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: AppLocalizations.of(context)!.api_waiting_loader,
      hideValue: true,
    );
    try {
      var guardarPlanUrl = "$url/gestor-usuarios/planes/agregar_plan_deportivo";
      var authToken = await _getToken();
      final response = await client.post(
          Uri.parse(guardarPlanUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "Authorization": "Bearer $authToken"
          },
        body: jsonEncode(<String, String>{
          'id_plan': planId
        })
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $guardarPlanUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          pd.close();
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          pd.close();
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          pd.close();
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          pd.close();
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      pd.close();
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      pd.close();
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> myPlans(BuildContext context, http.Client client) async {
    try {
      var activePlansUrl = "$url/gestor-usuarios/planes/obtener_planes_deportista";
      var authToken = await _getToken() ;
      final response = await client.get(
          Uri.parse(activePlansUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "authorization": "Bearer $authToken"
          }
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $activePlansUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> schedulePlan(BuildContext context, http.Client client, String planId, String planDate) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: AppLocalizations.of(context)!.api_waiting_loader,
      hideValue: true,
    );
    try {
      var scheduleUrl = "$url/gestor-sesion-deportiva/sesiones/agendar_sesion";
      var authToken = await _getToken();
      final response = await client.post(
          Uri.parse(scheduleUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "Authorization": "Bearer $authToken"
          },
          body: jsonEncode(<String, String>{
            'id_plan_deportista': planId,
            'fecha_sesion': planDate
          })
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $scheduleUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          pd.close();
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          pd.close();
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          pd.close();
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          pd.close();
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      pd.close();
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      pd.close();
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> myScheduledPlans(BuildContext context, http.Client client) async {
    try {
      var scheduledPlansUrl = "$url/gestor-sesion-deportiva/sesiones/obtener_sesiones_deportista";
      var authToken = await _getToken() ;
      final response = await client.get(
          Uri.parse(scheduledPlansUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "authorization": "Bearer $authToken"
          }
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $scheduledPlansUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }

  Future<dynamic> myScheduledSingleSession(BuildContext context, http.Client client, String planId) async {
    try {
      var scheduledPlansUrl = "$url/gestor-usuarios/planes/obtener_ejercicios_plan_deportista/$planId";
      var authToken = await _getToken() ;
      final response = await client.get(
          Uri.parse(scheduledPlansUrl),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
            "authorization": "Bearer $authToken"
          }
      );
      if (!context.mounted) return;

      var code = response.statusCode;
      log("url: $scheduledPlansUrl");
      log("status: $code");

      dynamic result, jsonResponse;
      switch (response.statusCode) {
        case 200:
        case 201:
          result = jsonDecode(response.body);
          jsonResponse = {'success': true, 'response': result};
          return jsonResponse;
        case 401:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        case 403:
          _deletePref(context);
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
        default:
          jsonResponse = {'success': false, 'response': ''};
          return jsonResponse;
      }
    } on SocketException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    } on HttpException {
      final jsonResponse = {'success': false, 'response': ''};
      return jsonResponse;
    }
  }
}