import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';
import 'package:learning_assistant/presentation/pages/score_cards_screen.dart';

class SpacedRevisionPage extends StatefulWidget {
  final SpacedRevisionBloc spacedRevisionBloc;
  const SpacedRevisionPage({Key? key, required this.spacedRevisionBloc})
      : super(key: key);

  @override
  _SpacedRevisionPageState createState() => _SpacedRevisionPageState();
}

class _SpacedRevisionPageState extends State<SpacedRevisionPage> {
  @override
  void initState() {
    super.initState();
    widget.spacedRevisionBloc.add(LoadSpacedRevisions());
    widget.spacedRevisionBloc.updates.listen((event) {
      widget.spacedRevisionBloc.add(LoadSpacedRevisions());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaced Revisions'),
      ),
      body: BlocBuilder<SpacedRevisionBloc, SpacedRevisionState>(
        bloc: widget.spacedRevisionBloc,
        builder: (context, state) {
          if (state is SpacedRevisionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SpacedRevisionError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SpacedRevisionLoaded) {
            final spacedRevisions = state.spacedRevisions;
            final scoreCards = spacedRevisions.map((group) {
              return ScoreCard(
                id: group.deckId,
                title: group.deckTitle,
                totalScore: group.revisions.first.totalScore,
                entries: group.revisions.map((revision) {
                  final revisionDate =
                      DateTime.parse(revision.revisionDate.toIso8601String());
                  final isUpcoming = revisionDate.isAfter(DateTime.now());
                  return ScoreEntry(
                    date: revision.revisionDate.toIso8601String(),
                    score: isUpcoming ? -1 : revision.scoreAcquired,
                    isUpcoming: isUpcoming,
                  );
                }).toList(),
              );
            }).toList();

            return ScoreCardsScreen(
              cards: scoreCards,
              spacedRevisionBloc: widget.spacedRevisionBloc,
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

class ScoreCard {
  final String id;
  final String title;
  final int totalScore;
  final List<ScoreEntry> entries;

  const ScoreCard({
    required this.id,
    required this.title,
    required this.totalScore,
    required this.entries,
  });
}

class ScoreEntry {
  final String date;
  final int score;
  final bool isUpcoming;

  const ScoreEntry({
    required this.date,
    required this.score,
    required this.isUpcoming,
  });
}
