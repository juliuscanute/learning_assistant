abstract class DeckSearchEvent {
  const DeckSearchEvent();
}

class SearchDecks extends DeckSearchEvent {
  final String query;

  const SearchDecks(this.query);
}


class ClearSearch extends DeckSearchEvent {}