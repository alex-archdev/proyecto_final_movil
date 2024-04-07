import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class SportSession extends StatelessWidget {
  const SportSession({super.key});

  @override
  Widget build(BuildContext context) {

    return DropdownButtonHideUnderline(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.blue[600],
            child: const Center(child: Text('Entry A')),
          ),
          Container(
            height: 50,
            color: Colors.red[500],
            child: const Center(child: Text('Entry B')),
          ),
          Container(
            height: 50,
            color: Colors.yellow[100],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      )
    );
  }
}