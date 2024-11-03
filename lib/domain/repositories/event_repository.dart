import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/entities/spaced_entity.dart';

abstract class IEventRepository {
  Future<void> insertEventGroup(EventGroupEntity group);
  Future<List<EventEntity>> getEventsOnDate(DateTime date);
  Future<EventGroupEntity?> getEventGroup(
      DateTime timeOfEvent, String description);
  Future<void> updateReviewed(DateTime timeOfEvent, String description);
  Future<void> insertSpacedRevisionEventGroup(
      SpacedRevisionEventGroupEntity group);
  Stream<List<SpacedRevisionEventGroupEntity>> getSpacedRevisionEventGroups();
  Future<bool> isSpacedEventGroupPresent(String deckId);
  Future<void> updateSpacedRevisionScoreWhenDateMatches(
      DateTime date, int score);
  Future<void> deleteSpacedRevisionEventGroup(String id);
}
