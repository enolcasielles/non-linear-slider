# non_linear_slider
A Flutter package that provides a Non Linear Slider Widget. This is a custom
Slider that works equal than the native one but instead of defining only a `min` and
a `max` value, user will be able to define as many intervals as it wants. This way slider
will have zones where its value increase/decrease quicker or slower than others.

## Example
The next example shows a Non Linear Slider where 3 intervals have been defined. 

- First interval goes from 10 to 100 taking a 25% of the slider.
- Second interval goes from 100 to 1000 and takes the next 50%.
- Last interval goes from 1000 to 10000.

[example](https://github.com/enolcasielles/non-linear-slider/blob/master/example.gif)

## Usage
Using this Widget is pretty easy. You can pass any parameter you would pass to 
`Slider` with only one exception. Instead of passing a `min` and a `max` values 
you should pass a `List` of `NLSInterval`, representing every interval you want to 
define (the package also implements this `NLSInterval` class). Each interval has a 
`min`, a `max` and a `weight`. The `weight` parameter represents the percent you 
want this interval takes on the slider. The sum of the weights should be equal to 1.

``` dart
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
                  NLSInterval(10, 100, 0.25),
                  NLSInterval(100, 1000, 0.5),
                  NLSInterval(1000, 10000, 0.25),
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
```

