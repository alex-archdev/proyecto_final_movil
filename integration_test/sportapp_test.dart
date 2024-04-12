import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// class MockClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end test', () {
    Widget makeTesteableWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', '')
        ],
        home: child,
      );
    }

    testWidgets('login or register', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      expect(find.text('login'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('go login', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      final but = find.text('login');
      await tester.tap(but);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('login'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('login bad credentials', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      const String email = 'test@email.com';
      const String password = '123456';

      // final ApiProvider apiProvider = ApiProvider();
      //
      // final client = MockClient();
      // when(client.post(
      //   Uri.parse('http://localhost'),
      //   body: jsonEncode(<String, String>{
      //     'email': email,
      //     'password': password
      //   })
      // )).thenAnswer((_) async => http.Response('{"success": false}', 400));

      await tester.pumpWidget(widget);

      final BuildContext context = tester.element(find.byType(MyApp));

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final but_2 = find.text('login');
      await tester.tap(but_2);

      // dynamic res = await apiProvider.login(
      //     context, client, email, password);

      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });
  });
}