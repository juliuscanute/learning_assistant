import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:learning_assistant/di/service_locator.dart';
import 'package:learning_assistant/ui/event/list_item_card_view.dart';

class EventView extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<EventRepository>();
  EventView({Key? key}) : super(key: key);

  @override
  EventViewState createState() => EventViewState();
}

class EventViewState extends State<EventView> {
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
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Revision List for ${DateFormat('d MMMM y').format(selectedDate)}',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                  // Adjust the itemCount to account for the image
                  return ListView.builder(
                    itemCount: snapshot.data!.length + 1, // +1 for the image
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // Return the image widget at the first index
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            brightness == Brightness.light
                                ? 'assets/images/light/illustration_reminder.webp'
                                : 'assets/images/dark/illustration_reminder.webp',
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        // Adjust index by -1 to account for the image
                        final event = snapshot.data![index - 1];
                        return ListItemCard(
                          event: event,
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text('View Calendar'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-entry');
                    },
                    child: const Text('Add Entry'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
