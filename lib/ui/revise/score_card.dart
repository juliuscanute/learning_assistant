import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/result.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';

class ScoreCardListScreen extends StatefulWidget {
  final resultRepository = ServiceLocator.instance.get<ResultRepository>();
  final String title;
  ScoreCardListScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _ScoreCardListScreenState createState() => _ScoreCardListScreenState();
}

class _ScoreCardListScreenState extends State<ScoreCardListScreen> {
  @override
  void initState() {
    super.initState();
    widget.resultRepository.getResultGroup(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ResultGroup>>(
        stream: widget.resultRepository.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final group = snapshot.data![index];
                return ScoreCardWidget(
                  date: group.date,
                  correct: group.correct,
                  missed: group.missed,
                  wrong: group.wrong,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ScoreCardWidget extends StatelessWidget {
  final DateTime date;
  final int correct;
  final int wrong;
  final int missed;

  const ScoreCardWidget({
    required this.date,
    required this.correct,
    required this.wrong,
    required this.missed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              'Date: ${DateFormat('MMM d, y - HH:mm:ss').format(date)}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12.0),
            Text('Correct: $correct',
                style: const TextStyle(color: Colors.green)),
            Text('Wrong: $wrong', style: const TextStyle(color: Colors.red)),
            Text('Missed: $missed',
                style: const TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
