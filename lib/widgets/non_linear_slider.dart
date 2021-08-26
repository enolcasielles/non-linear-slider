import 'package:flutter/material.dart';
import 'package:slider_variable_interval/models/interval.dart' as nls;

class NonLinearSlider extends StatelessWidget {
  final List<nls.Interval> sliderIntervals = [];

  final List<nls.Interval> consumerIntervals;
  final Function(double) onChanged;
  final double value;
  final int? divisions;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double? initialValue;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;

  NonLinearSlider({
    Key? key,
    required List<nls.Interval> intervals,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.initialValue,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false, 
    this.divisions,
  })  : consumerIntervals = intervals,
        super(key: key) {
    _checkIntervals();
    _setIntervals();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _consumerToSlider(value),
      onChanged: (double sliderValue) {
        onChanged(_sliderToConsumer(sliderValue));
      },
      min: 0,
      max: 100,
      divisions: divisions,
      onChangeEnd: onChangeEnd,
      onChangeStart: onChangeStart,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      mouseCursor: mouseCursor,
      semanticFormatterCallback: semanticFormatterCallback,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  void _setIntervals() {
    int i = 0;
    for (final nls.Interval interval in consumerIntervals) {
      double min = i == 0 ? 0 : sliderIntervals.last.max;
      double max = min + interval.weight * 100;
      sliderIntervals.add(nls.Interval(min, max, interval.weight));
      i++;
    }
  }

  void _checkIntervals() {
    double totalValue = 0;
    for(int i=0 ; i<consumerIntervals.length ; i++) {
      final nls.Interval interval = consumerIntervals[i];
      totalValue += interval.weight;
      assert(interval.min <= interval.max, 'El mínimo de un intervalo tiene que ser menor que el máximo');
      if(i == 0) 
        continue;
      if(consumerIntervals.length > 1) 
        assert(interval.min == consumerIntervals[i-1].max, 'El minimo de un intervalo tiene que ser igual la maximo del anterior');
    }
    assert(totalValue.round() == 1, 'La suma de los porcentajes que ocupa cada intervalo ha de ser igual a 1');
  }

  double _sliderToConsumer(double sliderValue) {
    double val = consumerIntervals.first.min;
    int i = 0;
    for (final nls.Interval interval in sliderIntervals) {
      nls.Interval consumerInterval = consumerIntervals[i];
      if (interval.max < sliderValue)
        val = consumerInterval.max;
      else {
        val += (sliderValue - interval.min) *
            ((consumerInterval.max - consumerInterval.min) /
                (interval.max - interval.min));
        break;
      }
      i++;
    }
    return val;
  }

  double _consumerToSlider(double consumerValue) {
    late nls.Interval ci, si;
    int index = 0;
    for (final nls.Interval interval in consumerIntervals) {
      if (interval.max < consumerValue) {
        index++;
        continue;
      }
      ci = interval;
      si = sliderIntervals[index];
      break;
    }
    return si.min +
        (consumerValue - ci.min) * ((si.max - si.min) / (ci.max - ci.min));
  }
}
