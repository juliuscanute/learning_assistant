import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/domain/usecases/has_spaced_revision.dart';

abstract class SpacedRevisionCheckEvent {}

class CheckSpacedRevision extends SpacedRevisionCheckEvent {
  final String spacedRevisionId;

  CheckSpacedRevision(this.spacedRevisionId);
}

abstract class SpacedRevisionCheckState {}

class SpacedRevisionCheckInitial extends SpacedRevisionCheckState {}

class SpacedRevisionCheckLoading extends SpacedRevisionCheckState {}

class SpacedRevisionCheckLoaded extends SpacedRevisionCheckState {
  final bool hasSpacedRevision;

  SpacedRevisionCheckLoaded(this.hasSpacedRevision);
}

class SpacedRevisionCheckError extends SpacedRevisionCheckState {
  final String message;

  SpacedRevisionCheckError(this.message);
}

class SpacedRevisionCheckBloc
    extends Bloc<SpacedRevisionCheckEvent, SpacedRevisionCheckState> {
  final HasSpacedRevision hasSpacedRevision;

  SpacedRevisionCheckBloc(this.hasSpacedRevision)
      : super(SpacedRevisionCheckInitial()) {
    on<CheckSpacedRevision>((event, emit) async {
      emit(SpacedRevisionCheckLoading());
      try {
        final hasRevision = await hasSpacedRevision(event.spacedRevisionId);
        emit(SpacedRevisionCheckLoaded(hasRevision));
      } catch (e) {
        emit(SpacedRevisionCheckError(e.toString()));
      }
    });
  }
}
