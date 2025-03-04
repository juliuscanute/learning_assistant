import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:learning_assistant/data/blog_repository.dart';
import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/data/repositories/event_repository_impl.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/data/service/analytics_service.dart'
    if (dart.library.io) 'package:learning_assistant/data/service/analytics_service_stub.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';
import 'package:learning_assistant/domain/usecases/delete_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/get_complete_deck..dart';
import 'package:learning_assistant/domain/usecases/get_events_on_date.dart';
import 'package:learning_assistant/domain/usecases/get_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/get_spaced_revisoin_updates.dart';
import 'package:learning_assistant/domain/usecases/has_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/insert_event_group.dart';
import 'package:learning_assistant/domain/usecases/search_decks_use_case.dart';
import 'package:learning_assistant/domain/usecases/set_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/update_spaced_revision.dart';
import 'package:learning_assistant/presentation/bloc/deck_search_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_check_bloc.dart';
import 'package:learning_assistant/ui/blog/blog_bloc.dart';

final sl = GetIt.instance;

Future<void> init(Isar isar) async {
  // Repository
  sl.registerLazySingleton<IEventRepository>(
    () => EventRepositoryImpl(sl()),
  );
  // Bloc
  sl.registerLazySingleton(
    () => EventBloc(
      getEventsOnDate: sl(),
      insertEventGroup: sl(),
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => EventDetailsBloc(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SpacedRevisionBloc(sl(), sl(), sl(), sl()),
  );

  sl.registerLazySingleton(
    () => SpacedRevisionCheckBloc(sl()),
  );

  sl.registerLazySingleton(
    () => DeckSearchBloc(sl()),
  );

  sl.registerLazySingleton(
    () => BlogBloc(sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetEventsOnDate(sl()));
  sl.registerLazySingleton(() => InsertEventGroup(sl()));
  sl.registerLazySingleton(() => SetSpacedRevision(sl()));
  sl.registerLazySingleton(() => GetSpacedRevision(sl()));
  sl.registerLazySingleton(() => HasSpacedRevision(sl()));
  sl.registerLazySingleton(() => UpdateSpacedRevision(sl()));
  sl.registerLazySingleton(() => DeleteSpacedRevision(sl()));
  sl.registerLazySingleton(() => GetSpacedRevisoinUpdates(sl()));
  sl.registerLazySingleton(() => GetCompleteDeck(sl()));
  sl.registerLazySingleton(() => SearchDecksUseCase());

  // External
  sl.registerLazySingleton(() => isar);

  sl.registerLazySingleton(() => CardsRepository(sl()));
  sl.registerLazySingleton(() => FirebaseService());
  sl.registerLazySingleton(() => AnalyticsService());
  sl.registerLazySingleton(() => BlogRepository());
  sl.registerFactory(() => ResultRepository(sl()));
}
