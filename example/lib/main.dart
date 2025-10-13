import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Architect CLI Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.architecture, size: 64, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Flutter Architect CLI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Run in terminal:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'flutter_architect create my_app',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  backgroundColor: Colors.black12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}