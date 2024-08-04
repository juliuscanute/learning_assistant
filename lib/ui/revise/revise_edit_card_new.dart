import 'package:flutter/material.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/revise/revise_add_cards_new.dart';

class ReviseEditCardsFB extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<CardsRepository>();
  final FlashCardGroup group;

  ReviseEditCardsFB({super.key, required this.group});

  @override
  ReviseEditCardsStateFB createState() => ReviseEditCardsStateFB();
}

class ReviseEditCardsStateFB extends State<ReviseEditCardsFB> {
  String title = "";
  List<CardItem> cards = [];
  final ScrollController _scrollController = ScrollController();

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

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      title = widget.group.title;
      titleController.text = widget.group.title;
      cards = widget.group.cards
          .map((e) => CardItem(front: e.front, back: e.back))
          .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $title'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.all(16.0), // Increased padding
              ),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
            SizedBox(
              width: 150, // Set width
              child: OutlinedButton(
                // Changed to OutlinedButton
                onPressed: addCard,
                child: const Text('Add Card'),
              ),
            ),
            SizedBox(
              width: 150, // Set width
              child: ElevatedButton(
                onPressed: () {
                  widget.eventRepository.updateDeck(
                      widget.group.id,
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
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
