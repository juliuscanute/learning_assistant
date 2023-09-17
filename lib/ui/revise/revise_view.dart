import 'package:flutter/material.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/revise/revise_item_card.dart';

class ReviseScreen extends StatefulWidget {
  final cardRepository = ServiceLocator.instance.get<CardsRepository>();
  ReviseScreen({Key? key}) : super(key: key);

  @override
  ReviseScreenViewState createState() => ReviseScreenViewState();
}

class ReviseScreenViewState extends State<ReviseScreen> {
  @override
  void initState() {
    super.initState();
    widget.cardRepository.getFlashGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: StreamBuilder<List<FlashCardGroup>>(
        stream: widget.cardRepository.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final group = snapshot.data![index];
                return ReviseItemCard(
                  group: group,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-revise');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
