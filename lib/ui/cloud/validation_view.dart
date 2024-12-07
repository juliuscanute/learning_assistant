import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/injection_container.dart';
import 'package:learning_assistant/domain/usecases/set_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/update_spaced_revision.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_check_bloc.dart';
import 'package:learning_assistant/ext/latext.dart';
import 'package:learning_assistant/ext/string_ext.dart';

class ValidationParameters {
  final FlashCardDeck flashCardGroup;
  final List<String> userAnswers;

  ValidationParameters({
    required this.flashCardGroup,
    required this.userAnswers,
  });
}

class ValidationView extends StatefulWidget {
  final FlashCardDeck flashCardGroup;
  final List<String> userAnswers;

  ValidationView({
    Key? key,
    required this.flashCardGroup,
    required this.userAnswers,
  }) : super(key: key);

  @override
  _ValidationViewState createState() => _ValidationViewState();
}

class _ValidationViewState extends State<ValidationView> {
  final resultRepository = sl<ResultRepository>();
  final spacedRevision = sl<SetSpacedRevision>();
  final spacedRevisionCheckBloc = sl<SpacedRevisionCheckBloc>();
  final updateSpacedRevision = sl<UpdateSpacedRevision>();
  var correctCount = 0;
  var missedCount = 0;
  var wrongCount = 0;
  bool isButtonVisible = true;
  List<EvaluationEntry> processedEntries = [];

