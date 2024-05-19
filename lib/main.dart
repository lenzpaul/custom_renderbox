import 'package:custom_renderbox_mbo/circle_layout_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: MainApp()));

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /// The radius of the circle layout around which the children will be placed.
  static const _radius = 150.0;
  static const _maxNumChildren = 20;

  /// The number of children to display around the circle.
  int numChildren = 0;

  // The size of the children. If not provided, the children will be allowed to
  // size themselves based on their content.
  // double? _childrenSize = null;
  double? _childrenSize = _radius * .5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleLayout(
              radius: _radius,
              childrenSize:
                  _childrenSize != null ? Size.square(_childrenSize!) : null,
              children: List.generate(
                numChildren,
                (index) => ChildWidget(index),
              ),
            ),

            const SizedBox(height: 100),

            // Slider to change the size of the children
            if (_childrenSize != null)
              FractionallySizedBox(
                widthFactor: .5,
                child: Slider(
                  value: _childrenSize!,
                  min: _radius * .5,
                  max: _radius * 1.25,
                  onChanged: (value) {
                    setState(() => _childrenSize = value);
                  },
                ),
              ),

            const SizedBox(height: 50),

            // Plus and minus buttons to change the number of children
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numChildren > 0) {
                        numChildren--;
                      }
                    });
                  },
                ),
                Text(
                  '$numChildren',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (numChildren < _maxNumChildren) {
                        numChildren++;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays a number in a circle.
class ChildWidget extends StatelessWidget {
  final int index;

  const ChildWidget(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
