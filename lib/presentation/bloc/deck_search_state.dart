abstract class DeckSearchState {
  const DeckSearchState();
}

class DeckSearchInitial extends DeckSearchState {}

class DeckSearchLoading extends DeckSearchState {}

class DeckSearchLoaded extends DeckSearchState {
  final List<Map<String, dynamic>> decks;

  const DeckSearchLoaded(this.decks);
}

class DeckSearchError extends DeckSearchState {
  final String message;

  const DeckSearchError(this.message);
}