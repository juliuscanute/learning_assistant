import 'package:learning_assistant/domain/repositories/event_repository.dart';

class DeleteSpacedRevision {
  final IEventRepository _spacedRevisionRepository;

  DeleteSpacedRevision(this._spacedRevisionRepository);

  Future<void> call(String spacedRevisionId) async {
    return _spacedRevisionRepository
        .deleteSpacedRevisionEventGroup(spacedRevisionId);
  }
}
