import 'package:flutter/material.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';
import 'package:learning_assistant/presentation/pages/add_event_page.dart';
import 'package:learning_assistant/presentation/pages/event_page.dart';
import 'package:learning_assistant/presentation/pages/spaced_revision_page.dart';
import 'package:learning_assistant/ui/cloud/exam_view_mcq.dart';
import 'package:learning_assistant/ui/cloud/train_view_mcq.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';
import 'package:learning_assistant/ui/revise/score_card.dart';

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
                  return SpacedRevisionPage(
                    spacedRevisionBloc: sl<SpacedRevisionBloc>(),
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
                default:
                  return Container();
              }
            });
      },
    );
  }
}
