import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliderInterval {
  final double min;
  final double max;
  final double value;

  SliderInterval(this.min, this.max, this.value,);
}

class VariableIntervalSlider extends StatefulWidget {

  final List<SliderInterval> intervals;
  final int divisions;
  final Function(double value) onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;

  VariableIntervalSlider({
    Key? key, 
    required this.intervals, 
    required this.divisions, 
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key) {
    _checkIntervals();
  }

  @override
  _VariableIntervalSliderState createState() => _VariableIntervalSliderState();

  void _checkIntervals() {
    for(int i=0 ; i<intervals.length ; i++) {
      final SliderInterval interval = intervals[i];
      assert(interval.min <= interval.max, 'El mínimo de un intervalo tiene que ser menor que el máximo');
      if(i == 0) 
        continue;
      if(intervals.length > 1) 
        assert(interval.min == intervals[i-1].max, 'El minimo de un intervalo tiene que ser igual la maximo del anterior');
    }
  }

}

class _VariableIntervalSliderState extends State<VariableIntervalSlider> {

  List<SliderInterval> sliderIntervals = [];

  double consumerValue = 0;
  double sliderValue = 0;

  _VariableIntervalSliderState();

  @override
  void initState() {
    _setSliderIntervals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: sliderValue, 
      min: sliderIntervals.first.min,
      max: sliderIntervals.last.max,
      onChanged: (value) {
        sliderValue = value;
        consumerValue = sliderToConsumer(sliderValue);
        print('Slider: $sliderValue'); 
        print('Consumer: $consumerValue');
        widget.onChanged(consumerValue);
        setState(() {});
      },
      divisions: widget.divisions,
      onChangeEnd: widget.onChangeEnd,
      onChangeStart: widget.onChangeStart,
      label: widget.label,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      mouseCursor: widget.mouseCursor,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }

  void _setSliderIntervals() {
    sliderIntervals = [];
    int i = 0;
    for(final SliderInterval interval in widget.intervals) {
      double min = i == 0 ? widget.intervals.first.min : sliderIntervals.last.max;
      double max = min + (interval.max - interval.min) / interval.value;
      sliderIntervals.add(SliderInterval(min, max, 1));
      i++;
    }
    consumerValue = widget.intervals.first.min;
    sliderValue = sliderIntervals.first.min;
  }

  double sliderToConsumer(sliderValue) {
    double val = 0;
    int i = 0;
    for(final SliderInterval interval in sliderIntervals) {
      if(interval.max < sliderValue) 
        val += (interval.max - interval.min) * widget.intervals[i].value;
      else {
        val += (sliderValue - interval.min) * widget.intervals[i].value;
        break;
      }
      i++;
    }
    return val;
  }

}