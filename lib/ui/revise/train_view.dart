import 'package:flutter/material.dart';
import 'dart:async';

import 'package:learning_assistant/data/cards.dart';

class TrainView extends StatefulWidget {
  final FlashCardGroup group;

  const TrainView({required this.group});

  @override
  TrainViewWidgetState createState() => TrainViewWidgetState();
}

class TrainViewWidgetState extends State<TrainView> {
  final _timeGapController = TextEditingController();
  late CardEmbedded currentText;
  late bool autoChange;
  late bool randomOrder;
  late int timeGap;
  late int currentIndex;
  late Timer? textChangeTimer;
  late bool isStartEnabled;
  late bool isFinishEnabled;
  late List<CardEmbedded> cardValues;

  @override
  void initState() {
    super.initState();
    currentText = CardEmbedded()
      ..front = ""
      ..back = ""
      ..index = -1;
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
            GestureDetector(
              onTap: () {
                _nextCard();
              },
              child: FlipContainer(
                index: currentIndex,
                front: currentText.front,
                back: currentText.back,
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
                  SizedBox(height: 16.0), // Add space between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Time Gap"),
                      SizedBox(width: 8.0),
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
  final String back;

  const FlipContainer(
      {required this.index, required this.front, required this.back});

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
          child: buildSide(widget.front),
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
          child: buildSide(widget.back),
        ),
        if (widget.front.isNotEmpty && widget.back.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.flip, color: Colors.white),
              onPressed: () {
                if (isFront) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                isFront = !isFront;
              },
            ),
          ),
      ],
    );
  }

  Widget buildSide(String text) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.blue,
      child: Center(
        child: RichText(
          text: TextSpan(children: [
            if (text.isNotEmpty) // Conditionally include currentIndex
              TextSpan(
                text: "${widget.index} ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
            TextSpan(
              text: text,
              style: const TextStyle(
                color: Colors.yellow, // Change the color to your desired color
                fontSize: 36,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
