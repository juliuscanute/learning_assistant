import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'dart:async';

import 'package:learning_assistant/data/flash_card.dart';
import 'package:learning_assistant/ext/latext.dart';

class TrainViewMcq extends StatefulWidget {
  final FlashCardDeck group;

  const TrainViewMcq({super.key, required this.group});

  @override
  TrainViewWidgetState createState() => TrainViewWidgetState();
}

class TrainViewWidgetState extends State<TrainViewMcq> {
  final _timeGapController = TextEditingController();
  late FlashCard currentText;
  late bool autoChange;
  late bool randomOrder;
  late int timeGap;
  late int currentIndex;
  late Timer? textChangeTimer;
  late bool isStartEnabled;
  late bool isFinishEnabled;
  late List<FlashCard> cardValues;

  @override
  void initState() {
    super.initState();
    currentText = FlashCard.createEmptyFlashCard();
    autoChange = true;
    randomOrder = false;
    timeGap = 1;
    isStartEnabled = true;
    isFinishEnabled = false;
    cardValues = widget.group.cards;
    _timeGapController.text = timeGap.toString();
    currentIndex = 0;
  }

  void _startAutoChange() {
    if (widget.group.cards.isNotEmpty && autoChange) {
      textChangeTimer = Timer.periodic(Duration(seconds: timeGap), (timer) {
        setState(() {
          if (randomOrder) {
            cardValues.shuffle();
          }
          if (currentIndex < widget.group.cards.length) {
            currentText = cardValues[currentIndex];
            // Navigator.of(context, rootNavigator: true).pop('dialog');
            currentIndex++;
          } else {
            textChangeTimer?.cancel();
          }
        });
      });
    }
  }

  void _nextCard() {
    setState(() {
      if (randomOrder) {
        cardValues.shuffle();
      }
      if (currentIndex < widget.group.cards.length) {
        currentText = cardValues[currentIndex];
        // Navigator.of(context, rootNavigator: true).pop('dialog');
        currentIndex++;
      } else {
        isStartEnabled = false;
        isFinishEnabled = true;
      }
    });
  }

  void _stopAutoChange() {
    textChangeTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Train ${widget.group.title}"), // Change app bar title to "Train"
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _nextCard();
              },
              child: FlipContainer(
                index: currentIndex,
                imageUrl: currentText.imageUrl ?? "",
                front: currentText.front,
                frontTex: currentText.frontTex ?? "",
                back: currentText.back,
                backTex: currentText.backTex ?? "",
                explanation: currentText.explanation ?? "",
                explanationTex: currentText.explanationTex ?? "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('On Tap'),
                        ),
                      ),
                      Switch(
                        value: autoChange,
                        onChanged: (value) {
                          setState(() {
                            autoChange = value;
                          });
                        },
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Automatic'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Given Order'),
                        ),
                      ),
                      Switch(
                        value: randomOrder,
                        onChanged: (value) {
                          setState(() {
                            randomOrder = value;
                          });
                        },
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Random Order'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0), // Add space between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Time Gap"),
                      const SizedBox(width: 8.0),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (timeGap > 1) timeGap--;
                              });
                            },
                          ),
                          Text('$timeGap s'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (timeGap < 60) timeGap++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
                onPressed: isStartEnabled
                    ? () {
                        setState(() {
                          isFinishEnabled = true;
                          isStartEnabled = false;
                        });
                        if (autoChange) {
                          _startAutoChange();
                        }
                      }
                    : null,
                child: const Text("Start"),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                ),
                onPressed: isFinishEnabled
                    ? () {
                        setState(() {
                          isFinishEnabled = false;
                          isStartEnabled = true;
                        });
                        if (autoChange) {
                          _stopAutoChange();
                        }
                        Navigator.of(context)
                            .popAndPushNamed('/exam', arguments: widget.group);
                      }
                    : null,
                child: const Text("Finish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlipContainer extends StatefulWidget {
  final int index;
  final String front;
  final String? frontTex;
  final String back;
  final String? backTex;
  final String? imageUrl;
  final String? explanation;
  final String? explanationTex;

  const FlipContainer(
      {super.key,
      required this.index,
      required this.front,
      required this.back,
      this.imageUrl = "",
      this.frontTex,
      this.backTex,
      this.explanation,
      this.explanationTex});

  @override
  _FlipContainerState createState() => _FlipContainerState();
}

class _FlipContainerState extends State<FlipContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    isFront = true;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant FlipContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      isFront = true;
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(3.14 * (_controller.value)),
              child: _controller.value >= 0.5 ? Container() : child,
            );
          },
          child: buildSide(
              widget.frontTex?.isNotEmpty == true
                  ? widget.frontTex!
                  : widget.front,
              widget.frontTex?.isNotEmpty == true),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(3.14 * (_controller.value - 1)),
              child: _controller.value < 0.5 ? Container() : child,
            );
          },
          child: buildSide(
              widget.backTex?.isNotEmpty == true
                  ? widget.backTex!
                  : widget.back,
              widget.backTex?.isNotEmpty == true),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Use min to prevent the Row from occupying more space than its children need.
              children: [
                // Recall Icon Button
                if (widget.imageUrl?.isNotEmpty == true)
                  IconButton(
                    icon: Icon(Icons.visibility,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () {
                      _showRecallImageDialog(widget.imageUrl ?? "");
                    },
                  ),
                // Flip Icon Button
                if (widget.front.isNotEmpty && widget.back.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.flip,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () {
                      if (isFront) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                      setState(() {
                        isFront = !isFront;
                      });
                    },
                  ),

                // Explanation Icon Button
                if (widget.explanation?.isNotEmpty == true ||
                    widget.explanationTex?.isNotEmpty == true)
                  IconButton(
                    icon: Icon(Icons.info,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () {
                      // Add your logic to show the explanation here
                      _showExplanationDialog(
                          widget.explanation ?? widget.explanationTex ?? "",
                          widget.explanationTex?.isNotEmpty == true);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showExplanationDialog(String explanation, bool isTex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Explanation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                isTex
                    ? LaTexT(
                        laTeXCode: Text(
                          explanation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : Text(
                        explanation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSide(String text, bool isTex) {
    final cardText = (widget.index == 0)
        ? ''
        : r'''$$\textcolor{red}{''' +
            widget.index.toString() +
            r'''}$$''' +
            '\\n' +
            ensureLatexSyntax(text, isTex);
    ;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      color: isFront
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: LaTexT(
              laTeXCode: Text(
            cardText,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: !isFront
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary),
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }

  String ensureLatexSyntax(String text, bool isTex) {
    if (isTex && !text.contains('\$\$')) {
      return '\$\$$text\$\$';
    }
    return text;
  }

  void _showRecallImageDialog(String imageUrl) {
    // isDialogShown = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Recall Image"),
          content: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 48,
                    ));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ) // Display the image from the URL
              : const Text("No recall image available"),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                // isDialogShown = false;
              },
            ),
          ],
        ); //.then((value) {
        //isDialogShown = false;
        //})
      },
    );
  }
}
