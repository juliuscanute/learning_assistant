import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/list_item_card_view.dart';

class EventView extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<EventRepository>();
  EventView({Key? key}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.eventRepository.filterEventsOnDate(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980, 1),
      lastDate: DateTime(2100, 12),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.eventRepository.filterEventsOnDate(selectedDate);
      });
    }
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
          child: StreamBuilder<List<Event>>(
            stream: widget.eventRepository.events,
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
                    return ListItemCard(
                      id: event.id,
                      description: event.description,
                      isReviewed: event.isReviewed,
                      eventLog: event.eventLog.value!,
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
                  Navigator.pushNamed(context, '/create-entry');
                },
                child: Text('Add Entry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
