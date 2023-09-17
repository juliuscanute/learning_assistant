import 'dart:async';

import 'package:isar/isar.dart';
import 'package:learning_assistant/data/cards.dart';

class CardsRepository {
  final Isar isar;
  CardsRepository(this.isar);
  final _eventController = StreamController<List<FlashCardGroup>>();
  Stream<List<FlashCardGroup>> get events => _eventController.stream;

  void addDeck(String title, List<String> cards) async {
    await isar.writeTxn(() async {
      final group = FlashCardGroup(title, cards);
      await isar.flashCardGroups.put(group);
      await getFlashGroup();
    });
  }

  Future<List<FlashCardGroup>> getFlashGroup() async {
    final group = await isar.flashCardGroups.where().findAll();
    _eventController.add(group);
    return group;
  }
}
