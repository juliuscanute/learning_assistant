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
  late String currentText;
  late bool autoChange;
  late bool randomOrder;
  late int timeGap;
  late int currentIndex;
  late Timer? textChangeTimer;
  late bool isStartEnabled;
  late bool isFinishEnabled;
  late List<String> cardValues;

  @override
  void initState() {
    super.initState();
    currentText = "";
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
        title: Text("Train"), // Change app bar title to "Train"
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _nextCard();
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.blue,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    // Wrap the FittedBox with a Container
                    child: Text(
                      currentText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
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
            ElevatedButton(
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
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Screen"),
      ),
      body: Center(
        child: Text("This is the new screen."),
      ),
    );
  }
}
