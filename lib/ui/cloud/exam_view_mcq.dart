import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/ext/latext.dart';
import 'package:learning_assistant/ui/cloud/train_view_mcq.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';

class ExamViewMcq extends StatefulWidget {
  final FlashCardDeck flashCardGroup;
  final TestPreference preference;

  const ExamViewMcq(
      {super.key, required this.flashCardGroup, required this.preference});

  @override
  _ExamViewMcqState createState() => _ExamViewMcqState();
}

class _ExamViewMcqState extends State<ExamViewMcq> {
  List<String> formattedEntries = [];
  int currentQuestionIndex = 0;
  List<List<MapEntry<int, String>>> mcqRandomOptions = [];

  @override
  void initState() {
    super.initState();
    formattedEntries =
        List.generate(widget.flashCardGroup.cards.length, (index) => "");
    _computeShuffledOptions();
  }

  void _computeShuffledOptions() {
    mcqRandomOptions = widget.flashCardGroup.cards.map((card) {
      final options = card.mcqOptions!.asMap().entries.toList();
      options.shuffle(Random());
      return options;
    }).toList();
  }

  void navigateToValidationView() {
    Navigator.popAndPushNamed(
      context,
      '/validation',
      arguments: ValidationParameters(
        flashCardGroup: widget.flashCardGroup,
        userAnswers: formattedEntries,
      ),
    );
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < widget.flashCardGroup.cards.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.flashCardGroup.cards[currentQuestionIndex];
    final currentShuffledOptions = mcqRandomOptions[currentQuestionIndex];

    return Scaffold(
        appBar: AppBar(
          title: const Text("Train"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1}:",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildQuestionWidget(currentCard),
                const SizedBox(height: 16.0),
                _buildAnswerWidget(currentCard, currentShuffledOptions),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      currentQuestionIndex == 0 ? null : goToPreviousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Color for navigation action
                  ),
                  child: const Text("Previous"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: navigateToValidationView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Col // Color for completion action
                  ),
                  child: const Text("Finish"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: currentQuestionIndex ==
                          widget.flashCardGroup.cards.length - 1
                      ? null
                      : goToNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Col// Color for navigation action
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildQuestionWidget(FlashCard card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (card.backTex != null && card.backTex!.trim().isNotEmpty)
          LaTexT(
            laTeXCode: Text(card.backTex!),
          )
        else
          Text(
            card.back,
            style: const TextStyle(fontSize: 16.0),
          ),
      ],
    );
  }

  Widget _buildAnswerWidget(
      FlashCard card, List<MapEntry<int, String>> options) {
    bool isMCQ = false;
    switch (widget.preference) {
      case TestPreference.mcq:
        isMCQ = true;
        break;
      case TestPreference.written:
        isMCQ = false;
        break;
      case TestPreference.random:
        isMCQ = Random().nextBool();
        break;
    }
    if ((card.mcqOptions != null && card.mcqOptions!.isNotEmpty) && isMCQ) {
      return Column(
        children: options.map((entry) {
          // Check if mcqOptionsTex is available and use it
          final optionText =
              (card.mcqOptionsTex != null && card.mcqOptionsTex!.isNotEmpty)
                  ? card.mcqOptionsTex![entry.key]
                  : entry.value;
          return RadioListTile<int>(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: card.mcqOptionsTex != null &&
                          card.mcqOptionsTex!.isNotEmpty
                      ? LaTexT(
                          laTeXCode: Text(
                            optionText.contains('\$\$')
                                ? optionText
                                : '\$\$$optionText\$\$',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        )
                      : Text(
                          optionText,
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                ),
              ],
            ),
            value: entry.key,
            groupValue: formattedEntries[currentQuestionIndex] ==
                    card.mcqOptions![entry.key]
                ? entry.key
                : null,
            onChanged: (value) {
              setState(() {
                formattedEntries[currentQuestionIndex] =
                    card.mcqOptions![entry.key];
              });
            },
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 0), // Adjust padding if necessary
          );
        }).toList(),
      );
    } else {
      final TextEditingController controller = TextEditingController();

      // Check if there's an existing answer for the current question
      if (formattedEntries[currentQuestionIndex].isNotEmpty) {
        controller.text = formattedEntries[currentQuestionIndex];
      }

      return TextField(
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          formattedEntries[currentQuestionIndex] = value;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type your answer here...',
        ),
      );
    }
  }
}
