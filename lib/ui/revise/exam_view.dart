import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ExamView extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final List<CardEmbedded> actualAnswers;
  final String title;

  ExamView({required this.actualAnswers, required this.title});

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
      if (formattedEntries[i].trim() == widget.actualAnswers[i].front.trim()) {
        correct++;
      } else if (formattedEntries[i].isNotEmpty) {
        wrong++;
      } else {
        missed++;
      }
    }
    widget.resultRepository
        .addResult(widget.title, correct, wrong, missed, DateTime.now());
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
                        (!validate)
                            ? Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    formattedEntries[entry.key] = value;
                                  },
                                ),
                              )
                            : Expanded(
                                child: (formattedEntries[entry.key].trim() ==
                                        widget.actualAnswers[entry.key].front
                                            .trim())
                                    ? Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          formattedEntries[entry.key],
                                          style: const TextStyle(fontSize: 20),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: Colors.red,
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                formattedEntries[entry.key]
                                                        .isNotEmpty
                                                    ? formattedEntries[
                                                        entry.key]
                                                    : "Missed",
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              color: Colors.yellow,
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                widget.actualAnswers[entry.key]
                                                    .front,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
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
                  validate = true;
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
}
