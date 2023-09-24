import 'package:flutter/material.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ExamView extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final List<String> actualAnswers;
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
      if (formattedEntries[i].trim() == widget.actualAnswers[i].trim()) {
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
      body: Column(
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
                        "${entry.key})",
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
                                      widget.actualAnswers[entry.key].trim())
                                  ? Container(
                                      color: Colors.green,
                                      child: Text(
                                        formattedEntries[entry.key],
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        formattedEntries[entry.key].isNotEmpty
                                            ? Container(
                                                color: Colors.red,
                                                child: Text(
                                                  formattedEntries[entry.key],
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                              )
                                            : Container(),
                                        Container(
                                          color: formattedEntries[entry.key]
                                                  .isEmpty
                                              ? Colors.yellow
                                              : Colors.green,
                                          child: Text(
                                            widget.actualAnswers[entry.key],
                                            style:
                                                const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    )),
                    ],
                  ),
                ))
            .toList(),
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
