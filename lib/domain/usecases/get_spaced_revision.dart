import 'package:learning_assistant/domain/entities/spaced_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

class GetSpacedRevision {
  final IEventRepository repository;

  GetSpacedRevision(this.repository);

  Stream<List<SpacedRevisionEventGroupEntity>> call() {
    return repository.getSpacedRevisionEventGroups();
  }
}
