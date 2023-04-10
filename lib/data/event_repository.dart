import 'dart:async';
import 'dart:ffi';

import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';

class EventRepository {
  final Isar isar;
  final _eventController = StreamController<List<Event>>();
  Stream<List<Event>> get events => _eventController.stream;

  EventRepository(this.isar);

  Future<EventLog?> insertEventLog() async {
    return await isar.writeTxn(() async {
      final eventLog = EventLog();
      final id = await isar.eventLogs.put(eventLog);
      return isar.eventLogs.get(id);
    });
  }

  Future<void> updateEventLog(int eventLogId, Event event) async {
    await isar.writeTxn(() async {
      final existingEventLog = await isar.eventLogs.get(eventLogId);
      if (existingEventLog != null) {
        existingEventLog.events.add(event);
        await isar.eventLogs.put(existingEventLog);
      }
    });
  }

  Future<void> insertEvent(Event event, EventLog eventLog) async {
    await isar.writeTxn(() async {
      await isar.events.put(event);
      await event.eventLog.save();
      _eventController.add(await getEventsOnDate(DateTime.now()));
    });
  }

  Future<void> filterEventsOnDate(DateTime date) async {
    _eventController.add(await getEventsOnDate(date));
  }

  Future<List<Event>> getEventsOnDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final events =
        await isar.events.filter().dateBetween(startOfDay, endOfDay).findAll();
    return events;
  }

  Future<void> updateReviewed(Id eventId) async {
    await isar.writeTxn(() async {
      final existingEvent = await isar.events.get(eventId);
      if (existingEvent != null) {
        existingEvent.isReviewed = !existingEvent.isReviewed;
        await isar.events.put(existingEvent);
        _eventController.add(await getEventsOnDate(existingEvent.date));
      }
    });
  }
}
