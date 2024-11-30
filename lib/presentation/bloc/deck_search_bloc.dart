import 'package:bloc/bloc.dart';
import 'package:learning_assistant/domain/usecases/search_decks_use_case.dart';
import 'deck_search_event.dart';
import 'deck_search_state.dart';

class DeckSearchBloc extends Bloc<DeckSearchEvent, DeckSearchState> {
  final SearchDecksUseCase _searchDecksUseCase;

  DeckSearchBloc(this._searchDecksUseCase) : super(DeckSearchInitial()) {
    on<SearchDecks>(_onSearchDecks);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchDecks(SearchDecks event, Emitter<DeckSearchState> emit) async {
    emit(DeckSearchLoading());
    try {
      final decks = await _searchDecksUseCase(event.query);
      emit(DeckSearchLoaded(decks));
    } catch (e) {
      emit(DeckSearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<DeckSearchState> emit) {
    emit(DeckSearchInitial());
  }
}