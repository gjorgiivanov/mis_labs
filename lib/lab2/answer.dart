import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String _answer;
  final void Function() _nextQuestion;

  const Answer(this._answer, this._nextQuestion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade300,
        ),
        child: Text(
          _answer,
          style: TextStyle(color: Colors.red.shade900, fontSize: 25),
        ),
      ),
    );
  }
}
