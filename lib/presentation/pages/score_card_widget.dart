import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';
import 'package:learning_assistant/presentation/pages/spaced_revision_page.dart';

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
