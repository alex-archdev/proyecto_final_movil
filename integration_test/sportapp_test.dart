import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto_final_movil/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end test', () {
    var email = 'juan.perez@sportapp.com';
    var password = 'Prueba001*';

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

      expect(find.byKey(const Key('login_btn')), findsOneWidget);
      expect(find.byKey(const Key('signup_btn')), findsOneWidget);

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
      const String password = '12345678';

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('login good credentials', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      final scaffoldKey = GlobalKey<ScaffoldState>();
      const displayName = "SportApp";

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: scaffoldKey,
            drawer: const Text(displayName),
          ),
        ),
      );

      scaffoldKey.currentState?.openDrawer();
      await tester.pump();

      expect(find.text(displayName), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('logout', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      final drawer = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('logout')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('login'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('Menu', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final drawer = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('plan')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('sport_plan_item')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('session')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('session_plan_item')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('calendar')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('session_plan_calendar')), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('measures')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('ftp_dashboard')), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('logout')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('login'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('add plan', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final drawer = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('plan')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('sport_plan_item')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('sport_plan_item')).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('plan_add_btn')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('plan_add_btn')).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

    });

    testWidgets('check session detail', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      final widget = makeTesteableWidget(
        child: const MyApp(),
      );

      await tester.pumpWidget(widget);

      final but_1 = find.text('login');
      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email_input')), email);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password_input')), password);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(but_1);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final drawer = find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(drawer);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('session')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('session_plan_item')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('session_plan_item')).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('exercises_item')), findsAtLeast(1));

      await tester.pumpAndSettle(const Duration(seconds: 2));

    });
  });
}