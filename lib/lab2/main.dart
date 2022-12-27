import 'package:flutter/material.dart';
import 'package:mis_labs/lab2/done.dart';
import 'package:mis_labs/lab2/quiz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratory exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Clothes Chooser'),
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
  final _questions = [
    {
      'question': 'Select accessory:',
      'answer': ['Belt', 'Hat', 'Jewelry', 'Scarf', 'Eye-wear', 'Bag']
    },
    {
      'question': 'Select top clothes:',
      'answer': ['Hoodie', 'T-shirt', 'Shirt', 'Sweater']
    },
    {
      'question': 'Select top clothes color:',
      'answer': ['White', 'Black', 'Gray', 'Red', 'Green', 'Blue']
    },
    {
      'question': 'Select bottom clothes:',
      'answer': [
        'Corduroy Trousers',
        'Wool Trousers',
        'Jeans',
        'Cargo Pants',
        'Linen Trousers',
        'Slimline Joggers'
      ]
    },
    {
      'question': 'Select bottom color:',
      'answer': ['White', 'Black', 'Gray', 'Red', 'Green', 'Blue']
    },
    {
      'question': 'Select shoes:',
      'answer': [
        'Sneakers',
        'Calf boots',
        'Crocs',
        'Oxfords',
        'Huaraches',
        'Riding boots',
        'Slippers'
      ]
    },
    {
      'question': 'Select shoes color:',
      'answer': ['White', 'Black', 'Gray', 'Red', 'Green', 'Blue']
    }
  ];

  int _questionIndex = 0;

  void _nextQuestion() {
    setState(() {
      _questionIndex += 1;
    });
  }

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _questionIndex < _questions.length
          ? Quiz(_questions, _questionIndex, _nextQuestion)
          : DoneScreen(_restartQuiz),
    );
  }
}
