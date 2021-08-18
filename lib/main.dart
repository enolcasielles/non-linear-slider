import 'package:flutter/material.dart';
import 'package:slider_variable_interval/variable_interval_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VariableIntervalSlider(
              intervals: [
                SliderInterval(0, 10, 1),
                SliderInterval(10, 40, 3),
                SliderInterval(40, 80, 4),
              ],
              divisions: 30,
              onChanged: (sliderValue) {
                setState(() {
                  value = sliderValue;
                });
              },
            ),
            Text('$value'),
          ],
        ),
      ),
    );
  }
}
