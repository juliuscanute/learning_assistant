import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:learning_assistant/data/fash_card.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ext/string_ext.dart';

class ValidationParameters {
  final FlashCardDeck flashCardGroup;
  final List<String> userAnswers;

  ValidationParameters({
    required this.flashCardGroup,
    required this.userAnswers,
  });
}

class ValidationView extends StatelessWidget {
  final FlashCardDeck flashCardGroup;
  final List<String> userAnswers;
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();

  ValidationView({
    Key? key,
    required this.flashCardGroup,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<EvaluationEntry> processedEntries = _processAnswers();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Question and Answers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...processedEntries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: formattedRenderer(
                        context,
                        'Question: ${entry.card.backTex?.trim().isNotEmpty == true ? entry.card.backTex : entry.card.back}',
                        entry.card.backTex?.trim().isNotEmpty == true,
                        Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: formattedRenderer(
                        context,
                        'Your Answer: ${entry.userAnswer}',
                        false,
                        entry.state == EvaluationState.correct
                            ? Colors.green
                            : Colors.red),
                  ),
                  if (entry.state != EvaluationState.correct) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: formattedRenderer(
                          context,
                          'Correct Answer: ${entry.card.frontTex?.trim().isNotEmpty == true ? entry.card.frontTex : entry.card.front}',
                          entry.card.frontTex?.trim().isNotEmpty == true,
                          Colors.blue),
                    ),
                  ],
                  const Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.popAndPushNamed(context, '/results',
                    arguments: flashCardGroup.title);
              },
              child: const Text("View Results"),
            )
          ],
        ),
      ),
    );
  }

  List<EvaluationEntry> _processAnswers() {
    List<EvaluationEntry> processedEntries = [];
    var correctCount = 0;
    var missedCount = 0;
    var wrongCount = 0;
    Map<String, List<String>> actualCards = {};
    for (var card in flashCardGroup.cards) {
      if (actualCards.containsKey(card.back)) {
        actualCards[card.back]!.add(card.front);
      } else {
        actualCards[card.back] = [card.front];
      }
    }

    actualCards.forEach((question, actualAnswers) {
      List<String> unmatchedActuals = List<String>.from(actualAnswers);
      List<String> userAnswersForQuestion = userAnswers
          .where((answer) =>
              question ==
              flashCardGroup.cards[userAnswers.indexOf(answer)].back)
          .toList();

      for (var userAnswer in userAnswersForQuestion) {
        final index = userAnswers.indexOf(userAnswer);
        for (var actualAnswer in actualAnswers) {
          if (userAnswer
              .trim()
              .isSimilar(actualAnswer, flashCardGroup.exactMatch)) {
            unmatchedActuals.removeWhere((item) =>
                item.trim().isSimilar(actualAnswer, flashCardGroup.exactMatch));
            processedEntries.add(EvaluationEntry(
              question: question,
              userAnswer: userAnswer,
              actualAnswer: actualAnswer,
              state: EvaluationState.correct,
              card: flashCardGroup.cards[index],
            ));
            correctCount++;
            break; // Stop checking after the first match
          }
        }
      }

      for (var missedAnswer in unmatchedActuals) {
        final userIndex = flashCardGroup.cards.indexOf(flashCardGroup.cards
            .singleWhere(
                (card) => card.back == question && card.front == missedAnswer));
        if (userAnswers[userIndex].trim().isEmpty) {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: "",
            actualAnswer: missedAnswer,
            state: EvaluationState.missed,
            card: flashCardGroup.cards[userIndex],
          ));
          missedCount++;
        } else {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: userAnswers[userIndex],
            actualAnswer: missedAnswer,
            state: EvaluationState.wrong,
            card: flashCardGroup.cards[userIndex],
          ));
          wrongCount++;
        }
      }
    });
    resultRepository.addResult(flashCardGroup.title, correctCount, wrongCount,
        missedCount, DateTime.now());
    return processedEntries;
  }

  Widget formattedRenderer(
      BuildContext context, text, bool isTex, Color color) {
    if (isTex) {
      return _renderTexWidget(color, ensureLatexSyntax(text));
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color,
        ),
      );
    }
  }

  String ensureLatexSyntax(String text) {
    return '<p>$text</p>';
  }

  Widget _renderTexWidget(Color color, String tex) {
    return Container(
      child: TeXView(
        renderingEngine: const TeXViewRenderingEngine.mathjax(),
        loadingWidgetBuilder: (context) {
          return const Center(
            child: Text("Please wait..."),
          );
        },
        child: TeXViewColumn(children: [
          TeXViewDocument(tex, style: TeXViewStyle(contentColor: color))
        ]),
      ),
    );
  }
}

enum EvaluationState { undefined, correct, wrong, missed }

class EvaluationEntry {
  String question;
  String userAnswer;
  String actualAnswer;
  EvaluationState state;
  FlashCard card;

  EvaluationEntry({
    required this.question,
    required this.userAnswer,
    required this.actualAnswer,
    required this.state,
    required this.card,
  });
}
