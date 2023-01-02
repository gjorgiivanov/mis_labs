import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './model/list_item.dart';
import './widget/new_list_element.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratory exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Испитни термини'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> _items = [
    ListItem(
        id: "0",
        name: "Мобилни информациски системи",
        date: DateTime.now(),
        time: TimeOfDay.now()),
    ListItem(
        id: "1",
        name: "Веб базирани системи",
        date: DateTime.now(),
        time: TimeOfDay.now())
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

  void _addNewItem(ListItem item) {
    setState(() {
      _items.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add), onPressed: () => _showModal(context))
        ],
      ),
      body: Center(
          child: _items.isEmpty
              ? const Text("Нема закажени испити")
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 2,
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
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
                )),
    );
  }
}
