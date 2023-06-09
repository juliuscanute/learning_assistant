import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/event_repository.dart';

class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static void setup(Isar isar) async {
    instance.registerSingleton(isar);
    instance.registerLazySingleton(() => EventRepository(instance.get()));
  }
}
