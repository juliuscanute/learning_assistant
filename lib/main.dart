import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/add_event_view.dart';
import 'package:learning_assistant/ui/event_view.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await openIsar();
  ServiceLocator.setup(isar);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        // Define the routes
        '/': (context) => Scaffold(
              appBar: AppBar(title: const Text('Learning Assistant')),
              body: EventView(),
            ),
        '/create-entry': (context) {
          return AddEventView();
        }
      },
    );
  }
}

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [EventGroupSchema],
    directory: dir.path,
  );
}
