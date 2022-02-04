# Flutter Notification Service
The notification service class is built to fix the various firebase notification issues, 
it's easy to integrate in exiting flutter project.

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
all it's methods. Call the parent constructor using super passing notification icon name as the
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
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>
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

### TODO
- Whitelist the app from battery optimization for custom rom devices.

### Pull Requests are Welcomed!, Thanks

MIT License

Copyright (c) [2022] [Ketan Tetry]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
