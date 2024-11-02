import 'package:flutter/material.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/presentation/bloc/event_bloc.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final EventBloc eventBloc;

  const AddEventPage({
    Key? key,
    required this.eventBloc,
  }) : super(key: key);

  @override
  AddEventPageState createState() => AddEventPageState();
}

class AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  DateFormat dateFomat = DateFormat("d MMMM y");

  String _description = '';
  bool isFirstDayChecked = true;
  bool isThirdDayChecked = true;
  bool isSeventhDayChecked = true;
  bool isFifteenthDayChecked = true;
  bool isThirtythDayChecked = true;

  void onSave() {
    if (_formKey.currentState!.validate() &&
        (isFirstDayChecked ||
            isThirdDayChecked ||
            isSeventhDayChecked ||
            isFifteenthDayChecked ||
            isThirtythDayChecked)) {
      _formKey.currentState!.save();
      List<EventEntity> events = [];

      void addEvent(Duration duration) {
        final descriptions = _description
            .split('\n')
            .map((e) => DescriptionEntity(
                  description: e,
                  isReviewed: false,
                ))
            .toList();

        events.add(EventEntity(
          date: _selectedDate.add(duration),
          descriptions: descriptions,
        ));
      }

      if (isFirstDayChecked) addEvent(const Duration(days: 1));
      if (isThirdDayChecked) addEvent(const Duration(days: 3));
      if (isSeventhDayChecked) addEvent(const Duration(days: 7));
      if (isFifteenthDayChecked) addEvent(const Duration(days: 15));
      if (isThirtythDayChecked) addEvent(const Duration(days: 30));

      widget.eventBloc.add(AddNewEvent(
        EventGroupEntity(id: 0, events: events),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2050),
                    );
                    if (picked != null && picked != _selectedDate) {
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
              const SizedBox(height: 16.0),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('1st Day'),
                value: isFirstDayChecked,
                onChanged: (value) {
                  setState(() {
                    isFirstDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('3rd Day'),
                value: isThirdDayChecked,
                onChanged: (value) {
                  setState(() {
                    isThirdDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('7th Day'),
                value: isSeventhDayChecked,
                onChanged: (value) {
                  setState(() {
                    isSeventhDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('15th Day'),
                value: isFifteenthDayChecked,
                onChanged: (value) {
                  setState(() {
                    isFifteenthDayChecked = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('30th Day'),
                value: isThirtythDayChecked,
                onChanged: (value) {
                  setState(() {
                    isThirtythDayChecked = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                // move onpressed to a separate function
                onPressed: () async {
                  onSave();
                },
                child: const Text('Add Event'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
