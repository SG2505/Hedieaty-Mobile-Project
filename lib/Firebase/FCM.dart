import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/main.dart';

import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final localDB = LocalDB();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configure local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
        handleNotificationTap(details);
      },
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Show the notification in the system tray
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel', // Channel ID
              'Default Channel', // Channel Name
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationTap(NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        payload: json.encode(message.data),
      ));
    });
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> updateFCMToken(
      {required String? userId, required String? token}) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'deviceMessageToken': token,
    });
  }

  void updateUserFCMToken(String? fcmToken) {
    {
      if (fcmToken == null) {
        print('no token');
      } else {
        FirebaseMessagingService()
            .updateFCMToken(userId: currentUser.id, token: fcmToken);
      }
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  Future<void> sendNotification({
    required String targetFCMToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await _generateAccessKey();
      if (token != null) {
        print(token);
      }
      final response = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/hedieaty-f4f67/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'message': {
            'token': targetFCMToken,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': data ?? {},
          }
        }),
      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception('Failed to send notification');
      }
    } catch (e) {
      print(e);
    }
  }

  void handleNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      //final data = json.decode(details.payload!);
    }
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

Future<String?> _generateAccessKey() async {
  try {
    final jsonString = await rootBundle.loadString(
        'assets/keys/hedieaty-f4f67-firebase-adminsdk-ntyaj-b8a3b59470.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final authClient = await clientViaServiceAccount(serviceAccount, scopes);
    final accessToken = authClient.credentials.accessToken;

    print("Generated Access Token: ${accessToken.data}");
    return accessToken.data;
  } catch (e) {
    print("Failed to generate access key: $e");
    return null;
  }
}
