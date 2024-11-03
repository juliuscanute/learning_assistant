import 'package:learning_assistant/domain/repositories/event_repository.dart';

class GetSpacedRevisoinUpdates {
  final IEventRepository repository;

  GetSpacedRevisoinUpdates(this.repository);

  Stream<bool> call() {
    return repository.watchSpacedRevisionEventGroups();
  }
}
