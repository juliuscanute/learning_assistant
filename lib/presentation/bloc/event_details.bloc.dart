import 'package:bloc/bloc.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';

abstract class EventDetailsState {}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsLoaded extends EventDetailsState {
  final List<EventEntity> events;
  EventDetailsLoaded(this.events);
}

class EventDetailsError extends EventDetailsState {
  final String message;
  EventDetailsError(this.message);
}

abstract class EventDetailsEvent {}

class LoadEventDetails extends EventDetailsEvent {
  final DateTime date;
  final String description;
  LoadEventDetails({required this.date, required this.description});
}

class UpdateEventReview extends EventDetailsEvent {
  final DateTime timeOfEvent;
  final String description;
  UpdateEventReview(this.timeOfEvent, this.description);
}

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final IEventRepository repository;

  EventDetailsBloc({required this.repository}) : super(EventDetailsInitial()) {
    on<LoadEventDetails>((event, emit) async {
      emit(EventDetailsLoading());
      try {
        final eventGroup = await repository.getEventGroup(
          event.date,
          event.description,
        );
        if (eventGroup != null) {
          emit(EventDetailsLoaded(eventGroup.events));
        } else {
          emit(EventDetailsLoaded([]));
        }
      } catch (e) {
        emit(EventDetailsError(e.toString()));
      }
    });
    on<UpdateEventReview>((event, emit) async {
      emit(EventDetailsLoading());
      try {
        await repository.updateReviewed(event.timeOfEvent, event.description);
        final events = await repository.getEventGroup(
            event.timeOfEvent, event.description);
        emit(EventDetailsLoaded(events?.events ?? []));
      } catch (e) {
        emit(EventDetailsError(e.toString()));
      }
    });
  }
}
