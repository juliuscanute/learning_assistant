import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/result.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/theme_notifier.dart';
import 'package:learning_assistant/ui/event/reminder_navigator.dart';
import 'package:learning_assistant/ui/revise/revise_navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await openIsar();
  ServiceLocator.setup(isar);
  runApp(const MyApp());
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
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Map<int, GlobalKey> navigatorKeys = {0: GlobalKey(), 1: GlobalKey()};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: "Reminder",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Revise",
            )
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
              ReminderNavigator(navigatorKey: navigatorKeys[0]!),
              ReviseNavigator(navigatorKey: navigatorKeys[1]!)
            ],
          ),
        ),
      ),
    );
  }
}

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [EventGroupSchema, FlashCardGroupSchema, ResultGroupSchema],
    directory: dir.path,
  );
}
