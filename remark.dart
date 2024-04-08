import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Remark(),
  ));
}

class Remark extends StatefulWidget {
  @override
  _RemarkState createState() => _RemarkState();
}

class _RemarkState extends State<Remark> {
  List<Map<String, dynamic>> cardData = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Reset error message
    });

    try {
      final response = await http.get(Uri.parse('https://staging.smartschoolplus.co.in/Webservice/SSPMobileService.asmx/ViewRemark?SchoolCode=TESTLAKE&RStudentId=3414&RDate=17/02/2024'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Json Data: $jsonData');
        if (jsonData is List<dynamic>) {
          setState(() {
            cardData = jsonData.cast<Map<String, dynamic>>();
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = 'Failed to fetch data. Please check your internet connection and try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


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
            onPressed: fetchData,
          ),
        ],
        title: Text(
          'REMARKS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF00008B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: isLoading
                ? [Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))]
                : errorMessage.isNotEmpty
                ? [Center(child: Text(errorMessage, style: TextStyle(color: Colors.white)))]
                : cardData.isEmpty
                ? [Center(child: Text('No data available', style: TextStyle(color: Colors.white)))]
                : cardData.map((data) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildField('Date:', 'assets/images/date.png', data['DATE'] ?? ''),
                      _buildField('Time:', 'assets/images/time.png', data['TIME'] ?? ''),
                      _buildField('Remark:', 'assets/images/remark.png', data['REMARK'] ?? ''),
                      _buildField('Staff:', 'assets/images/staff.png', data['STAFF'] ?? ''),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String labelText, String iconPath, dynamic fieldValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF00008B), width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              labelText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildFieldValue(fieldValue),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFieldValue(dynamic fieldValue) {
    if (fieldValue is String) {
      return Text(
        fieldValue,
        style: TextStyle(fontSize: 16),
      );
    } else if (fieldValue is List<String>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fieldValue
            .map((subField) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            subField ?? '',
            style: TextStyle(fontSize: 16),
          ),
        ))
            .toList(),
      );
    } else {
      return Text(
        fieldValue != null ? fieldValue.toString() : '',
        style: TextStyle(fontSize: 16),
      );
    }
  }
}
