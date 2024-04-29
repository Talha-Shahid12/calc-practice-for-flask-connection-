import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdditionScreen extends StatefulWidget {
  @override
  _AdditionScreenState createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  TextEditingController number1Controller = TextEditingController();
  TextEditingController number2Controller = TextEditingController();
  String result = '';

  // Define your URL endpoint here
  final String url = 'http://10.0.2.2:5000/add';

  Future<void> sendNumbersAndAdd() async {
    final int? number1 = int.tryParse(number1Controller.text);
    final int? number2 = int.tryParse(number2Controller.text);

    if (number1 != null && number2 != null) {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'num1': number1, 'num2': number2}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        try {
          var responseData = jsonDecode(response.body);
          setState(() {
            result = responseData['result'].toString();
          });
        } catch (e) {
          setState(() {
            result = 'Error decoding response';
          });
        }
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addition'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: number1Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number 1'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: number2Controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number 2'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendNumbersAndAdd,
                child: Text('Add'),
              ),
              SizedBox(height: 20),
              Text(
                'Result: $result',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdditionScreen(),
  ));
}
