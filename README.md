# Flutter Notification Service
The notification service class is built to fix the various firebase notification issues, 
it's easy to integrate in any exiting project.

### Step 1
Add required dependencies for firebase notification.
```yaml
dependencies:
  firebase_core: ^1.12.0
  flutter_local_notifications: ^9.2.0
  firebase_messaging: ^11.2.6
```

### Step 2
Create notification helper class which extends the notification service class and implement
all it's methods. Call the parent constructer using super passing notification icon name as the
argument. Set the global key in case you want to perform notification click re-direction.
```dart
class NotificationServiceHelper extends NotificationService {
  static NotificationServiceHelper _instance;
  GlobalKey<NavigatorState> _globalKey;

  // Provide the notification icon to the parent constructor
  NotificationServiceHelper._() : super(notificationIcon: 'ic_notification');

  static NotificationServiceHelper get instance =>
      _instance ??= NotificationServiceHelper._();

  @override
  void setGlobalNavigationKey(GlobalKey<NavigatorState> globalKey) {
    _instance._globalKey = globalKey;
  }

  @override
  void saveFCMToken(String token) {
    debugPrint('FCM Token: $token');
  }

  @override
  void handleNotificationClick(RemoteMessage message) {
    if (message == null || message.notification == null) return;
    debugPrint('On Notification Tap: ${message.notification.title}');
  }
}
```

### Step 3
Initialize the notification service in the main method, for handling background notifications
create top level method and pass it to the FirebaseMessaging.onBackgroundMessage method.
```dart
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServiceHelper.instance.initialize();
  NotificationServiceHelper.instance.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServiceHelper.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
```

### Step 4
Add the meta-data channel id and the notification icon for the default notification channel
which is used when app is in background or terminated state.

```xml
    <application>
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default_channel_id" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
    </application>
```

### Step 5
You can also check whether the notification are turned off by the user, or notification
permission denined in iOS.
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notification Enabled: ${NotificationServiceHelper.instance.isAuthorized}',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```
