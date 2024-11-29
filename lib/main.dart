import 'package:flutter/material.dart';
import 'package:school_app/data/scrapper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ElevatedButton(
            onPressed: () async {
              await NeerajSchoolScrapper().fetchHomePage();
            },
            child: const Text('Fetch')),
      ),
    );
  }
}
