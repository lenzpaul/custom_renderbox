import 'package:custom_renderbox_mbo/circle_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: CircleLayout(
              radius: 150,
              children: List.generate(
                8,
                (index) => Container(
                  color: Colors.blue[100 * (index + 1)],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$index'),
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
