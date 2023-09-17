import 'package:flutter/material.dart';

import 'add_event_view.dart';
import 'event_view.dart';

class ReminderNavigator extends StatefulWidget {
  const ReminderNavigator({required this.navigatorKey, super.key});

  final GlobalKey navigatorKey;

  @override
  ReminderNavigatorState createState() => ReminderNavigatorState();
}

class ReminderNavigatorState extends State<ReminderNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return EventView();
                case '/create-entry':
                  return AddEventView();
                default:
                  return Container();
              }
            });
      },
    );
  }
}
