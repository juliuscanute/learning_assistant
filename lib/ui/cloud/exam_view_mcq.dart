import 'package:flutter/material.dart';
import 'package:learning_assistant/data/fash_card.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';

class ExamViewMcq extends StatefulWidget {
  final FlashCardDeck flashCardGroup;

  ExamViewMcq({required this.flashCardGroup});

  @override
  _ExamViewState createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamViewMcq> {
  List<String> formattedEntries = [];

  @override
  void initState() {
    super.initState();
    formattedEntries =
        List.generate(widget.flashCardGroup.cards.length, (index) => "");
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
              onPressed: () {
                navigateToValidationView();
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget(int key) {
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
}
