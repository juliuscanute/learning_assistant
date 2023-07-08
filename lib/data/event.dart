import 'dart:ffi';

import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class EventGroup {
  Id id = Isar.autoIncrement;
  List<Event> events;
  EventGroup(this.events);
}

@embedded
class Event {
  DateTime? date;
  List<Description>? descriptions;
}

@embedded
class Description {
  String? description;
  bool? isReviewed;
}
