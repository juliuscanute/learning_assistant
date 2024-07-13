import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/fash_card.dart';
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

  const ValidationView({
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
                    child: Text(
                      "Question: ${entry.question}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Your Answer: ${entry.userAnswer}",
                      style: TextStyle(
                        fontSize: 16,
                        color: entry.state == EvaluationState.correct
                            ? Colors.green
                            : entry.state == EvaluationState.wrong
                                ? Colors.red
                                : Colors.yellow,
                      ),
                    ),
                  ),
                  if (entry.state != EvaluationState.correct) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Actual Answer: ${entry.actualAnswer}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.yellow,
                        ),
                      ),
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
        userAnswers.indexOf(userAnswer);
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
            ));
            break; // Stop checking after the first match
          }
        }
      }

      for (var missedAnswer in unmatchedActuals) {
        if (userAnswers[flashCardGroup.cards.indexOf(flashCardGroup.cards
                .singleWhere((card) =>
                    card.back == question && card.front == missedAnswer))]
            .trim()
            .isEmpty) {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: "",
            actualAnswer: missedAnswer,
            state: EvaluationState.missed,
          ));
        } else {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: userAnswers[flashCardGroup.cards.indexOf(
                flashCardGroup.cards.singleWhere((card) =>
                    card.back == question && card.front == missedAnswer))],
            actualAnswer: missedAnswer,
            state: EvaluationState.wrong,
          ));
        }
      }
    });

    return processedEntries;
  }
}

enum EvaluationState { undefined, correct, wrong, missed }

class EvaluationEntry {
  String question;
  String userAnswer;
  String actualAnswer;
  EvaluationState state;

  EvaluationEntry({
    required this.question,
    required this.userAnswer,
    required this.actualAnswer,
    required this.state,
  });
}
