import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/revise/revise_add_cards.dart';
import 'package:learning_assistant/ui/revise/revise_view.dart';

class ReviseNavigator extends StatefulWidget {
  const ReviseNavigator({required this.navigatorKey, super.key});

  final GlobalKey navigatorKey;

  @override
  ReviseNavigatorState createState() => ReviseNavigatorState();
}

class ReviseNavigatorState extends State<ReviseNavigator> {
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
                  return ReviseScreen();
                case '/add-revise':
                  return ReviseAddCards();
                default:
                  return Container();
              }
            });
      },
    );
  }
}
