class SpacedRevisionEventEntity {
  final DateTime revisionDate;
  final DateTime dateRevised;
  final int scoreAcquired;
  final int totalScore;

  SpacedRevisionEventEntity({
    required this.revisionDate,
    required this.dateRevised,
    required this.scoreAcquired,
    required this.totalScore,
  });
}

class SpacedRevisionEventGroupEntity {
  final int id;
  final String deckId;
  final String deckTitle;
  final List<SpacedRevisionEventEntity> revisions;

  SpacedRevisionEventGroupEntity({
    required this.id,
    required this.deckId,
    required this.deckTitle,
    required this.revisions,
  });
}
