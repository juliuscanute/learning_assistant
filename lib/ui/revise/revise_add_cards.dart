import 'package:flutter/material.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ReviseAddCards extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<CardsRepository>();

  ReviseAddCards({super.key});

  @override
  ReviseAddCardsState createState() => ReviseAddCardsState();
}

class ReviseAddCardsState extends State<ReviseAddCards> {
  TextEditingController titleController = TextEditingController();
  TextEditingController cardsController = TextEditingController();

  void saveFlashcards() async {
    final title = titleController.text;
    final cards = cardsController.text;

    if (title.isNotEmpty && cards.isNotEmpty) {
      // Save the flashcards (You can define your own logic here)
      // For now, we'll print the title and cards
      widget.eventRepository.addDeck(title, cards.split('\n'));
      Navigator.pop(context);
      // Clear the input fields
      titleController.clear();
      cardsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flash Cards'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter a title',
                ),
              ),
              const SizedBox(height: 16.0), // Add some spacing
              const Text(
                'Cards',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: cardsController,
                maxLines: null, // Allow multiple lines of text
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Add flash cards with line breaks',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: saveFlashcards,
                child: const Text('Save Flashcards'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
