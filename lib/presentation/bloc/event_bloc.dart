import 'package:bloc/bloc.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/domain/repositories/event_repository.dart';
import 'package:learning_assistant/domain/usecases/get_events_on_date.dart';
import 'package:learning_assistant/domain/usecases/insert_event_group.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<EventEntity> events;
  EventLoaded(this.events);
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}

abstract class EventEvent {}

class GetEventsForDate extends EventEvent {
  final DateTime date;
  GetEventsForDate(this.date);
}

class AddNewEvent extends EventEvent {
  final EventGroupEntity eventGroup;
  AddNewEvent(this.eventGroup);
}

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsOnDate getEventsOnDate;
  final InsertEventGroup insertEventGroup;
  final IEventRepository repository;

  EventBloc({
    required this.getEventsOnDate,
    required this.insertEventGroup,
    required this.repository,
  }) : super(EventLoading()) {
    on<GetEventsForDate>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await getEventsOnDate(event.date);
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<AddNewEvent>((event, emit) async {
      emit(EventLoading());
      try {
        await insertEventGroup(event.eventGroup);
        final events = await getEventsOnDate(DateTime.now());
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
  }
}
