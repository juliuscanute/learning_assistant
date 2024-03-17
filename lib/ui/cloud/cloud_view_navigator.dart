import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/ui/cloud/category_screen.dart';
import 'package:learning_assistant/ui/cloud/deck_screen.dart';
import 'package:learning_assistant/ui/revise/exam_view.dart';
import 'package:learning_assistant/ui/revise/score_card.dart';
import 'package:learning_assistant/ui/revise/train_view.dart';

class CloudViewNavigator extends StatefulWidget {
  const CloudViewNavigator({required this.navigatorKey, super.key});

  final GlobalKey navigatorKey;

  @override
  CloudViewNavigatorState createState() => CloudViewNavigatorState();
}

class CloudViewNavigatorState extends State<CloudViewNavigator> {
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
                  return DecksScreen();
                case '/train':
                  final textList = settings.arguments as FlashCardGroup;
                  return TrainView(group: textList);
                case '/exam':
                  final textList = settings.arguments as FlashCardGroup;
                  return ExamView(
                    actualAnswers: textList.cards,
                    title: textList.title,
                  );
                case '/results':
                  final title = settings.arguments as String;
                  return ScoreCardListScreen(
                    title: title,
                  );
                case '/category-screen':
                  final args = settings.arguments as Map<String, dynamic>;
                  final decks = args['decks'] as List<Map<String, dynamic>>;
                  final categoryList = args['categoryList'] as List<String>;
                  return CategoryScreen(
                    decks: decks,
                    categoryList: categoryList,
                  );
                default:
                  return Container();
              }
            });
      },
    );
  }
}
