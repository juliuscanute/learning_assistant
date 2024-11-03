import 'package:learning_assistant/domain/entities/spaced_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

class SetSpacedRevision {
  final IEventRepository repository;

  SetSpacedRevision(this.repository);

  Future<void> call(
      String deckId, String deckTitle, int currentScore, int totalScore) async {
    final DateTime now = DateTime.now();

    final List<SpacedRevisionEventEntity> revisions = [
      SpacedRevisionEventEntity(
        revisionDate: now,
        dateRevised: now,
        scoreAcquired: currentScore,
        totalScore: totalScore,
      ),
      SpacedRevisionEventEntity(
        revisionDate: now.add(const Duration(days: 1)),
        dateRevised: now,
        scoreAcquired: -1,
        totalScore: -1,
      ),
      SpacedRevisionEventEntity(
        revisionDate: now.add(const Duration(days: 3)),
        dateRevised: now,
        scoreAcquired: -1,
        totalScore: -1,
      ),
      SpacedRevisionEventEntity(
        revisionDate: now.add(const Duration(days: 7)),
        dateRevised: now,
        scoreAcquired: -1,
        totalScore: -1,
      ),
      SpacedRevisionEventEntity(
        revisionDate: now.add(const Duration(days: 15)),
        dateRevised: now,
        scoreAcquired: -1,
        totalScore: -1,
      ),
      SpacedRevisionEventEntity(
        revisionDate: now.add(const Duration(days: 30)),
        dateRevised: now,
        scoreAcquired: -1,
        totalScore: -1,
      ),
    ];

    final SpacedRevisionEventGroupEntity eventGroup =
        SpacedRevisionEventGroupEntity(
      id: 0, // Assuming auto-increment
      deckId: deckId,
      deckTitle: deckTitle,
      revisions: revisions,
    );

    await repository.insertSpacedRevisionEventGroup(eventGroup);
  }
}
