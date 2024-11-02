import 'dart:async';

import 'package:isar/isar.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements IEventRepository {
  final Isar isar;
  final _eventController = StreamController<List<EventEntity>>();

  EventRepositoryImpl(this.isar);

  @override
  Future<void> insertEventGroup(EventGroupEntity group) async {
    try {
      await isar.writeTxn(() async {
        final eventGroup = EventGroup(
          group.events
              .map((e) => Event()
                ..date = e.date
                ..descriptions = e.descriptions
                    .map((d) => Description()
                      ..description = d.description
                      ..isReviewed = d.isReviewed)
                    .toList())
              .toList(),
        );
        await isar.eventGroups.put(eventGroup);
      });
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<EventEntity>> getEventsOnDate(DateTime date) async {
    try {
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
          .where((element) =>
              element.date.isAfter(startOfDay) &&
              element.date.isBefore(endOfDay))
          .map((e) => EventEntity(
                date: e.date,
                descriptions: e.descriptions
                    .map((d) => DescriptionEntity(
                          description: d.description,
                          isReviewed: d.isReviewed,
                        ))
                    .toList(),
              ))
          .toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> filterEventsOnDate(DateTime date) async {
    _eventController.add(await getEventsOnDate(date));
  }

  @override
  Future<EventGroupEntity?> getEventGroup(
      DateTime timeOfEvent, String description) async {
    try {
      final group = await isar.eventGroups
          .filter()
          .eventsElement((event) => event.dateEqualTo(timeOfEvent))
          .and()
          .eventsElement((event) => event.descriptionsElement(
              (desc) => desc.descriptionContains(description)))
          .findFirst();

      if (group == null) return null;

      return EventGroupEntity(
        id: group.id,
        events: group.events
            .map((e) => EventEntity(
                  date: e.date,
                  descriptions: e.descriptions
                      .map((d) => DescriptionEntity(
                            description: d.description,
                            isReviewed: d.isReviewed,
                          ))
                      .toList(),
                ))
            .toList(),
      );
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> updateReviewed(DateTime timeOfEvent, String description) async {
    try {
      EventGroup? group = await isar.eventGroups
          .filter()
          .eventsElement((event) => event.dateEqualTo(timeOfEvent))
          .and()
          .eventsElement((event) => event.descriptionsElement(
              (desc) => desc.descriptionContains(description)))
          .findFirst();

      await isar.writeTxn(() async {
        if (group != null) {
          Event event = group.events.firstWhere(
              (element) => element.date.isAtSameMomentAs(timeOfEvent));
          Description desc = event.descriptions
              .firstWhere((element) => element.description == description);
          desc.isReviewed = !desc.isReviewed;
          await isar.eventGroups.put(group);
          _eventController.add(await getEventsOnDate(timeOfEvent));
        }
      });
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }
}
