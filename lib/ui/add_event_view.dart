import 'package:flutter/material.dart';
import 'package:learning_assistant/data/event.dart';
import 'package:learning_assistant/data/event_repository.dart';
import 'package:intl/intl.dart';

class AddEventView extends StatefulWidget {
  final EventRepository eventRepository;
  final Function onClose;
  const AddEventView(
      {required this.eventRepository, required this.onClose, Key? key})
      : super(key: key);
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
      if (isFirstDayChecked) {
        widget.eventRepository.insertEvent(
            Event(_description, _selectedDate.add(const Duration(days: 1))));
      }

      if (isThirdDayChecked) {
        widget.eventRepository.insertEvent(
            Event(_description, _selectedDate.add(const Duration(days: 3))));
      }

      if (isSeventhDayChecked) {
        widget.eventRepository.insertEvent(
            Event(_description, _selectedDate.add(const Duration(days: 7))));
      }

      if (isFifteenthDayChecked) {
        widget.eventRepository.insertEvent(
            Event(_description, _selectedDate.add(const Duration(days: 15))));
      }

      if (isThirtythDayChecked) {
        widget.eventRepository.insertEvent(
            Event(_description, _selectedDate.add(const Duration(days: 30))));
      }

      Navigator.pop(context);
      widget.onClose(_selectedDate);
    }
  }
}
