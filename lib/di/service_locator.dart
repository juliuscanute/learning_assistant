import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/data/result_repository.dart';

class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static void setup(Isar isar) async {
    instance.registerSingleton(isar);
    instance.registerLazySingleton(() => EventRepository(instance.get()));
    instance.registerLazySingleton(() => CardsRepository(instance.get()));
    instance.registerLazySingleton(() => FirebaseService());
    instance.registerFactory(() => ResultRepository(instance.get()));
  }
}
