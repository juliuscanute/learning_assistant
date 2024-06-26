import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/ui/revise/exam_view.dart';
import 'package:learning_assistant/ui/revise/revise_add_cards_new.dart';
import 'package:learning_assistant/ui/revise/revise_edit_card_new.dart';
import 'package:learning_assistant/ui/revise/revise_view.dart';
import 'package:learning_assistant/ui/revise/score_card.dart';
import 'package:learning_assistant/ui/revise/train_view.dart';

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
                  return ReviseAddCardsFB();
                case '/edit-revise':
                  final textList = settings.arguments as FlashCardGroup;
                  return ReviseEditCardsFB(
                    group: textList,
                  );
                case '/train':
                  final textList = settings.arguments as FlashCardGroup;
                  return TrainView(group: textList);
                case '/exam':
                  final textList = settings.arguments as FlashCardGroup;
                  return ExamView(
                    flashCardGroup: textList,
                  );
                case '/results':
                  final title = settings.arguments as String;
                  return ScoreCardListScreen(
                    title: title,
                  );
                default:
                  return Container();
              }
            });
      },
    );
  }
}
