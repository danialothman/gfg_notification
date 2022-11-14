import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'scheduled_local_notifications/notification_service.dart';

void main() {
// to ensure all the widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

// to initialize the notification_service.
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      home: const MyHomePage(title: 'GeeksForGeeks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController notificationTitle = TextEditingController();
  TextEditingController notificationDescription = TextEditingController();
  TextEditingController notificationTitle1 = TextEditingController();
  TextEditingController notificationDescription1 = TextEditingController();
  TextEditingController notificationTitle2 = TextEditingController();
  TextEditingController notificationDescription2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Local Notification',
                  style: Theme.of(context).textTheme.headline5,
                ),
                NotificationCard(
                    notificationTitle: notificationTitle,
                    notificationDescription: notificationDescription),
                NotificationCard(
                    notificationTitle: notificationTitle1,
                    notificationDescription: notificationDescription1),
                NotificationCard(
                    notificationTitle: notificationTitle2,
                    notificationDescription: notificationDescription2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.notificationTitle,
    required this.notificationDescription,
  }) : super(key: key);

  final TextEditingController notificationTitle;
  final TextEditingController notificationDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '2 seconds',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: notificationTitle,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Title",
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: notificationDescription,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Description",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        NotificationService().showNotification(
                            1,
                            notificationTitle.text,
                            notificationDescription.text);
                      },
                      child: const Text('Show Notification')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        notificationTitle.clear();
                        notificationDescription.clear();
                      },
                      child: const Text('Clear'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
