import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/data/repositories/event_repository_impl.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';
import 'package:learning_assistant/domain/usecases/get_events_on_date.dart';
import 'package:learning_assistant/domain/usecases/insert_event_group.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';

final sl = GetIt.instance;

Future<void> init(Isar isar) async {
  // Bloc
  sl.registerLazySingleton(
    () => EventBloc(
      getEventsOnDate: sl(),
      insertEventGroup: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetEventsOnDate(sl()));
  sl.registerLazySingleton(() => InsertEventGroup(sl()));

  // Repository
  sl.registerLazySingleton<IEventRepository>(
    () => EventRepositoryImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => isar);

  sl.registerLazySingleton(
    () => EventDetailsBloc(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(() => CardsRepository(sl()));
  sl.registerLazySingleton(() => FirebaseService());
  sl.registerFactory(() => ResultRepository(sl()));
}
