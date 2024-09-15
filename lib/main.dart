import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/initial_deck.dart';
import 'package:learning_assistant/data/result.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/firebase_options.dart';
import 'package:learning_assistant/theme_notifier.dart';
import 'package:learning_assistant/ui/cloud/cloud_view_navigator.dart';
import 'package:learning_assistant/ui/event/reminder_navigator.dart';
import 'package:learning_assistant/ui/revise/revise_navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await openIsar();
  ServiceLocator.setup(isar);
  final isFirst = await isFirstLaunch();
  if (isFirst) LoadDeck().initialise();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotification();
  runApp(const MyApp());
}

void initializeNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: Builder(
        builder: (context) {
          final themeNotifier = Provider.of<ThemeNotifier>(context);
          return MaterialApp(
            title: 'Learning Assistant',
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.getTheme(),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Study",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: "Reminder",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.science),
              label: "Explore",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body: SafeArea(
        top: false,
        child: WillPopScope(
          onWillPop: () async {
            return !await Navigator.maybePop(
                navigatorKeys[_selectedIndex]!.currentState!.context);
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              CloudViewNavigator(navigatorKey: navigatorKeys[2]!),
              ReminderNavigator(navigatorKey: navigatorKeys[0]!),
              ReviseNavigator(navigatorKey: navigatorKeys[1]!),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirst = prefs.getBool('is_first_launch') ?? true;
  await prefs.setBool('is_first_launch', false);
  return isFirst;
}

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [EventGroupSchema, FlashCardGroupSchema, ResultGroupSchema],
    directory: dir.path,
  );
}
