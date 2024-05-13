import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          // print('onDidReceiveNotificationResponse Function');
          // print(details.payload);
          // print(details.payload != null);
        });
  }

  static void showNotification(RemoteMessage message, BuildContext context) {
    if (!context.mounted) {
      return;
    }
    const NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'com.example.push_notification',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    String? title = '';
    String? body = '';
    switch (message.notification?.title) {
      case 'vo2_low':
        title = AppLocalizations.of(context)?.vo2_low_title;
        body = AppLocalizations.of(context)?.vo2_low_message;

      case 'ftp_low':
        title = AppLocalizations.of(context)?.ftp_low_title;
        body = AppLocalizations.of(context)?.ftp_low_message;
    }

    _notiPlugin.show(
      DateTime.now().microsecond,
      title,
      body,
      notiDetails,
      payload: message.data.toString(),
    );
  }
}