import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/event_repository.dart';

class EventView extends StatefulWidget {
  final EventRepository eventRepository;
  const EventView({required this.eventRepository, Key? key}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980, 1),
      lastDate: DateTime(2100, 12),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Text(
            'Revision List for ${DateFormat('d MMMM y').format(selectedDate)}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: widget.eventRepository.getEventsOnDate(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No events found.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = snapshot.data![index];
                    return ListTile(
                      title: Text(event.description),
                    );
                  },
                );
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('View Calendar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-entry', arguments: {
                    'reloadList': _reloadList,
                  });
                },
                child: Text('Add Entry'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _reloadList(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }
}
