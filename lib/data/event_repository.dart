import 'dart:async';

import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';

class EventRepository {
  final Isar isar;
  final _eventController = StreamController<List<Event>>();
  Stream<List<Event>> get events => _eventController.stream;

  EventRepository(this.isar);

  Future<void> insertEventLog(EventGroup group) async {
    return await isar.writeTxn(() async {
      await isar.eventGroups.put(group);
      _eventController.add(await getEventsOnDate(DateTime.now()));
    });
  }

  Future<List<Event>> getEventsOnDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final groups = await isar.eventGroups
        .filter()
        .eventsElement((event) => event.dateBetween(startOfDay, endOfDay))
        .findAll();
    return groups
        .expand((e) => e.events)
        .toList()
        .where((element) =>
            element.date!.isAfter(startOfDay) &&
            element.date!.isBefore(endOfDay))
        .toList();
  }

  Future<void> filterEventsOnDate(DateTime date) async {
    _eventController.add(await getEventsOnDate(date));
  }

  Future<EventGroup?> getEventGroup(
      DateTime timeOfEvent, String description) async {
    return await isar.eventGroups
        .filter()
        .eventsElement((event) => event.dateEqualTo(timeOfEvent))
        .and()
        .eventsElement((event) => event.descriptionsElement(
            (desc) => desc.descriptionContains(description)))
        .findFirst();
  }

  Future<void> updateReviewed(DateTime timeOfEvent, String description) async {
    EventGroup? group = await getEventGroup(timeOfEvent, description);
    await isar.writeTxn(() async {
      if (group != null) {
        Event event = group.events.firstWhere(
            (element) => element.date!.isAtSameMomentAs(timeOfEvent));
        Description desc = event.descriptions!
            .firstWhere((element) => element.description == description);
        desc.isReviewed = !desc.isReviewed!;
        await isar.eventGroups.put(group);
        _eventController.add(await getEventsOnDate(timeOfEvent));
      }
    });
  }
}
