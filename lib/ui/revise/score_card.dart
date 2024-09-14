import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/result.dart';
import 'package:learning_assistant/data/result_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';

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
  final ValueNotifier<List<ResultGroup>> items =
      ValueNotifier<List<ResultGroup>>([]);

  void generatePdf(List<ResultGroup> scores) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) {
          return pdf.Table(children: [
            pdf.TableRow(children: [
              pdf.Container(
                decoration: pdf.BoxDecoration(border: pdf.Border.all()),
                child: pdf.Text('Date',
                    style: pdf.TextStyle(
                        fontSize: 6, fontWeight: pdf.FontWeight.bold)),
              ),
              pdf.Container(
                decoration: pdf.BoxDecoration(border: pdf.Border.all()),
                child: pdf.Text('Result',
                    style: pdf.TextStyle(
                        fontSize: 6, fontWeight: pdf.FontWeight.bold)),
              ),
            ]),
            for (var i = 0; i < scores.length; i++)
              pdf.TableRow(children: [
                pdf.Container(
                  decoration: pdf.BoxDecoration(border: pdf.Border.all()),
                  child: pdf.Text(
                      DateFormat('MMM d, y - HH:mm:ss').format(scores[i].date),
                      style: const pdf.TextStyle(
                          fontSize:
                              6)), // Assuming reportedItems[i][0] contains the date
                ),
                pdf.Container(
                  decoration: pdf.BoxDecoration(border: pdf.Border.all()),
                  child: pdf.Text(
                      "${scores[i].correct}/${scores[i].correct + scores[i].wrong + scores[i].missed}",
                      style: const pdf.TextStyle(
                          fontSize:
                              6)), // Assuming reportedItems[i][1] contains the result
                ),
              ])
          ]);
        },
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.resultRepository.getResultGroup(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ResultGroup>>(
      stream: widget.resultRepository.events,
      builder: (context, snapshot) {
        // Update the ValueNotifier value here
        if (snapshot.hasData) {
          items.value = snapshot.data!;
        }
        return ValueListenableBuilder(
          valueListenable: items,
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                  if (value.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.print),
                      onPressed: () {
                        generatePdf(value);
                      },
                    ),
                ],
              ),
              body: !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.data!.isEmpty
                      ? const Center(child: Text('No results found.'))
                      : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final group = value[index];
                            return ScoreCardWidget(
                              date: group.date,
                              correct: group.correct,
                              missed: group.missed,
                              wrong: group.wrong,
                            );
                          },
                        ),
            );
          },
        );
      },
    );
  }
}

class ScoreCardWidget extends StatelessWidget {
  final DateTime date;
  final int correct;
  final int wrong;
  final int missed;

  const ScoreCardWidget({
    super.key,
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
