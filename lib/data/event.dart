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
  late DateTime date;
  late List<Description> descriptions;
}

@embedded
class Description {
  late String description;
  late bool isReviewed;
}
