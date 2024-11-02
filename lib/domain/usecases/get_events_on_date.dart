import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

class GetEventsOnDate implements UseCase<List<EventEntity>, DateTime> {
  final IEventRepository repository;

  GetEventsOnDate(this.repository);

  @override
  Future<List<EventEntity>> call(DateTime date) {
    return repository.getEventsOnDate(date);
  }
}
