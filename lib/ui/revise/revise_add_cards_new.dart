import 'package:flutter/material.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ReviseAddCardsFB extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<CardsRepository>();

  ReviseAddCardsFB({super.key});

  @override
  ReviseAddCardsFBState createState() => ReviseAddCardsFBState();
}

class ReviseAddCardsFBState extends State<ReviseAddCardsFB> {
  List<CardItem> cards = [];
  ScrollController _scrollController = ScrollController();

  void addCard() {
    setState(() {
      cards.add(CardItem(front: '', back: ''));
    });
    _scrollToEnd();
  }

  void deleteCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flash Cards'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.all(16.0), // Increased padding
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                CardItem card = cards[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: TextEditingController(text: card.front),
                          decoration: InputDecoration(
                            labelText: 'Front',
                            contentPadding:
                                EdgeInsets.all(16.0), // Increased padding
                          ),
                          onChanged: (value) {
                            card.front = value;
                          },
                        ),
                        TextField(
                          controller: TextEditingController(text: card.back),
                          decoration: InputDecoration(
                            labelText: 'Back',
                            contentPadding:
                                EdgeInsets.all(16.0), // Increased padding
                          ),
                          onChanged: (value) {
                            card.back = value;
                          },
                        ),
                        ButtonBar(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteCard(index);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150, // Set width
              child: OutlinedButton(
                // Changed to OutlinedButton
                onPressed: addCard,
                child: Text('Add Card'),
              ),
            ),
            Container(
              width: 150, // Set width
              child: ElevatedButton(
                onPressed: () {
                  widget.eventRepository.addDeck(
                      titleController.text,
                      cards
                          .asMap()
                          .entries
                          .map((entry) => CardEmbedded()
                            ..index = entry.key
                            ..back = entry.value.back
                            ..front = entry.value.front)
                          .toList());
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardItem {
  String front;
  String back;

  CardItem({required this.front, required this.back});

  @override
  String toString() {
    return 'Front: $front, Back: $back';
  }
}
