import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:proyecto_final_movil/src/widgets/screen_size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/src/widgets/locale_switcher_widget.dart';
import 'package:proyecto_final_movil/src/features/menu/dashboard.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key
  });

  @override
  State<LoginForm> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final ApiProvider _apiProvider = ApiProvider();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Future<void> _handleLogin(context) async {
    if (emailTextController.text.isNotEmpty && passwordTextController.text.isNotEmpty ) {
      dynamic res = await _apiProvider.login(
          context, emailTextController.text, passwordTextController.text);

      if (res['success'] == false) {
        //show error
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard())
        );
      }
    }
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
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
                            TextFormField(
                              controller: emailTextController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email_input,
                                labelStyle: const TextStyle(color: Colors.purple),
                                // prefixIcon: Icon(
                                //   Icons.mail,
                                //   size: SizeConfig.defaultSize * 2,
                                //   color: Colors.purple,
                                // ),
                                filled: false,
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: passwordTextController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password_input,
                                labelStyle: const TextStyle(color: Colors.purple),
                                // prefixIcon: Icon(
                                //   Icons.lock,
                                //   size: SizeConfig.defaultSize * 2,
                                //   color: Colors.blue,
                                // ),
                                filled: false,
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 5,
                              minWidth: MediaQuery.of(context).size.width,
                              child: OutlinedButton(
                                onPressed: () => {
                                  _handleLogin(context)
                                },
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0)
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.deepPurple),
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
                    margin: EdgeInsets.only(top: SizeConfig.defaultSize * 26),
                    height: SizeConfig.defaultSize * 5,
                    width: SizeConfig.defaultSize * 20,
                    child: const Center(
                      child: Text(
                        'SportApp',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
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