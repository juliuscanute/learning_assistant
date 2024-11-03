import 'package:learning_assistant/domain/entities/spaced_entity.dart';

class SpacedRevisionEventModel extends SpacedRevisionEventEntity {
  SpacedRevisionEventModel({
    required DateTime revisionDate,
    required DateTime dateRevised,
    required int scoreAcquired,
    required int totalScore,
  }) : super(
          revisionDate: revisionDate,
          dateRevised: dateRevised,
          scoreAcquired: scoreAcquired,
          totalScore: totalScore,
        );

  factory SpacedRevisionEventModel.fromEntity(
      SpacedRevisionEventEntity entity) {
    return SpacedRevisionEventModel(
      revisionDate: entity.revisionDate,
      dateRevised: entity.dateRevised,
      scoreAcquired: entity.scoreAcquired,
      totalScore: entity.totalScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revisionDate': revisionDate.toIso8601String(),
      'dateRevised': dateRevised.toIso8601String(),
      'scoreAcquired': scoreAcquired,
      'totalScore': totalScore,
    };
  }
}

class SpacedRevisionEventGroupModel extends SpacedRevisionEventGroupEntity {
  SpacedRevisionEventGroupModel({
    required int id,
    required String deckId,
    required String deckTitle,
    required List<SpacedRevisionEventModel> revisions,
  }) : super(
          id: id,
          deckId: deckId,
          deckTitle: deckTitle,
          revisions: revisions,
        );

  factory SpacedRevisionEventGroupModel.fromEntity(
      SpacedRevisionEventGroupEntity entity) {
    return SpacedRevisionEventGroupModel(
      id: entity.id,
      deckId: entity.deckId,
      deckTitle: entity.deckTitle,
      revisions: entity.revisions
          .map((revision) => SpacedRevisionEventModel.fromEntity(revision))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'deckTitle': deckTitle,
      'revisions': revisions
          .map((revision) => (revision as SpacedRevisionEventModel).toJson())
          .toList(),
    };
  }
}
