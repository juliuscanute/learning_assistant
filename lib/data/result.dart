import 'package:isar/isar.dart';

part 'result.g.dart';

@collection
class ResultGroup {
  Id id = Isar.autoIncrement;
  String title;
  int correct;
  int wrong;
  int missed;
  DateTime date;
  ResultGroup(this.title, this.correct, this.wrong, this.missed, this.date);
}
