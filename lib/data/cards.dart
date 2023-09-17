import 'package:isar/isar.dart';

part 'cards.g.dart';

@collection
class FlashCardGroup {
  Id id = Isar.autoIncrement;
  String title;
  List<String> cards;
  FlashCardGroup(this.title, this.cards);
}
