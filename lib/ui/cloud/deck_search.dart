import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/presentation/bloc/deck_search_bloc.dart';
import 'package:learning_assistant/presentation/bloc/deck_search_event.dart';
import 'package:learning_assistant/presentation/bloc/deck_search_state.dart';
import 'package:learning_assistant/ui/cloud/deck_list_item_new.dart';

class DeckSearch extends StatefulWidget {
  final DeckSearchBloc deckSearchBloc;
  const DeckSearch({Key? key, required this.deckSearchBloc}) : super(key: key);

  @override
  _DeckSearchState createState() => _DeckSearchState();
}

class _DeckSearchState extends State<DeckSearch> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.deckSearchBloc.add(ClearSearch());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= 4) {
        widget.deckSearchBloc.add(SearchDecks(_searchController.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search here',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.length >= 4) {
                      widget.deckSearchBloc
                          .add(SearchDecks(_searchController.text));
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                _onSearchChanged();
              },
              onSubmitted: (value) {
                if (value.length >= 4) {
                  widget.deckSearchBloc.add(SearchDecks(value));
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DeckSearchBloc, DeckSearchState>(
              bloc: widget.deckSearchBloc,
              builder: (context, state) {
                if (state is DeckSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DeckSearchLoaded) {
                  if (state.decks.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.decks.length,
                    itemBuilder: (context, index) {
                      final deck = state.decks[index];
                      final leafNode = {
                        'title': deck['title'] ?? 'Untitled',
                        'deckId': deck['deckId'],
                        'videoUrl': deck['videoUrl'],
                        'mapUrl': deck['mapUrl'],
                        'type': 'card',
                        'isPublic': deck['isPublic'] ?? false,
                      };
                      return SizedBox(
                        width: double.infinity,
                        child: DeckCardNew(deck: leafNode),
                      );
                    },
                  );
                } else if (state is DeckSearchError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                      child: Text('Enter at least 4 characters to search.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
