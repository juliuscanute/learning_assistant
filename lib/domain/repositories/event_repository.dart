import 'package:learning_assistant/domain/entities/event_entity.dart';

abstract class IEventRepository {
  Future<void> insertEventGroup(EventGroupEntity group);
  Future<List<EventEntity>> getEventsOnDate(DateTime date);
  Future<EventGroupEntity?> getEventGroup(
      DateTime timeOfEvent, String description);
  Future<void> updateReviewed(DateTime timeOfEvent, String description);
}
