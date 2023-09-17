import 'package:flutter/material.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ReviseItemCard extends StatefulWidget {
  final FlashCardGroup group;
  final eventRepository = ServiceLocator.instance.get<EventRepository>();

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
          //TODO: Handle navigate to train
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
          ],
        ),
      ),
    );
  }
}
