// event_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';
import 'package:learning_assistant/presentation/widgets/list_item_card.dart';

class EventPage extends StatefulWidget {
  final EventBloc eventBloc;
  final EventDetailsBloc eventDetailsBloc;

  const EventPage(
      {Key? key, required this.eventBloc, required this.eventDetailsBloc})
      : super(key: key);

  @override
  EventPageState createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.eventBloc.add(GetEventsForDate(selectedDate));
  }

  Widget _buildImageWidget(Brightness brightness, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: Image.asset(
              brightness == Brightness.light
                  ? 'assets/images/light/illustration_reminder.webp'
                  : 'assets/images/dark/illustration_reminder.webp',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const Center(child: Text('No events found.'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          // Your other widgets here
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              bloc: widget.eventBloc,
              builder: (context, state) {
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is EventLoaded) {
                  final events = state.events;
                  int itemCount = events.length;

                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int index) {
                      if (events.isEmpty) {
                        // Return the image widget at the first index
                        return _buildImageWidget(brightness, context);
                      } else {
                        // Adjust index by -1 to account for the image
                        final event = events[index];
                        return ListItemCard(
                          event: event,
                          eventDetailsBloc: widget.eventDetailsBloc,
                        );
                      }
                    },
                  );
                } else {
                  return Center(child: Text('Unknown state: $state'));
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
        widget.eventBloc.add(GetEventsForDate(selectedDate));
      });
    }
  }
}
