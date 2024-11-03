import 'package:learning_assistant/domain/repositories/event_repository.dart';

class HasSpacedRevision {
  final IEventRepository _spacedRevisionsRepository;

  HasSpacedRevision(this._spacedRevisionsRepository);

  Future<bool> call(String spacedRevisionId) async {
    return await _spacedRevisionsRepository
        .isSpacedEventGroupPresent(spacedRevisionId);
  }
}
