import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/domain/entities/spaced_entity.dart';
import 'package:learning_assistant/domain/usecases/delete_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/get_complete_deck..dart';
import 'package:learning_assistant/domain/usecases/get_spaced_revision.dart';
import 'package:learning_assistant/domain/usecases/get_spaced_revisoin_updates.dart';

abstract class SpacedRevisionEvent {}

class LoadSpacedRevisions extends SpacedRevisionEvent {}

abstract class SpacedRevisionState {}

class SpacedRevisionInitial extends SpacedRevisionState {}

class SpacedRevisionLoading extends SpacedRevisionState {}

class SpacedRevisionLoaded extends SpacedRevisionState {
  final List<SpacedRevisionEventGroupEntity> spacedRevisions;

  SpacedRevisionLoaded(this.spacedRevisions);
}

class DeleteSpacedRevisionWithId extends SpacedRevisionEvent {
  final String spacedRevisionId;

  DeleteSpacedRevisionWithId(this.spacedRevisionId);
}

class SpacedRevisionError extends SpacedRevisionState {
  final String message;

  SpacedRevisionError(this.message);
}

class SpacedRevisionBloc
    extends Bloc<SpacedRevisionEvent, SpacedRevisionState> {
  final GetSpacedRevision getSpacedRevision;
  final DeleteSpacedRevision deleteSpacedRevision;
  final GetSpacedRevisoinUpdates getSpacedRevisoinUpdates;
  final GetCompleteDeck getCompleteDeck;

  Stream<bool> get updates => getSpacedRevisoinUpdates();

  SpacedRevisionBloc(this.getSpacedRevision, this.deleteSpacedRevision,
      this.getSpacedRevisoinUpdates, this.getCompleteDeck)
      : super(SpacedRevisionInitial()) {
    on<LoadSpacedRevisions>((event, emit) async {
      emit(SpacedRevisionLoading());
      try {
        final spacedRevisions = await getSpacedRevision();
        emit(SpacedRevisionLoaded(spacedRevisions));
      } catch (e) {
        emit(SpacedRevisionError(e.toString()));
      }
    });

    on<DeleteSpacedRevisionWithId>((event, emit) async {
      emit(SpacedRevisionLoading());
      try {
        await deleteSpacedRevision(event.spacedRevisionId);
        final spacedRevisions = await getSpacedRevision();
        emit(SpacedRevisionLoaded(spacedRevisions));
      } catch (e) {
        emit(SpacedRevisionError(e.toString()));
      }
    });
  }
}
