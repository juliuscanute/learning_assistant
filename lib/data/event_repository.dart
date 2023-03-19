import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event.dart';

class EventRepository {
  final Isar isar;

  EventRepository(this.isar);

  Future<void> insertEvent(Event event) async {
    await isar.writeTxn(() async {
      await isar.events.put(event);
    });
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
}
