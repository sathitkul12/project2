import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Screen'),
        backgroundColor: Color(0xFF7EA48F),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('sus');
          },
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}
