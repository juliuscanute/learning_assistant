import 'dart:async';

import 'package:isar/isar.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/spaced_revision_event.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/entities/spaced_entity.dart';
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

  Future<void> insertSpacedRevisionEventGroup(
      SpacedRevisionEventGroupEntity group) async {
    try {
      await isar.writeTxn(() async {
        final spacedRevisionEventGroup = SpacedRevisionEventGroup(
          group.deckId,
          group.deckTitle,
          group.revisions
              .map((e) => SpacedRevisionEvent()
                ..revisionDate = e.revisionDate
                ..dateRevised = e.dateRevised
                ..scoreAcquired = e.scoreAcquired
                ..totalScore = e.totalScore)
              .toList(),
        );
        await isar.spacedRevisionEventGroups.put(spacedRevisionEventGroup);
      });
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<SpacedRevisionEventGroupEntity>>
      getSpacedRevisionEventGroups() async {
    try {
      final groups = await isar.spacedRevisionEventGroups.where().findAll();
      return groups.map((group) {
        return SpacedRevisionEventGroupEntity(
          id: group.id,
          deckId: group.deckId,
          deckTitle: group.deckTitle,
          revisions: group.revisions.map((revision) {
            return SpacedRevisionEventEntity(
              revisionDate: revision.revisionDate,
              dateRevised: revision.dateRevised,
              scoreAcquired: revision.scoreAcquired,
              totalScore: revision.totalScore,
            );
          }).toList(),
        );
      }).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<bool> isSpacedEventGroupPresent(String deckId) async {
    try {
      final group = await isar.spacedRevisionEventGroups
          .filter()
          .deckIdEqualTo(deckId)
          .findFirst();
      return group != null;
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> updateSpacedRevisionScoreWhenDateMatches(
      DateTime date, int score) async {
    try {
      await isar.writeTxn(() async {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));

        final group = await isar.spacedRevisionEventGroups
            .filter()
            .revisionsElement((revision) =>
                revision.revisionDateBetween(startOfDay, endOfDay))
            .findFirst();

        if (group != null) {
          final revision = group.revisions.firstWhere((element) =>
              element.revisionDate.isAfter(startOfDay) &&
              element.revisionDate.isBefore(endOfDay));
          revision.scoreAcquired = score;
          await isar.spacedRevisionEventGroups.put(group);
        }
      });
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> deleteSpacedRevisionEventGroup(String deckId) async {
    try {
      await isar.writeTxn(() async {
        final groups = await isar.spacedRevisionEventGroups
            .filter()
            .deckIdEqualTo(deckId)
            .findAll();
        for (var group in groups) {
          await isar.spacedRevisionEventGroups.delete(group.id);
        }
      });
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Stream<bool> watchSpacedRevisionEventGroups() {
    try {
      return isar.spacedRevisionEventGroups.watchLazy().map((_) => true);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }
}
