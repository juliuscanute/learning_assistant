import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/ui/add_event_view.dart';
import 'package:learning_assistant/ui/event_view.dart';

void main() async {
  final isar = await openIsar();
  final eventRepository = EventRepository(isar);
  runApp(MyApp(eventRepository: eventRepository));
}

class MyApp extends StatelessWidget {
  EventRepository eventRepository;
  MyApp({required this.eventRepository, Key? key});

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
              body: EventView(
                eventRepository: eventRepository,
              ),
            ),
        '/create-entry': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AddEventView(
            eventRepository: eventRepository,
            onClose: args['reloadList'],
          );
        }
      },
    );
  }
}

Future<Isar> openIsar() async {
  return await Isar.open([EventSchema]);
}
