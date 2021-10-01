import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {

    static FirebaseMessaging messaging = FirebaseMessaging.instance;

    static requestPermission() async {
        await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
        );
        messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true);
    }
}