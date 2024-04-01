import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ext/string_ext.dart';

class ExamView extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final List<CardEmbedded> actualAnswers;
  final String title;
  final bool exactMatch;

  ExamView(
      {required this.actualAnswers,
      required this.title,
      required this.exactMatch});

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
        List.generate(widget.actualAnswers.length, (index) => "");
  }

  void updateScore() {
    int correct = 0;
    int wrong = 0;
    int missed = 0;
    for (int i = 0; i < widget.actualAnswers.length; i++) {
      if (formattedEntries[i]
          .trim()
          .isSimilar(widget.actualAnswers[i].front.trim(), widget.exactMatch)) {
        correct++;
      } else if (formattedEntries[i].isNotEmpty) {
        wrong++;
      } else {
        missed++;
      }
    }
    widget.resultRepository
        .addResult(widget.title, correct, wrong, missed, DateTime.now());
    validate = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"), // Change app bar title to "Train"
      ),
      body: SingleChildScrollView(
        child: Column(
          children: widget.actualAnswers
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key + 1})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
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
                setState(() {
                  if (!validate) {
                    updateScore();
                  } else {
                    Navigator.popAndPushNamed(context, '/results',
                        arguments: widget.title);
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
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: (value) {
          formattedEntries[key] = value;
        },
      ),
    );
  }

  Widget _buildAnswerValidation(int key) {
    if (formattedEntries[key]
        .trim()
        .isSimilar(widget.actualAnswers[key].front.trim(), widget.exactMatch)) {
      return _buildCorrectAnswer(key);
    } else {
      return _buildIncorrectAnswer(key);
    }
  }

  Widget _buildCorrectAnswer(int key) {
    return Expanded(
      child: Container(
        color: Colors.green,
        padding: const EdgeInsets.all(8),
        child: Text(
          formattedEntries[key],
          style: const TextStyle(fontSize: 20),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildIncorrectAnswer(int key) {
    return Expanded(
      child: Row(
        children: [
          _buildUserAnswer(key), // Remove the Expanded wrapper here
          const SizedBox(width: 8),
          _buildActualAnswer(key), // And here
        ],
      ),
    );
  }

  Widget _buildUserAnswer(int key) {
    // Removed the outer Expanded widget
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(8),
      child: Text(
        formattedEntries[key].isNotEmpty ? formattedEntries[key] : "Missed",
        style: const TextStyle(fontSize: 20),
        softWrap: true,
      ),
    );
  }

  Widget _buildActualAnswer(int key) {
    // Removed the outer Expanded widget
    return Container(
      color: Colors.yellow,
      padding: const EdgeInsets.all(8),
      child: Text(
        widget.actualAnswers[key].front,
        style: const TextStyle(fontSize: 20),
        softWrap: true,
      ),
    );
  }
}
