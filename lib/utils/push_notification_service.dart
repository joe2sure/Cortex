// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/app_common.dart';
import '../main.dart';
import '../models/firebase_msg_data_model.dart';
import 'constants.dart';

class PushNotificationService {
  Future<void> initFirebaseMessaging() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: true).catchError((e) {
      log('------Request Notification Permission ERROR-----------');
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('------Request Notification Permission COMPLETED-----------');
      await registerNotificationListeners().then((value) {
        log('------Notification Listener REGISTRATION COMPLETED-----------');
      }).catchError((e) {
        log('------Notification Listener REGISTRATION ERROR-----------');
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true).then((value) {
        log('------setForegroundNotificationPresentationOptions COMPLETED-----------');
      }).catchError((e) {
        log('------setForegroundNotificationPresentationOptions ERROR-----------');
      });
    }
  }

  Future<void> registerFCMandTopics() async {
    if (isLoggedIn.value) {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        await sub2Topic();
              log('APNSTOKEN: $apnsToken');
      } else {
        FirebaseMessaging.instance.getToken().then((token) {
          log("FCM_token ==> $token \n");
        });
        await sub2Topic();
      }
    }
  }

  Future<void> sub2Topic() async {
    await FirebaseMessaging.instance.subscribeToTopic("${FirebaseTopicConst.user}_${loginUserData.value.id}");

    await FirebaseMessaging.instance.subscribeToTopic(FirebaseTopicConst.userApp);
  }

  Future<void> unSub2Topic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("${FirebaseTopicConst.user}_${loginUserData.value.id}");

    await FirebaseMessaging.instance.unsubscribeFromTopic(FirebaseTopicConst.userApp);
  }

  void handleNotificationClick(RemoteMessage message, {bool isForeGround = false}) {
    printLogsNoticationData(message);
    FirebaseMsgData notificationData = FirebaseMsgData.fromJson(message.data);
    log('NOTIFICATIONDATA: ${notificationData.toJson()}');
    if (isForeGround) {
      showNotification(currentTimeStamp(), message.notification!.title.validate(), message.notification!.body.validate(), message);
    }
  }

  Future<void> registerNotificationListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleNotificationClick(message, isForeGround: true);
    }, onError: (e) {
      log("onMessage.listen ==> $e");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
    }, onError: (e) {
      log("onMessageOpenedApp ==> $e");
    });

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleNotificationClick(message);
      }
    }, onError: (e) {
      log("getInitialMessage ==> $e");
    });
  }

  Future<void> showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleNotificationClick(remoteMessage);
      },
    );

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'notification',
      'Notification',
      importance: Importance.high,
      visibility: NotificationVisibility.public,
      autoCancel: true,
      playSound: true,
      priority: Priority.high,
    );

    var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
      macOS: darwinPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(id, title, message, platformChannelSpecifics);
  }


  void printLogsNoticationData(RemoteMessage message) {
    log('NOTIFICATIONDATA: ${message.data}');
    log('notification title-->: ${message.notification!.title}');
    log('notification body-->: ${message.notification!.body}');
    log('MESSAGE.DATA: ${message.collapseKey}');
    log('MESSAGE.DATA: ${message.messageId}');
    log('MESSAGE.DATA: ${message.messageType}');
  }
}
