import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  late Map<DateTime, List<String>> events;
  DateTime pickedDate;

  CalendarScreen(this.events, this.pickedDate);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.pickedDate;
    _focusedDay = widget.pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: TableCalendar(
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            if (widget.events.containsKey(selectedDay)) {
              showDialog(
                context: context,
                builder: (context) => CustomPopup(widget.events[selectedDay]!),
              );
            }
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return widget.events[day] ?? [];
          },
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarStyle: CalendarStyle(
            cellMargin: const EdgeInsets.all(1),
            markerDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            markerMargin: const EdgeInsets.symmetric(horizontal: 2.0),
            markerSizeScale: 0.15,
            todayDecoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${events.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class CustomPopup extends StatelessWidget {
  final List<String> events;

  const CustomPopup(this.events, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Events'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: events.map((e) => Text(e)).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
