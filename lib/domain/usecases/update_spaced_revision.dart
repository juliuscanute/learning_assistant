import 'package:learning_assistant/domain/repositories/event_repository.dart';

class UpdateSpacedRevision {
  final IEventRepository _spacedRepetitionRepository;

  UpdateSpacedRevision(this._spacedRepetitionRepository);

  Future<void> call(String deckId, DateTime date, int score) async {
    return _spacedRepetitionRepository.updateSpacedRevisionScoreWhenDateMatches(
        date, score);
  }
}
