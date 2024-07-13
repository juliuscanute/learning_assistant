import 'package:flutter/material.dart';
import 'package:learning_assistant/data/fash_card.dart';
import 'package:learning_assistant/ui/cloud/category_screen.dart';
import 'package:learning_assistant/ui/cloud/deck_screen.dart';
import 'package:learning_assistant/ui/cloud/exam_view_mcq.dart';
import 'package:learning_assistant/ui/revise/score_card.dart';
import 'package:learning_assistant/ui/cloud/train_view_mcq.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';

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
                  final textList = settings.arguments as FlashCardDeck;
                  return TrainViewMcq(group: textList);
                case '/exam':
                  final textList = settings.arguments as FlashCardDeck;
                  return ExamViewMcq(
                    flashCardGroup: textList,
                  );
                case '/validation':
                  final args = settings.arguments as ValidationParameters;
                  return ValidationView(
                    flashCardGroup: args.flashCardGroup,
                    userAnswers: args.userAnswers,
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
