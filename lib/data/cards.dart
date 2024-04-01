import 'dart:ffi';

import 'package:isar/isar.dart';

part 'cards.g.dart';

@collection
class FlashCardGroup {
  Id id = Isar.autoIncrement;
  String title;
  List<String> tags;
  List<CardEmbedded> cards;
  bool exactMatch = true;
  FlashCardGroup(this.title, this.tags, this.cards);
}

@embedded
class CardEmbedded {
  late int index;
  late String front;
  late String back;
  String? imageUrl;
}
