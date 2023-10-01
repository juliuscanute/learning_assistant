import 'package:flutter/material.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ReviseItemCard extends StatefulWidget {
  final FlashCardGroup group;
  final cardRepository = ServiceLocator.instance.get<CardsRepository>();

  ReviseItemCard({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  ReviseItemCardState createState() => ReviseItemCardState();
}

class ReviseItemCardState extends State<ReviseItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pushNamed('/train', arguments: widget.group);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 32.0),
                  )
                ],
              ),
            ),
            ButtonBar(
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/edit-revise', arguments: widget.group);
                    }),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.cardRepository.deleteDeck(widget.group.id);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
