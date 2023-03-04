import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService();

  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotificationPlugin.initialize(
      settings,
    );
  }

  Future<NotificationDetails> _getNotificationDetails() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = await _getNotificationDetails();
    await _localNotificationPlugin.show(id, title, body, details);
  }

  Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required int seconds}) async {
    final details = await _getNotificationDetails();
    await _localNotificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