  @override
  void initState() {
    super.initState();
    processedEntries = _processAnswers();
    spacedRevisionCheckBloc.add(CheckSpacedRevision(widget.flashCardGroup.id));
    spacedRevisionCheckBloc.stream.listen((state) {
      if (state is SpacedRevisionCheckLoaded && state.hasSpacedRevision) {
        updateSpacedRevision.call(
          widget.flashCardGroup.id,
          DateTime.now(),
          correctCount,
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showScoreDialog();
    });
  }

  void _showScoreDialog() {
    final isScorePerfect = correctCount == processedEntries.length;
    final color = isScorePerfect ? Colors.green : Colors.red;
    final scorePercentage = (correctCount / processedEntries.length) * 100;
    String title;

    if (scorePercentage < 50) {
      title = 'Try harder';
    } else if (scorePercentage < 80) {
      title = 'Better luck next time';
    } else if (scorePercentage < 100) {
      title = 'Keep it up';
    } else {
      title = 'Great job';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: 200, // Adjust width as needed
            height: 200, // Adjust height as needed
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Oval border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border:
                        Border.all(color: color, width: 4), // Conditional color
                    borderRadius:
                        BorderRadius.circular(100), // Creates the oval shape
                  ),
                  width: 150, // Width of the oval
                  height: 200, // Height of the oval
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Upper half: Correct Count
                    Expanded(
                      child: Center(
                        child: Text(
                          '$correctCount',
                          style: TextStyle(
                            color: color, // Conditional text color
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Divider line
                    Container(
                      width: 100, // Adjust width as needed
                      height: 2,
                      color: color, // Conditional color
                    ),
                    // Lower half: Total Questions
                    Expanded(
                      child: Center(
                        child: Text(
                          '${processedEntries.length}',
                          style: TextStyle(
                            color: color, // Conditional text color
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: color), // Conditional text color
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: formattedRenderer(
                        context,
                        'Question: ',
                        '${entry.card.backTex?.trim().isNotEmpty == true ? entry.card.backTex : entry.card.back}',
                        entry.card.backTex?.trim().isNotEmpty == true,
                        Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: formattedRenderer(
                        context,
                        'Your Answer: ',
                        entry.userAnswer,
                        entry.card.mcqOptionsTex?.isNotEmpty == true
                            ? true
                            : false,
                        entry.state == EvaluationState.correct
                            ? Colors.green
                            : Colors.red),
                  ),
                  if (entry.state != EvaluationState.correct) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: formattedRenderer(
                          context,
                          'Correct Answer: ',
                          '${entry.card.frontTex?.trim().isNotEmpty == true ? entry.card.frontTex : entry.card.front}',
                          entry.card.frontTex?.trim().isNotEmpty == true,
                          Colors.blue),
                    ),
                  ],
                  if (entry.card.explanation != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: formattedRenderer(
                          context,
                          'Explanation: ',
                          '${entry.card.explanationTex?.trim().isNotEmpty == true ? entry.card.explanationTex : entry.card.explanation}',
                          entry.card.explanationTex?.trim().isNotEmpty == true,
                          Theme.of(context).textTheme.bodyMedium!.color!),
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
            BlocBuilder<SpacedRevisionCheckBloc, SpacedRevisionCheckState>(
              bloc: spacedRevisionCheckBloc,
              builder: (context, state) {
                if (state is SpacedRevisionCheckLoaded &&
                    !state.hasSpacedRevision &&
                    isButtonVisible) {
                  return Expanded(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary, // Use secondary color
                        ),
                        onPressed: () async {
                          setState(() {
                            isButtonVisible = false;
                          });
                          spacedRevision(
                            widget.flashCardGroup.id,
                            widget.flashCardGroup.title,
                            correctCount,
                            widget.flashCardGroup.cards.length,
                          );
                        },
                        child: const Text("Spaced Revision"),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            BlocBuilder<SpacedRevisionCheckBloc, SpacedRevisionCheckState>(
              bloc: spacedRevisionCheckBloc,
              builder: (context, state) {
                return Expanded(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.popAndPushNamed(context, '/results',
                            arguments: widget.flashCardGroup.title);
                      },
                      child: const Text("View Results"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<EvaluationEntry> _processAnswers() {
    List<EvaluationEntry> processedEntries = [];

    Map<String, List<String>> actualCards = {};
    for (var card in widget.flashCardGroup.cards) {
      if (actualCards.containsKey(card.back)) {
        actualCards[card.back]!.add(card.front);
      } else {
        actualCards[card.back] = [card.front];
      }
    }
    // question: actualAnswers
    // Q1: A, B, C
    // Q2: D
    // Q3: E, F
    actualCards.forEach((question, actualAnswers) {
      // Create a list of actual answers that are unmatched
      List<String> unmatchedActuals = List<String>.from(actualAnswers);
      List<String> userAnswersForQuestion = [];
      for (int i = 0; i < widget.userAnswers.length; i++) {
        if (question == widget.flashCardGroup.cards[i].back) {
          userAnswersForQuestion.add(widget.userAnswers[i]);
        }
      }

      for (var userAnswer in userAnswersForQuestion) {
        for (var actualAnswer in actualAnswers) {
          final isMatch = userAnswer
              .trim()
              .isSimilar(actualAnswer, widget.flashCardGroup.exactMatch);
          if (isMatch) {
            unmatchedActuals.removeWhere((item) => item
                .trim()
                .isSimilar(actualAnswer, widget.flashCardGroup.exactMatch));
            processedEntries.add(EvaluationEntry(
              question: question,
              userAnswer: userAnswer,
              actualAnswer: actualAnswer,
              state: EvaluationState.correct,
              card: widget.flashCardGroup
                  .cards[widget.userAnswers.indexOf(actualAnswer)],
            ));
            correctCount++;
            break; // Stop checking after the first match
          }
        }
      }

      for (var missedAnswer in unmatchedActuals) {
        final userIndex = widget.flashCardGroup.cards.indexOf(
            widget.flashCardGroup.cards.singleWhere(
                (card) => card.back == question && card.front == missedAnswer));
        if (widget.userAnswers[userIndex].trim().isEmpty) {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: "",
            actualAnswer: missedAnswer,
            state: EvaluationState.missed,
            card: widget.flashCardGroup.cards[userIndex],
          ));
          missedCount++;
        } else {
          processedEntries.add(EvaluationEntry(
            question: question,
            userAnswer: widget.userAnswers[userIndex],
            actualAnswer: missedAnswer,
            state: EvaluationState.wrong,
            card: widget.flashCardGroup.cards[userIndex],
          ));
          wrongCount++;
        }
      }
    });
    resultRepository.addResult(widget.flashCardGroup.title, correctCount,
        wrongCount, missedCount, DateTime.now());

    return processedEntries;
  }

  Widget formattedRenderer(BuildContext context, String prefix, String text,
      bool isTex, Color color) {
    if (isTex) {
      return _renderTexWidget(context, color, prefix + ensureLatexSyntax(text));
    } else {
      return Text(
        prefix + text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
      );
    }
  }

  String ensureLatexSyntax(String text) {
    if (!text.contains('\$\$') && text.isNotEmpty) {
      return '\$\$$text\$\$';
    }
    return text;
  }

  Widget _renderTexWidget(BuildContext context, Color color, String tex) {
    return LaTexT(
      laTeXCode: Text(
        tex,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
        textAlign: TextAlign.start,
      ),
      equationStyle:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
    );
  }
}

enum EvaluationState { undefined, correct, wrong, missed }

class EvaluationEntry {
  String question;
  String userAnswer;
  String actualAnswer;
  EvaluationState state;
  FlashCard card;

  EvaluationEntry({
    required this.question,
    required this.userAnswer,
    required this.actualAnswer,
    required this.state,
    required this.card,
  });
}
