import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notification/notification_util/notification_service.dart';

class NotificationServiceHelper extends NotificationService {
  static NotificationServiceHelper _instance;
  GlobalKey<NavigatorState> _globalKey;

  NotificationServiceHelper._() : super(notificationIcon: 'ic_notification');

  static NotificationServiceHelper get instance =>
      _instance ??= NotificationServiceHelper._();

  @override
  void setGlobalNavigationKey(GlobalKey<NavigatorState> globalKey) {
    _globalKey = globalKey;
  }

  @override
  void saveFCMToken(String token) {
    debugPrint('FCM Token: $token');
  }

  @override
  void handleNotificationClick(RemoteMessage message) {
    if (message == null || message.data == null) return;
    debugPrint('On Notification Tap');
  }

  @override
  void onSelectNotification(String payload) {
    if (payload == null || payload.isEmpty) return;
  }
}
