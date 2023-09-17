import 'package:flutter/material.dart';

class ExamView extends StatefulWidget {
  final List<String> actualAnswers;

  ExamView({required this.actualAnswers});

  @override
  ExamViewWidgetState createState() => ExamViewWidgetState();
}

class ExamViewWidgetState extends State<ExamView> {
  TextEditingController _textEditingController = TextEditingController();
  List<FormattedEntry> formattedEntries = [];

  @override
  void initState() {
    super.initState();
    _initializeFormattedEntries();
  }

  void _initializeFormattedEntries() {
    formattedEntries = widget.actualAnswers.map((answer) {
      return FormattedEntry(
        text: answer,
        color: Colors.green,
        isValid: false,
      );
    }).toList();
  }

  void _validateAndHighlightEntries() {
    List<String> userEntries = _textEditingController.text.split('\n');
    for (int i = 0; i < widget.actualAnswers.length; i++) {
      String answer = widget.actualAnswers[i];
      bool isValid = userEntries.contains(answer);
      formattedEntries[i] = FormattedEntry(
        text: '${i + 1}) $answer',
        color: isValid ? Colors.green : Colors.red,
        isValid: isValid,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textAlign: TextAlign.left,
        ),
        RichText(
          text: TextSpan(
            children: formattedEntries
                .map((entry) => TextSpan(
                      text: entry.text + '\n',
                      style: TextStyle(
                        color: entry.color,
                      ),
                    ))
                .toList(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _validateAndHighlightEntries();
          },
          child: Text("Submit"),
        )
      ],
    );
  }
}

class FormattedEntry {
  final String text;
  final Color color;
  final bool isValid;

  FormattedEntry({
    required this.text,
    required this.color,
    required this.isValid,
  });
}
