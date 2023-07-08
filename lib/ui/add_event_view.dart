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
      List<Event> events = [];
      if (isFirstDayChecked) {
        final firstDayEvent = createEvent(const Duration(days: 1));
        events.add(firstDayEvent);
      }

      if (isThirdDayChecked) {
        final thirdDayEvent = createEvent(const Duration(days: 3));
        events.add(thirdDayEvent);
      }

      if (isSeventhDayChecked) {
        final seventhDayEvent = createEvent(const Duration(days: 7));
        events.add(seventhDayEvent);
      }

      if (isFifteenthDayChecked) {
        final fifteenthDayEvent = createEvent(const Duration(days: 15));
        events.add(fifteenthDayEvent);
      }

      if (isThirtythDayChecked) {
        final thirtythDayEvent = createEvent(const Duration(days: 30));
        events.add(thirtythDayEvent);
      }

      widget.eventRepository.insertEventLog(EventGroup(events));
      Navigator.pop(context);
    }
  }

  Event createEvent(Duration duration) {
    return Event()
      ..date = _selectedDate.add(duration)
      ..descriptions = splitStringByNewLine(_description)
          .map((e) => Description()
            ..description = e
            ..isReviewed = false)
          .toList();
  }

  List<String> splitStringByNewLine(String text) {
    return text.split('\n');
  }
}
