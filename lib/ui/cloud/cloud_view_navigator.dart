import 'package:flutter/material.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/presentation/bloc/deck_search_bloc.dart';
import 'package:learning_assistant/ui/cloud/category_card_new.dart';
import 'package:learning_assistant/ui/cloud/category_screen.dart';
import 'package:learning_assistant/ui/cloud/category_screen_new.dart';
import 'package:learning_assistant/ui/cloud/category_screen_subfolder_new.dart';
import 'package:learning_assistant/ui/cloud/deck_screen.dart';
import 'package:learning_assistant/ui/cloud/deck_search.dart';
import 'package:learning_assistant/ui/cloud/exam_view_mcq.dart';
import 'package:learning_assistant/ui/revise/score_card.dart';
import 'package:learning_assistant/ui/cloud/train_view_mcq.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';

import '../../di/injection_container.dart';

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
                  return const CategoryScreenNew();
                case '/search':
                  return DeckSearch(
                    deckSearchBloc: sl<DeckSearchBloc>(),
                  );
                case '/train':
                  final textList = settings.arguments as FlashCardDeck;
                  return TrainViewMcq(group: textList);
                case '/exam':
                  final args = settings.arguments as Map<String, dynamic>;
                  final group = args['group'] as FlashCardDeck;
                  final preference = args['preference'] as TestPreference;
                  return ExamViewMcq(
                    flashCardGroup: group,
                    preference: preference,
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
                // case '/category-screen':
                //   final args = settings.arguments as Map<String, dynamic>;
                //   final decks = args['decks'] as List<Map<String, dynamic>>;
                //   final categoryList = args['categoryList'] as List<String>;
                //   return CategoryScreen(
                //     decks: decks,
                //     categoryList: categoryList,
                //   );
                case '/category-screen-new':
                  final args = settings.arguments as Map<String, dynamic>;
                  final parentPath = args['parentPath'] as String;
                  final subFolders =
                      args['subFolders'] as List<Map<String, dynamic>>;
                  final parentId = args['folderId'] as String;
                  return SubfolderScreen(
                      parentFolderName: parentId,
                      parentPath: parentPath,
                      subFolders: subFolders);

                default:
                  return Container();
              }
            });
      },
    );
  }
}
