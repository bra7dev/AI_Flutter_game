import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../core.dart';
import 'local_notification_service.dart';

class CloudMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    _handleOnMessage();
    _handleUserInteraction();

    if (Platform.isIOS) {
      await _setForegroundNotificationsPresentationOptionsIOS();
      await _setNotificationPermissionsIOS();
    }
  }

  void _handleOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('clc');
      if (message.notification != null) {
        log('NOTIFICATION RECEIVED');
        // onNotificationReceive();

        // // String count = PreferenceManager.instance.s(Prefs.NOTIFICATION_COUNT, '0');
        // int count =
        //     await PreferenceManager.instance.getInt(Prefs.NOTIFICATION_COUNT);
        // print('Result is :: $count');
        // PreferenceManager.instance.setInt(Prefs.NOTIFICATION_COUNT, ++count);
        // NotificationController.instance.streamController.add(5);

        AndroidNotification? android = message.notification?.android;
        sl<LocalNotificationsService>().showNotification(message, android);
      }

      // var dataBody = jsonDecode(message.data['data_body']);
      //
      // // if user is on chat screen, don't show notifications
      // if (message.data['type'] == 'chat') {
      //
      // }

      /* show local notification */
    });
  }

  Future<void> _handleUserInteraction() async {
    debugPrint('CLICKED FROM BACKGROUND');

    /// from terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    /// from background state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// When notification is clicked from background OR terminated state...
  void _handleMessage(RemoteMessage message) {
    print('CLICKED FROM TERMINATED');
    // NavRouter.push(GlobalVariables.navState.currentState!.context, TestScreen());
    // var dataBody = jsonDecode(message.data['data_body']);
    // if (message.data['type'] == 'chat') {
    //   Future.delayed(Duration(seconds: isFromTerminatedState ? 3 : 0))
    //       .then((value) {
    //
    //   });
    // } else if (message.data['type'] == 'event') {
    //   Future.delayed(Duration(seconds: isFromTerminatedState ? 3 : 0))
    //       .then((value) {
    //
    //   });
    // }
  }

  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> deleteFcmToken() async {
    _firebaseMessaging.deleteToken();
  }

  Future<void> _setForegroundNotificationsPresentationOptionsIOS() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> _setNotificationPermissionsIOS() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }
}
