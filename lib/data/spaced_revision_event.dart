import 'package:isar/isar.dart';

part 'spaced_revision_event.g.dart';

@collection
class SpacedRevisionEventGroup {
  Id id = Isar.autoIncrement;
  late String deckId;
  late String deckTitle;
  late List<SpacedRevisionEvent> revisions;

  SpacedRevisionEventGroup(this.deckId, this.deckTitle, this.revisions);
}

@embedded
class SpacedRevisionEvent {
  late DateTime revisionDate;
  late DateTime dateRevised;
  late int scoreAcquired;
  late int totalScore;
}
