import 'package:flutter/material.dart';
import 'package:mis_labs/lab2/answer.dart';
import 'package:mis_labs/lab2/question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> _questions;
  final int _index;
  final Function() _nextQuestion;

  Quiz(this._questions, this._index, this._nextQuestion);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Question(_questions[_index]['question'] as String),
        ...(_questions[_index]['answer'] as List<String>)
            .map((answer) => Answer(answer, _nextQuestion))
      ],
    );
  }
}
