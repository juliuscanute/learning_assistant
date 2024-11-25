import 'package:flutter/material.dart';
import 'package:learning_assistant/presentation/bloc/spaced_revision_bloc.dart';
import 'package:learning_assistant/presentation/pages/score_card_widget.dart';
import 'package:learning_assistant/presentation/pages/spaced_revision_page.dart';

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
  DateTime? _customDate;

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
    'custom',
  ];

  Future<void> _selectCustomDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _customDate) {
      setState(() {
        _customDate = picked;
        _selectedFilter = 'custom';
      });
    }
  }

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
      case 'custom':
        if (_customDate != null) {
          startDate = DateTime(_customDate!.year, _customDate!.month, _customDate!.day);
          endDate = startDate.add(const Duration(days: 1));
        } else {
          return widget.cards;
        }
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
                    if (newValue == 'custom') {
                      _selectCustomDate(context);
                    } else {
                      setState(() {
                        _selectedFilter = newValue!;
                        _customDate = null;
                      });
                    }
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