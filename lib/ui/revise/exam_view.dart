import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ext/string_ext.dart';

class ExamView extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final FlashCardGroup flashCardGroup;

  ExamView({required this.flashCardGroup});

  @override
  ExamViewWidgetState createState() => ExamViewWidgetState();
}

class ExamViewWidgetState extends State<ExamView> {
  List<String> formattedEntries = [];
  bool validate = false;

  @override
  void initState() {
    super.initState();
    formattedEntries =
        List.generate(widget.flashCardGroup.cards.length, (index) => "");
  }

  void updateScore() {
    int correct = 0;
    int wrong = 0;
    int missed = 0;
    for (int i = 0; i < widget.flashCardGroup.cards.length; i++) {
      if (formattedEntries[i].trim().isSimilar(
          widget.flashCardGroup.cards[i].front.trim(),
          widget.flashCardGroup.exactMatch)) {
        correct++;
      } else if (formattedEntries[i].isNotEmpty) {
        wrong++;
      } else {
        missed++;
      }
    }
    widget.resultRepository.addResult(
        widget.flashCardGroup.title, correct, wrong, missed, DateTime.now());
    validate = true;
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
    if (formattedEntries[key].trim().isSimilar(
        widget.flashCardGroup.cards[key].front.trim(),
        widget.flashCardGroup.exactMatch)) {
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
        formattedEntries[key],
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
              widget.flashCardGroup.cards[key].front,
              style: const TextStyle(fontSize: 20),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
