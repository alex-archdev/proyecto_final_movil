import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static const String url = String.fromEnvironment('BASE_URL', defaultValue: 'http://k8s-ekssport-sportapp-a5d22e537b-139954850.us-east-1.elb.amazonaws.com');

  Future<void> _saveToken(token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
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


  Future<dynamic> login(BuildContext context, http.Client client, String email, String password) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      barrierDismissible: true,
      msg: AppLocalizations.of(context)!.api_waiting_loader,
      hideValue: true,
    );
    try {
      String basePassword = base64.encode(utf8.encode(password));
      final response = await client.post(
          Uri.parse("$url/registro-usuarios/login/deportista"),
          headers: {
            "content-type" : "application/json",
            "accept" : "application/json",
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'contrasena': basePassword
          })
      );
      if (!context.mounted) return;

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
}