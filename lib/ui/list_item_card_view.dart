import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ListItemCard extends StatefulWidget {
  final Id id;
  final String description;
  final bool isReviewed;
  final EventLog eventLog;
  final eventRepository = ServiceLocator.instance.get<EventRepository>();

  ListItemCard({
    Key? key,
    required this.id,
    required this.description,
    required this.isReviewed,
    required this.eventLog,
  }) : super(key: key);

  @override
  _ListItemCardState createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
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
                  Text(
                    widget.description,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isReviewed ? 'Revised' : 'Not revised',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.eventRepository.updateReviewed(
                              widget.id,
                            );
                          });
                        },
                        icon: Icon(widget.isReviewed
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                      ),
                    ],
                  ),
                  if (isExpanded)
                    Column(
                        children: widget.eventLog.events.map((element) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(right: 12.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('d MMMM y').format(element.date),
                            ),
                            Spacer(),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: element.isReviewed
                                  ? Colors.green
                                  : Colors.red,
                            ),
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
}
