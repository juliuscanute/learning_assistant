import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/add_event_view.dart';
import 'package:learning_assistant/ui/event_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
              appBar: AppBar(title: Text('Learning Assistant')),
              body: EventView(),
            ),
        '/create-entry': (context) =>
            AddEventView(), // Define the 'create-entry' route
      },
    );
  }
}
