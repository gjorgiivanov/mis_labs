import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';

import '../model/list_item.dart';
import '../model/location.dart';
import 'location_input.dart';

class CreateNewElement extends StatefulWidget {
  final Function addNewItem;

  const CreateNewElement(this.addNewItem, {super.key});

  @override
  State<StatefulWidget> createState() => _CreateNewElementState();
}

class _CreateNewElementState extends State<CreateNewElement> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Location? _pickedLocation;

  void _selectPlace(double lat, double lng) {
    _pickedLocation = Location(latitude: lat, longitude: lng);
  }

  void _submitData() {
    if (_nameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _pickedLocation == null) {
      return;
    }

    final newItem = ListItem(
      id: nanoid(10),
      name: _nameController.text,
      date: _selectedDate!,
      time: _selectedTime!,
      location: _pickedLocation!,
    );

    widget.addNewItem(newItem);
    Navigator.of(context).pop();
  }

  void _presentCalendar() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2023, 12))
        .then((selected) {
      if (selected == null) {
        return;
      }
      setState(() {
        _selectedDate = selected;
      });
    });
  }

  void _presentTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((selected) {
      if (selected == null) {
        return;
      }
      setState(() {
        _selectedTime = selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextField(
                  decoration: const InputDecoration(labelText: "Subject Name"),
                  controller: _nameController,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date Chosen'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}'),
                  ),
                  TextButton(
                    onPressed: _presentCalendar,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedTime == null
                        ? 'No Time Chosen'
                        : 'Picked Time: ${_selectedTime!.format(context)}'),
                  ),
                  TextButton(
                    onPressed: _presentTime,
                    child: const Text('Choose Time'),
                  ),
                ],
              ),
              LocationInput(_selectPlace),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ],
          )),
    );
  }
}
