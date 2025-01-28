import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speedometer/speedometer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _lowerValue = 20.0;
  final double _upperValue = 40.0;
  int start = 0;
  int end = 60;

  int counter = 0;

  Duration _animationDuration = const Duration(milliseconds: 100);

  PublishSubject<double> eventObservable = PublishSubject();
  @override
  void initState() {
    super.initState();
    const click = Duration(milliseconds: 500);
    var rng = Random();
    Timer.periodic(click, (Timer t) => eventObservable.add(rng.nextInt(59) + rng.nextDouble()));
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    ThemeData somTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Colors.blue,
        secondary: Colors.black,
        surface: Colors.grey,
      ),
    );
    var speedOMeter = SpeedOMeter(
      start: start,
      end: end,
      highlightStart: (_lowerValue / end),
      highlightEnd: (_upperValue / end),
      themeData: somTheme,
      eventObservable: eventObservable,
      animationDuration: _animationDuration,
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("SpeedOMeter"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(width: 200,height: 200,child: speedOMeter,),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _animationDuration += const Duration(milliseconds: 100);
                });
              },
              child: const Text('Slower...'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _animationDuration -= const Duration(milliseconds: 100);
                });
              },
              child: const Text('Faster!'),
            ),
          ],
        ));
  }
}
