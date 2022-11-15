import 'package:flutter/material.dart';
import 'package:gfg_notification/scheduled_local_notifications/notification_content.dart';
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

  //prefill text field
  TextEditingController notificationTitle1 = TextEditingController()
    ..text = checkinNotificationContentTitle;
  TextEditingController notificationDescription1 = TextEditingController()
    ..text = checkinNotificationContentDescription;
  TextEditingController notificationTitle2 = TextEditingController()
    ..text = checkoutNotificationContentTitle;
  TextEditingController notificationDescription2 = TextEditingController()
    ..text = checkoutNotificationContentDescription;

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
                    type: 1,
                    subject: 'Test',
                    notificationTitle: notificationTitle,
                    notificationDescription: notificationDescription),
                NotificationCard(
                    type: 2,
                    subject: 'Check-in',
                    notificationTitle: notificationTitle1,
                    notificationDescription: notificationDescription1),
                NotificationCard(
                    type: 3,
                    subject: 'Check-out',
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
    required this.subject,
    required this.type,
    required this.notificationTitle,
    required this.notificationDescription,
  }) : super(key: key);
  final String subject;
  final int type;
  final TextEditingController notificationTitle;
  final TextEditingController notificationDescription;

  get initialTime => TimeOfDay.now();

  get initialDate => DateTime.now();

  get firstDate => DateTime.now();

  get lastDate => DateTime(2030, 12, 31);

  @override
  Widget build(BuildContext context) {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              subject,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(pickedDate.toString()),
                ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                    },
                    child: const Text('Date')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(pickedTime.toString()),
                ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                          context: context, initialTime: initialTime);
                    },
                    child: const Text('Time')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (type == 1) {
                          NotificationService().showNotification(
                              1,
                              notificationTitle.text,
                              notificationDescription.text);
                        } else if (type == 2) {
                          NotificationService().checkinNotification(
                              2,
                              checkinNotificationContentTitle,
                              checkinNotificationContentDescription);
                        } else if (type == 3) {
                          NotificationService().checkoutNotification(
                              3,
                              checkoutNotificationContentTitle,
                              checkoutNotificationContentDescription);
                        }
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
