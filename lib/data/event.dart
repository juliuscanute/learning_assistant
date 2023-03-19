import 'package:isar/isar.dart';

part 'event.g.dart';

@collection
class Event {
  Id id = Isar.autoIncrement;

  late String description;
  late DateTime date;

  Event(this.description, this.date);
}
