import 'package:flutter/material.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';
import 'package:learning_assistant/presentation/pages/add_event_page.dart';
import 'package:learning_assistant/presentation/pages/event_page.dart';

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
                  return EventPage(
                    eventBloc: sl<EventBloc>(),
                    eventDetailsBloc: sl<EventDetailsBloc>(),
                  );
                case '/create-entry':
                  return AddEventPage(eventBloc: sl<EventBloc>());
                default:
                  return Container();
              }
            });
      },
    );
  }
}
