import 'package:flutter/material.dart';

class AddEventView extends StatefulWidget {
  @override
  _AddEventViewState createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();

  bool isFirstDayChecked = false;
  bool isSecondDayChecked = false;
  bool isSeventhDayChecked = false;
  bool isFifteenthDayChecked = false;
  bool isThirtythDayChecked = false;

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
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
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
                title: Text('2nd Day'),
                value: isSecondDayChecked,
                onChanged: (value) {
                  setState(() {
                    isSecondDayChecked = value ?? false;
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
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      (isFirstDayChecked ||
                          isSecondDayChecked ||
                          isSeventhDayChecked ||
                          isFifteenthDayChecked ||
                          isThirtythDayChecked)) {
                    // Form is valid and at least one checkbox is checked
                    // TODO: Implement form submission
                  }
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
}
