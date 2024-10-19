import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Map<String, String>> _flashcards = [
    {'question': 'What is Flutter?', 'answer': 'A UI toolkit for building natively compiled applications.'},
    {'question': 'What is Dart?', 'answer': 'A programming language optimized for building user interfaces.'},
  ];

  int _currentIndex = 0;

  void _nextFlashcard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
    });
  }

  void _previousFlashcard() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _flashcards.length) % _flashcards.length;
    });
  }

  void _shuffleFlashcards() {
    setState(() {
      _flashcards.shuffle(Random());
      _currentIndex = 0; // Reset to first card after shuffling
    });
  }

  void _resetProgress() {
    setState(() {
      _currentIndex = 0; // Reset to the first flashcard
    });
  }

  void _addFlashcard(String question, String answer) {
    setState(() {
      _flashcards.add({'question': question, 'answer': answer});
    });
  }

  void _showAddFlashcardDialog() {
    String newQuestion = '';
    String newAnswer = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Question'),
                onChanged: (value) {
                  newQuestion = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Answer'),
                onChanged: (value) {
                  newAnswer = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newQuestion.isNotEmpty && newAnswer.isNotEmpty) {
                  _addFlashcard(newQuestion, newAnswer);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flashcard ${_currentIndex + 1} of ${_flashcards.length}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Flashcard Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  _flashcards[_currentIndex]['question']!,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Answer'),
                    content: Text(_flashcards[_currentIndex]['answer']!),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Show Answer'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _previousFlashcard,
                  child: Icon(Icons.arrow_back),
                  tooltip: 'Previous Flashcard',
                ),
                FloatingActionButton(
                  onPressed: _shuffleFlashcards,
                  child: Icon(Icons.shuffle),
                  tooltip: 'Shuffle Flashcards',
                ),
                FloatingActionButton(
                  onPressed: _nextFlashcard,
                  child: Icon(Icons.arrow_forward),
                  tooltip: 'Next Flashcard',
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddFlashcardDialog,
              child: Text('Add New Flashcard'),
            ),
            ElevatedButton(
              onPressed: _resetProgress,
              child: Text('Reset Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
