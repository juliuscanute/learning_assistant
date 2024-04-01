import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learning_assistant/main.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification(DateTime dateTime, String description) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Study Reminder',
      'Revise $description',
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'reminder_channel_id', 'Reminder channel',
              channelDescription: 'Receive study reminder',
              importance: Importance.max,
              priority: Priority.high),
          iOS: DarwinNotificationDetails()),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact);
}
