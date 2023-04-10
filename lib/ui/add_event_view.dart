import 'package:flutter/material.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/di/service_locator.dart';

class AddEventView extends StatefulWidget {
  final eventRepository = ServiceLocator.instance.get<EventRepository>();
  AddEventView({Key? key}) : super(key: key);
  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  DateFormat dateFomat = DateFormat("d MMMM y");

  String _description = '';
  bool isFirstDayChecked = true;
  bool isThirdDayChecked = true;
  bool isSeventhDayChecked = true;
  bool isFifteenthDayChecked = true;
  bool isThirtythDayChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2050),
                    );
                    if (picked != null && picked != _selectedDate) {
                      DateTime utcDate = picked.toUtc();
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: dateFomat.format(_selectedDate.toLocal())),
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Add Entry Here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('1st Day'),
                value: isFirstDayChecked,
                onChanged: (value) {
                  setState(() {
                    isFirstDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('3rd Day'),
                value: isThirdDayChecked,
                onChanged: (value) {
                  setState(() {
                    isThirdDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('7th Day'),
                value: isSeventhDayChecked,
                onChanged: (value) {
                  setState(() {
                    isSeventhDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('15th Day'),
                value: isFifteenthDayChecked,
                onChanged: (value) {
                  setState(() {
                    isFifteenthDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('30th Day'),
                value: isThirtythDayChecked,
                onChanged: (value) {
                  setState(() {
                    isThirtythDayChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                // move onpressed to a separate function
                onPressed: () async {
                  onSave();
                },
                child: Text('Add Event'),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void onSave() async {
    if (_formKey.currentState!.validate() &&
        (isFirstDayChecked ||
            isThirdDayChecked ||
            isSeventhDayChecked ||
            isFifteenthDayChecked ||
            isThirtythDayChecked)) {
      _formKey.currentState!.save();
      final eventLog = await widget.eventRepository.insertEventLog();
      final eventId = eventLog!.id;
      if (isFirstDayChecked) {
        final firstDayEvent = Event(
            _description, _selectedDate.add(const Duration(days: 1)), false);
        firstDayEvent.eventLog.value = eventLog;
        widget.eventRepository.insertEvent(firstDayEvent, eventLog);
        widget.eventRepository.updateEventLog(eventId, firstDayEvent);
      }

      if (isThirdDayChecked) {
        final thirdDayEvent = Event(
            _description, _selectedDate.add(const Duration(days: 3)), false);
        thirdDayEvent.eventLog.value = eventLog;
        widget.eventRepository.insertEvent(thirdDayEvent, eventLog);
        widget.eventRepository.updateEventLog(eventId, thirdDayEvent);
      }

      if (isSeventhDayChecked) {
        final seventhDayEvent = Event(
            _description, _selectedDate.add(const Duration(days: 7)), false);
        seventhDayEvent.eventLog.value = eventLog;
        widget.eventRepository.insertEvent(seventhDayEvent, eventLog);
        widget.eventRepository.updateEventLog(eventId, seventhDayEvent);
      }

      if (isFifteenthDayChecked) {
        final fifteenthDayEvent = Event(
            _description, _selectedDate.add(const Duration(days: 15)), false);
        fifteenthDayEvent.eventLog.value = eventLog;
        widget.eventRepository.insertEvent(fifteenthDayEvent, eventLog);
        widget.eventRepository.updateEventLog(eventId, fifteenthDayEvent);
      }

      if (isThirtythDayChecked) {
        final thirtythDayEvent = Event(
            _description, _selectedDate.add(const Duration(days: 30)), false);
        thirtythDayEvent.eventLog.value = eventLog;
        widget.eventRepository.insertEvent(thirtythDayEvent, eventLog);
        widget.eventRepository.updateEventLog(eventId, thirtythDayEvent);
      }

      Navigator.pop(context);
    }
  }
}
