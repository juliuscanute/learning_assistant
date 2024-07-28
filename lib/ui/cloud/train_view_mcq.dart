import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'dart:async';

import 'package:learning_assistant/data/fash_card.dart';

class TrainViewMcq extends StatefulWidget {
  final FlashCardDeck group;

  const TrainViewMcq({required this.group});

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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(autoChange
                          ? "Automatic"
                          : "On Tap"), // Change text based on autoChange
                      Switch(
                        value: autoChange,
                        onChanged: (value) {
                          setState(() {
                            autoChange = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(randomOrder
                          ? "Random Order"
                          : "Given Order"), // Change text based on randomOrder
                      Switch(
                        value: randomOrder,
                        onChanged: (value) {
                          setState(() {
                            randomOrder = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0), // Add space between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Time Gap"),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 50.0,
                        child: TextField(
                          controller: _timeGapController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              timeGap = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
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
            Container(
              width: 150,
              child: OutlinedButton(
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
            Container(
              width: 150,
              child: ElevatedButton(
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

  const FlipContainer(
      {required this.index,
      required this.front,
      required this.back,
      this.imageUrl = "",
      this.frontTex,
      this.backTex});

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
          child: buildSide(widget.frontTex?.isNotEmpty == true
              ? widget.frontTex!
              : widget.front),
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
          child: buildSide(widget.backTex?.isNotEmpty == true
              ? widget.backTex!
              : widget.back),
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
                    icon: const Icon(Icons.visibility, color: Colors.black),
                    onPressed: () {
                      _showRecallImageDialog(widget.imageUrl ?? "");
                    },
                  ),
                // Flip Icon Button
                if (widget.front.isNotEmpty && widget.back.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.flip, color: Colors.black),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSide(String text) {
    final cardText = (widget.index == 0)
        ? ''
        : r'''$$\textcolor{red}{''' +
            widget.index.toString() +
            r'''}$$''' +
            ensureLatexSyntax(text);
    final style = TeXViewStyle(
      contentColor: isFront ? Colors.yellow : Colors.blue,
      textAlign: TeXViewTextAlign.center,
      fontStyle: TeXViewFontStyle(fontSize: 44),
      width: MediaQuery.of(context).size.width.toInt(),
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      color: isFront ? Colors.blue : Colors.yellow,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: TeXView(
          renderingEngine: const TeXViewRenderingEngine.mathjax(),
          loadingWidgetBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          child: TeXViewColumn(
              style: style,
              children: [TeXViewDocument(cardText, style: style)]),
        ),
      ),
    );
  }

  String ensureLatexSyntax(String text) {
    return '<p>$text</p>';
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
                      return Center(
                        child: Container(
                          height: 48,
                          width: 48,
                          child: const CircularProgressIndicator(),
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
