import 'package:flutter/material.dart';

class ExamTimetable extends StatefulWidget {
  const ExamTimetable({Key? key}) : super(key: key);

  @override
  State<ExamTimetable> createState() => _ExamTimetableState();
}

class _ExamTimetableState extends State<ExamTimetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00008B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Implement your refresh functionality here
            },
          ),
        ],
        title: Text(
          'EXAM TIMETABLE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF00008B),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            // Replace n with the number of cards you want
            10,
                (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00008B),// Indigo color
                                ),
                                padding: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/subject.png',
                                  width: 26,
                                  height: 26,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Subject: Mathematics',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00008B),// Indigo color
                                ),
                                padding: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/date.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Date: 01/01/2024',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00008B),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/time.png',
                                  width: 26,
                                  height: 26,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Time: 9:00 AM - 12:00 PM',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExamTimetable(),
  ));
}
