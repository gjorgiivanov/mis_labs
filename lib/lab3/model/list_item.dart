import 'package:flutter/material.dart';

class ListItem {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;

  ListItem(
      {required this.id,
      required this.name,
      required this.date,
      required this.time});
}
