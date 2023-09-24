import 'dart:async';

import 'package:isar/isar.dart';
import 'package:learning_assistant/data/result.dart';

class ResultRepository {
  final Isar isar;
  ResultRepository(this.isar);
  final _eventController = StreamController<List<ResultGroup>>();
  Stream<List<ResultGroup>> get events => _eventController.stream;

  void addResult(String title, int correct, int wrong, int missed,
      DateTime dateTime) async {
    await isar.writeTxn(() async {
      final group = ResultGroup(title, correct, wrong, missed, dateTime);
      await isar.resultGroups.put(group);
      await getResultGroup(title);
    });
  }

  Future<List<ResultGroup>> getResultGroup(String title) async {
    final group =
        await isar.resultGroups.filter().titleContains(title).findAll();
    _eventController.add(group);
    return group;
  }
}
