import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';

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

class ScoreCardsScreen extends StatefulWidget {
  final List<ScoreCard> cards;
  final SpacedRevisionBloc spacedRevisionBloc;

  const ScoreCardsScreen({
    Key? key,
    required this.cards,
    required this.spacedRevisionBloc,
  }) : super(key: key);

  @override
  _ScoreCardsScreenState createState() => _ScoreCardsScreenState();
}

class _ScoreCardsScreenState extends State<ScoreCardsScreen> {
  String _selectedFilter = 'today';

  List<String> filterOptions = [
    'today',
    'tomorrow',
    'on 3rd day',
    'on 7th day',
    'on 15th day',
    'on 30th day',
    'this week',
    'this month',
    'previous week',
    'previous month',
    'this year',
  ];

  List<ScoreCard> getFilteredCards() {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (_selectedFilter) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'tomorrow':
        startDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'on 3rd day':
        startDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 3));
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'on 7th day':
        startDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 7));
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'on 15th day':
        startDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 15));
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'on 30th day':
        startDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 30));
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'this week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'this month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case 'previous week':
        startDate = now.subtract(Duration(days: now.weekday + 6));
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'previous month':
        startDate = DateTime(now.year, now.month - 1, 1);
        endDate = DateTime(now.year, now.month, 1);
        break;
      case 'this year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
    }

    return widget.cards.where((card) {
      return card.entries.any((entry) {
        DateTime entryDate = DateTime.parse(entry.date);
        return entryDate.isAfter(startDate) && entryDate.isBefore(endDate);
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCards = getFilteredCards();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Filter by:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: filterOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredCards.isEmpty
                ? Center(
                    child: Text(
                      'No spaced revisions available.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ScoreCardWidget(
                          card: filteredCards[index],
                          spacedRevisionBloc: widget.spacedRevisionBloc,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ScoreCardWidget extends StatelessWidget {
  final ScoreCard card;
  final SpacedRevisionBloc spacedRevisionBloc;

  const ScoreCardWidget({
    Key? key,
    required this.card,
    required this.spacedRevisionBloc,
  }) : super(key: key);

  String getScoreDisplay(int score, int totalScore) {
    return score == -1 ? 'N/A' : '$score/$totalScore';
  }

  String getStatus(int score, int totalScore, bool isUpcoming) {
    if (isUpcoming) {
      return 'Upcoming';
    }
    if (score == -1) {
      return 'N/A';
    }
    final percentage = (score / totalScore) * 100;
    if (percentage < 80) {
      return 'Try Harder';
    } else if (percentage >= 80 && percentage < 100) {
      return 'Keep it Up';
    } else if (percentage == 100) {
      return 'Well Done';
    }
    return '';
  }

  Color getStatusColor(int score, int totalScore, bool isUpcoming) {
    if (isUpcoming) {
      return Colors.blue;
    }
    if (score == -1) {
      return Colors.grey;
    }
    final percentage = (score / totalScore) * 100;
    if (percentage < 80) {
      return Colors.red;
    } else if (percentage >= 80 && percentage < 100) {
      return Colors.orange;
    } else if (percentage == 100) {
      return Colors.green;
    }
    return Colors.black;
  }

  String formatDate(String date) {
    final revisionDate = DateTime.parse(date);
    final day = DateFormat('d').format(revisionDate);
    final suffix = getDaySuffix(int.parse(day));
    final formattedDate =
        DateFormat("d'$suffix' MMMM yyyy").format(revisionDate);
    return formattedDate;
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row with Delete Button
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      card.title,
                      style: theme.textTheme.headlineMedium,
                      maxLines: null, // Allow multiline
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      spacedRevisionBloc
                          .add(DeleteSpacedRevisionWithId(card.id));
                    },
                  ),
                ],
              ),
            ),
            // Headers Row
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.dividerColor),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Score',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Status',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            // Entries
            ExpansionTile(
              title: const Text('Expand time table'),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: card.entries.length,
                  itemBuilder: (context, index) {
                    final entry = card.entries[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatDate(entry.date),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              getScoreDisplay(entry.score, card.totalScore),
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              getStatus(entry.score, card.totalScore, entry.isUpcoming),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: getStatusColor(entry.score, card.totalScore, entry.isUpcoming),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            // Take Test Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final deck =
                        await spacedRevisionBloc.getCompleteDeck(card.id);
                    Navigator.pushNamed(context, '/train', arguments: deck);
                  },
                  child: const Text('Review'),
                ),
              ),
            ),
          ],
        ),
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
