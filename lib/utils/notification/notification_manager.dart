import 'dart:async';

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

        var token = await FirebaseMessaging.instance.getToken();
        print(token);
    }
    
    static getFirebaseMessages(Function callback) async {
        FirebaseMessaging.onMessageOpenedApp.listen((event) {
            if (event.data["open"] != null) {
                callback(event.data["open"]);
            }
        });
    }

    static getFirebaseStartMessages(void callback(String deeplink)) {
        messaging.getInitialMessage().then((RemoteMessage? message) {
            if (message != null && message.data["open"] != null) {
                callback(message.data["open"]);
            }
        }).catchError((error) {
            print (error);
        });
    }
}