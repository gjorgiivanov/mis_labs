import 'package:flutter/material.dart';
import 'package:mis_labs/lab5/model/location.dart';

class ListItem {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;
  final Location location;

  ListItem({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
  });
}
