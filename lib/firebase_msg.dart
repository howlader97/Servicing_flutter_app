import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod_template/services/repository/fcm_repository.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true,
  );

  Future<void> initFCM() async {
    await msgService.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _initLocalNotifications();
    try{
      var token = await msgService.getToken();
      print("token////: $token");
      if (token != null) {
          await _handleFcmToken(token);
         }
    }catch(e){
      print("FCM Error =====> $e");
    }

    // var token = await msgService.getToken();
    // if (token != null) {
    //   await _handleFcmToken(token);
    // }

    msgService.onTokenRefresh.listen((newToken) async {
      await _handleFcmToken(newToken);
    });

    FirebaseMessaging.onBackgroundMessage(handleNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  Future<void> _handleFcmToken(String token) async {
    print("fcmToken: $token");
    await StorageServices.instance.setFcmToken(token);

    final userToken = await StorageServices.instance.getToken();
    if (userToken.isNotEmpty) {
      await FcmRepository.instance.sendFcmToken(fcmToken: token);
    }
  }
}

Future<void> handleNotification(RemoteMessage msg) async {}
