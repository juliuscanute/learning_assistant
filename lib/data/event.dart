import 'dart:ffi';

import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id id = Isar.autoIncrement;

  late String description;
  late DateTime date;
  bool isReviewed = false;

  Event(this.description, this.date, this.isReviewed);
}
