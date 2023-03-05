import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mis_labs/lab5/model/list_item.dart';
import 'package:mis_labs/lab5/model/location.dart';
import 'package:mis_labs/lab5/screen/map_screen.dart';
import 'package:mis_labs/lab5/widget/new_list_element.dart';

import '../service/notification_service.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final Map<DateTime, List<String>> _calendarMap = {
    DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day):
        ['Мобилни информациски системи', 'Веб базирани системи'],
  };

  final List<ListItem> _items = [
    ListItem(
      id: "0",
      name: "Мобилни информациски системи",
      date: DateTime.now(),
      time: TimeOfDay.now(),
      location:
          Location(latitude: 41.43782472791181, longitude: 22.640611996137377),
    ),
    ListItem(
      id: "1",
      name: "Веб базирани системи",
      date: DateTime.now(),
      time: TimeOfDay.now(),
      location:
          Location(latitude: 41.43782472791181, longitude: 22.640611996137377),
    ),
  ];

  void _showModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: CreateNewElement(_addNewItem),
          );
        });
  }

  Future<void> _addNewItem(ListItem item) async {
    setState(
      () {
        _items.add(item);
        DateTime dateTimeUTC =
            DateTime.utc(item.date.year, item.date.month, item.date.day);

        if (_calendarMap[dateTimeUTC] == null ||
            _calendarMap[dateTimeUTC]!.isEmpty) {
          _calendarMap[dateTimeUTC] = [item.name];
        } else {
          _calendarMap[dateTimeUTC]?.add(item.name);
        }
      },
    );

    final date = item.date;
    final time = item.time;
    DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute, 0);
    Duration difference = dateTime.difference(DateTime.now()).abs();
    int seconds = difference.inSeconds.abs();

    await service.scheduleNotification(
        id: UniqueKey().hashCode,
        title: 'You have upcoming exam: ${item.name}',
        body: 'Check your calendar',
        seconds: seconds);
  }

  void _deleteItem(String id) {
    setState(() {
      var item = _items.firstWhere((element) => element.id == id);
      var keyDate =
          DateTime.utc(item.date.year, item.date.month, item.date.day);
      _items.removeWhere((item) => item.id == id);
      _calendarMap.removeWhere((key, value) {
        if (key == keyDate && value.length == 1) {
          return true;
        } else if (key == keyDate && value.length > 1) {
          _calendarMap[key]?.remove(item.name);
        }
        return false;
      });
    });
  }

  Future _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Испитни термини'),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.add_box_outlined,
            size: 30,
          ),
          onPressed: () => _showModal(context),
        ),
        IconButton(
          icon: const Icon(
            Icons.calendar_month_outlined,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CalendarScreen(_calendarMap, DateTime.now()),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.map_outlined,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(_items),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            size: 30,
          ),
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _createBody(BuildContext context) {
    return Container(
      child: _items.isEmpty
          ? const Center(
              child: Text("Нема закажени испити"),
            )
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: ListTile(
                    tileColor: Colors.blue.shade100,
                    title: Text(
                      _items[index].name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${DateFormat.yMMMd().format(_items[index].date)} at ${_items[index].time.format(context)}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: IconButton(
                        onPressed: () => _deleteItem(_items[index].id),
                        icon: const Icon(Icons.delete)),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(context),
    );
  }
}
