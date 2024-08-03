import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:learning_assistant/data/fash_card.dart';
import 'package:learning_assistant/ui/cloud/validation_view.dart';

class ExamViewMcq extends StatefulWidget {
  final FlashCardDeck flashCardGroup;

  ExamViewMcq({required this.flashCardGroup});

  @override
  _ExamViewMcqState createState() => _ExamViewMcqState();
}

class _ExamViewMcqState extends State<ExamViewMcq> {
  List<String> formattedEntries = [];
  int currentQuestionIndex = 0;

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
                _buildAnswerWidget(currentCard),
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
          // Render TeX version of the back question
          _renderTexWidget(card.backTex!)
        else
          Text(
            card.back,
            style: const TextStyle(fontSize: 16.0),
          ),
      ],
    );
  }

  Widget _buildAnswerWidget(FlashCard card) {
    if ((card.mcqOptions != null && card.mcqOptions!.isNotEmpty)) {
      return Column(
        children: card.mcqOptions!.asMap().entries.map((entry) {
          // Check if mcqOptionsTex is available and use it
          final optionText =
              (card.mcqOptionsTex != null && card.mcqOptionsTex!.isNotEmpty)
                  ? card.mcqOptionsTex![entry.key]
                  : card.mcqOptions![entry.key];

          return RadioListTile<int>(
            title: _buildOptionWidget(optionText,
                card.mcqOptionsTex != null && card.mcqOptionsTex!.isNotEmpty),
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
          );
        }).toList(),
      );
    } else {
      final TextEditingController _controller = TextEditingController();

      // Check if there's an existing answer for the current question
      if (formattedEntries[currentQuestionIndex].isNotEmpty) {
        _controller.text = formattedEntries[currentQuestionIndex];
      }

      return TextField(
        controller: _controller,
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

  Widget _buildOptionWidget(String optionText, bool isTex) {
    if (isTex) {
      return _renderTexWidget(optionText);
    } else {
      return Text(optionText);
    }
  }

  String ensureLatexSyntax(String text) {
    return '<p>$text</p>';
  }

  Widget _renderTexWidget(String tex) {
    return Container(
      child: TeXView(
        renderingEngine: const TeXViewRenderingEngine.mathjax(),
        loadingWidgetBuilder: (context) {
          return const Center(
            child: Text("Please wait..."),
          );
        },
        child:
            TeXViewColumn(children: [TeXViewDocument(ensureLatexSyntax(tex))]),
      ),
    );
  }
}
