import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/widgets/screen_size_config.dart';
import 'package:proyecto_final_movil/src/features/calendar/calendar.dart';
import 'package:proyecto_final_movil/src/features/sport_sesion/sport_session.dart';
import 'package:proyecto_final_movil/src/features/authentication/login_register.dart';
import 'package:proyecto_final_movil/src/widgets/locale_switcher_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<int> viewIndex = ValueNotifier<int>(0);

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key
  });

  @override
  State<Dashboard> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {

  Future<void> deletePref() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: const Key('dashboard'),
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text(''),
          actions: const [
            LocaleSwitcherWidget(),
            SizedBox(width: 12)
          ],
        ),
        drawer: Drawer(
          key: const Key('menuDrawer'),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple
                  ),
                  child: Text('Sport App'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home
                ),
                title: const Text('pagina 1'),
                onTap: () => {
                  viewIndex.value = 0,
                  Navigator.pop(context)
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.home
                ),
                title: const Text('pagina 2'),
                onTap: () => {
                  viewIndex.value = 1,
                  Navigator.pop(context)
                },
              ),
              ListTile(
                key: const Key('logout'),
                leading: const Icon(
                    Icons.home
                ),
                title: const Text('salir'),
                onTap: () => {
                  deletePref(),
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginRegister()),
                      (route) => false
                  )
                },
              ),
            ],
          )
        ),
        body: ValueListenableBuilder<int>(
          valueListenable: viewIndex,
          builder: (
            context,
            viewIndex,
            child
          ) {
            switch (viewIndex) {
              case 0:
                return const Calendar();
              default:
                return const SportSession();
            }
          }
        )
    ));
  }
}
