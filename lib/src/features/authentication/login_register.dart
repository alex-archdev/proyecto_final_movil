import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/features/authentication/login.dart';
import 'package:proyecto_final_movil/src/widgets/screen_size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/widgets/locale_switcher_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({
    super.key
  });

  @override
  State<LoginRegister> createState() {
    return _LoginRegisterState();
  }
}

class _LoginRegisterState extends State<LoginRegister> {
  static const String registerUrl = String.fromEnvironment('REGISTER_URL', defaultValue: 'http://pf-front-app.s3-website-us-east-1.amazonaws.com/');

  _launchURL() async {
    final Uri url = Uri.parse(registerUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not open register url');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 5,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.defaultSize * 3,
                        right: SizeConfig.defaultSize * 3),
                    child: Form(
                      child: Container(
                        margin:
                        EdgeInsets.only(top: SizeConfig.defaultSize * 28),
                        padding: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 6,
                            bottom: SizeConfig.defaultSize * 2,
                            left: SizeConfig.defaultSize * 2,
                            right: SizeConfig.defaultSize * 2),
                        height: SizeConfig.defaultSize * 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 10,
                              minWidth: MediaQuery.of(context).size.width,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginForm())
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0)
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.deepPurple),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 1,
                            ),
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 10,
                              minWidth: MediaQuery.of(context).size.width,
                              child: OutlinedButton(
                                onPressed: _launchURL,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0)
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.signup,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.deepPurple),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.defaultSize * 28),
                    child: const Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          color: Colors.deepPurple,
                          size: 56,
                        ),
                        Text(
                          'SportApp',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}