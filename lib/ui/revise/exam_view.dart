import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ext/string_ext.dart';

class ExamView extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final FlashCardGroup flashCardGroup;

  ExamView({super.key, required this.flashCardGroup});

  @override
  ExamViewWidgetState createState() => ExamViewWidgetState();
}

class ExamViewWidgetState extends State<ExamView> {
  List<String> formattedEntries = [];
  List<EvaluationEntry> processedActualEntries = [];
  Map<String, bool> processedEntries = {};
  Map<String, List<String>> actualCards = {};
  Map<String, List<String>> userCards = {};
  bool validate = false;

  void groupCardsByQuestionAndActualAnswers() {
    for (var card in widget.flashCardGroup.cards) {
      if (actualCards.containsKey(card.back)) {
        actualCards[card.back]!.add(card.front);
      } else {
        actualCards[card.back] = [card.front];
      }
    }
  }

  void groupCardsByQuestionAndUserAnswers() {
    for (var i = 0; i < widget.flashCardGroup.cards.length; i++) {
      if (userCards.containsKey(widget.flashCardGroup.cards[i].back)) {
        userCards[widget.flashCardGroup.cards[i].back]!
            .add(formattedEntries[i]);
      } else {
        userCards[widget.flashCardGroup.cards[i].back] = [formattedEntries[i]];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    formattedEntries =
        List.generate(widget.flashCardGroup.cards.length, (index) => "");
    processedActualEntries = List.generate(widget.flashCardGroup.cards.length,
        (index) => EvaluationEntry("", EvaluationState.undefined));
    groupCardsByQuestionAndActualAnswers();
  }

  void updateScore() {
    int correct = 0;
    int wrong = 0;
    int missed = 0;
    groupCardsByQuestionAndUserAnswers();
    actualCards.forEach((question, actualAnswers) {
      List<String> userAnswers = userCards[question] ?? [];
      List<String> unmatchedActuals = List<String>.from(actualAnswers);
      for (var userAnswer in userAnswers) {
        int index = indexOfQuestionForMatchingUserEntry(question, userAnswer);
        for (var actualAnswer in actualAnswers) {
          if (userAnswer
              .trim()
              .isSimilar(actualAnswer, widget.flashCardGroup.exactMatch)) {
            correct++;
            unmatchedActuals.removeWhere((item) => item
                .trim()
                .isSimilar(actualAnswer, widget.flashCardGroup.exactMatch));
            processedActualEntries[index] =
                EvaluationEntry(actualAnswer, EvaluationState.correct);
            break; // Stop checking after the first match
          }
        }
      }
      for (var missedAnswer in unmatchedActuals) {
        int index =
            indexOfQuestionForMatchingActualEntry(question, missedAnswer);
        if (formattedEntries[index].trim().isEmpty) {
          processedActualEntries[index] =
              EvaluationEntry(missedAnswer, EvaluationState.missed);
          missed++;
        } else {
          processedActualEntries[index] =
              EvaluationEntry(missedAnswer, EvaluationState.wrong);
          wrong++;
        }
      }
    });

    widget.resultRepository.addResult(
        widget.flashCardGroup.title, correct, wrong, missed, DateTime.now());
    validate = true;
  }

  int indexOfQuestionForMatchingUserEntry(String question, String userAnswer) {
    for (var i = 0; i < widget.flashCardGroup.cards.length; i++) {
      // Check if the entry has already been processed
      if (processedEntries.containsKey(userAnswer) &&
          processedEntries[userAnswer] == true) {
        continue; // Skip this entry
      }
      if (formattedEntries[i] == userAnswer &&
          question == widget.flashCardGroup.cards[i].back) {
        processedEntries[userAnswer] = true; // Mark as processed
        return i;
      }
    }
    return -1;
  }

  int indexOfQuestionForMatchingActualEntry(
      String question, String actualAnswer) {
    for (var i = 0; i < widget.flashCardGroup.cards.length; i++) {
      if (question == widget.flashCardGroup.cards[i].back &&
          processedActualEntries[i].state == EvaluationState.undefined) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Train"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: widget.flashCardGroup.cards
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key + 1}) ${entry.value.back}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        _buildAnswerWidget(entry.key),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  if (!validate) {
                    updateScore();
                  } else {
                    Navigator.popAndPushNamed(context, '/results',
                        arguments: widget.flashCardGroup.title);
                  }
                });
              },
              child:
                  !validate ? const Text("Submit") : const Text("View Results"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(int key) {
    if (!validate) {
      return _buildTextField(key);
    } else {
      return _buildAnswerValidation(key);
    }
  }

  Widget _buildTextField(int key) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        formattedEntries[key] = value;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Type your answer here...',
      ),
    );
  }

  Widget _buildAnswerValidation(int key) {
    if (processedActualEntries[key].state == EvaluationState.correct) {
      return _buildCorrectAnswer(key);
    } else {
      return _buildIncorrectAnswer(key);
    }
  }

  Widget _buildCorrectAnswer(int key) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(8),
      child: Text(
        processedActualEntries[key].text,
        style: const TextStyle(fontSize: 20),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildIncorrectAnswer(int key) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            child: Text(
              formattedEntries[key].isNotEmpty
                  ? formattedEntries[key]
                  : "Missed",
              style: const TextStyle(fontSize: 20),
              softWrap: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.yellow,
            padding: const EdgeInsets.all(8),
            child: Text(
              processedActualEntries[key].text,
              style: const TextStyle(fontSize: 20),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}

enum EvaluationState { undefined, correct, wrong, missed }

class EvaluationEntry {
  String text;
  EvaluationState state;

  EvaluationEntry(this.text, this.state);
}
