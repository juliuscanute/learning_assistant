import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

class InsertEventGroup implements UseCase<void, EventGroupEntity> {
  final IEventRepository repository;

  InsertEventGroup(this.repository);

  @override
  Future<void> call(EventGroupEntity params) {
    return repository.insertEventGroup(params);
  }
}
