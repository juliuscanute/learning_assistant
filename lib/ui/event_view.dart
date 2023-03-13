import 'package:flutter/material.dart';

class EventView extends StatefulWidget {
  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021, 1),
      lastDate: DateTime(2030, 12),
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
            'My List',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 100, // Replace with the number of items in your list
            itemBuilder: (BuildContext context, int index) {
              // Replace with your list item widget
              return ListTile(
                title: Text('Item $index'),
              );
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
