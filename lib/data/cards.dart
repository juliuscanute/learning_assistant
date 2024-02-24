import 'dart:ffi';

import 'package:isar/isar.dart';

part 'cards.g.dart';

@collection
class FlashCardGroup {
  Id id = Isar.autoIncrement;
  String title;
  List<CardEmbedded> cards;
  FlashCardGroup(this.title, this.cards);
}

@embedded
class CardEmbedded {
  late int index;
  late String front;
  late String back;
  String? imageUrl;
}
