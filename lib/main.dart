import 'package:flutter/material.dart';
import 'package:slider_variable_interval/models/interval.dart' as nls;
import 'package:slider_variable_interval/widgets/non_linear_slider.dart';

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
  double value = 3000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NonLinearSlider(
                intervals: [
                  nls.Interval(10, 100, 0.25),
                  nls.Interval(100, 1000, 0.5),
                  nls.Interval(1000, 10000, 0.25),
                ],
                value: value,
                onChanged: (value) {
                  this.value = value;
                  setState(() {});
                },
                label: value.round().toString(),
                divisions: 100,
              ),
              Text(value.round().toString())
            ],
          ),
        ),
      ),
    );
  }
}
