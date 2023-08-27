import 'package:flutter/material.dart';
import 'package:learning_assistant/ui/revise_view.dart';

class ReviseNavigator extends StatefulWidget {
  const ReviseNavigator({required this.navigatorKey, super.key});

  final GlobalKey navigatorKey;

  @override
  _ReviseNavigatorState createState() => _ReviseNavigatorState();
}

class _ReviseNavigatorState extends State<ReviseNavigator> {
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
                  return const ReviseScreen();
                default:
                  return Container();
              }
            });
      },
    );
  }
}
