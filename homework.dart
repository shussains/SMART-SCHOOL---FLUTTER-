import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class HomeWork {
  final String homeworkdate;
  final String subjectname;
  final String description;

  HomeWork({
    required this.homeworkdate,
    required this.subjectname,
    required this.description,
  });
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  List<HomeWork> homeWorkList = [];
  bool isLoading = false;
  String errorMessage = '';

  // Function to fetch homework data from the API
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://staging.smartschoolplus.co.in/Webservice/SSPMobileService.asmx/GetAllHomework?SchoolCode=TESTLAKE&ClassId=1&HomeworkDate='));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> homeWork = jsonData['HomeWork'];
        setState(() {
          homeWorkList = homeWork.map((item) {
            return HomeWork(
              homeworkdate: item['HOMEWORKDATE'],
              subjectname: item['SUBJECTNAME'],
              description: item['DESCRIPTION'],
            );
          }).toList();
          errorMessage = ''; // Reset error message
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch data. Please check your internet connection and try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to refresh data with a delay
  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1)); // Adding a delay of 2 seconds
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOMEWORKS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0, // Increase the font size
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00008B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              refreshData();
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF00008B),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Customize loading indicator color
        ),
      )
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),
      )
          : homeWorkList.isEmpty
          ? const Center(
        child: Text(
          'No homework found',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: homeWorkList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = homeWorkList[index];
          return Card(
            elevation: 8,
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0),
                  homeworkInfo('assets/images/calender.png', 'Homework Date: ${item.homeworkdate}'),
                  SizedBox(height: 15.0),
                  homeworkInfo('assets/images/date.png', 'Subject Name: ${item.subjectname}'),
                  SizedBox(height: 15.0),
                  homeworkInfo('assets/images/homework.png', 'Description: ${item.description}'),
                  SizedBox(height: 17.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget to display homework information with an icon
  Widget homeworkInfo(String imagePath, String text) {
    return Container(
      color: Color(0xFF00008B),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: [
           const SizedBox(width: 5.0),
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.asset(imagePath, width: 30, height: 30),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
