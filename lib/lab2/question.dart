import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String _question;

  const Question(this._question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        _question,
        style: const TextStyle(color: Colors.blue, fontSize: 28),
      ),
    );
  }
}
