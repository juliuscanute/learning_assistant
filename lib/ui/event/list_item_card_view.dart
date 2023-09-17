import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ListItemCard extends StatefulWidget {
  final Event event;
  final eventRepository = ServiceLocator.instance.get<EventRepository>();

  ListItemCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  ListItemCardState createState() => ListItemCardState();
}

class ListItemCardState extends State<ListItemCard> {
  bool isExpanded = false;
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          setState(() {
            isExpanded = !isExpanded;
            updateEvents();
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: widget.event.descriptions
                          .map((desc) => Row(
                                children: [
                                  Text(
                                    desc.description,
                                    maxLines: isExpanded ? null : 4,
                                    overflow: isExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Checkbox(
                                    value: desc.isReviewed,
                                    onChanged: (value) async {
                                      await widget.eventRepository
                                          .updateReviewed(widget.event.date,
                                              desc.description);
                                      updateEvents();
                                    },
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  if (isExpanded)
                    Column(
                        children: events.map((element) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('d MMMM y').format(element.date),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    determineColor(element.descriptions)),
                          ],
                        ),
                      );
                    }).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateEvents() async {
    EventGroup? group = await widget.eventRepository.getEventGroup(
        widget.event.date, widget.event.descriptions.first.description);
    setState(() {
      events = group?.events ?? [];
    });
  }

  Color determineColor(List<Description> items) {
    bool allTrue = items.every((item) => item.isReviewed == true);
    bool someTrue = items.any((item) => item.isReviewed == true);

    if (allTrue) {
      return Colors.green;
    } else if (someTrue) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
