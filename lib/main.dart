import 'package:buttons/custom_loading_button.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Button'),
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
  ButtonState _buttonState = ButtonState.defaultState;

  void _simulateApiCall() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });

    // Simulate a network request delay
    await Future.delayed(const Duration(seconds: 3));

    // Simulate an API response
    setState(() {
      _buttonState = ButtonState.completed;
    });
  }

  void _disableButton() {
    setState(() {
      _buttonState = ButtonState.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            CustomLoadingButton(
              state: _buttonState,
              initialText: 'Submit',
              loadingText: "Loading...",
              borderColor: Colors.white,
              backgroundColor: const Color(0xff151515),
              borderRadius: 5,
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              onTap: () {
                _simulateApiCall();
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomLoadingButton(
              state: _buttonState,
              initialText: 'Login',
              loadingText: "Loading",
              borderColor: Colors.pink,
              backgroundColor: const Color(0xffececec),
              borderRadius: 15,
              textStyle: const TextStyle(color: Colors.black, fontSize: 16),
              onTap: () {
                _simulateApiCall();
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomLoadingButton(
              state: _buttonState,
              initialText: 'Buy now',
              loadingText: "Loading...",
              borderColor: Colors.yellowAccent,
              backgroundColor: const Color(0xff151515),
              borderRadius: 30,
              textStyle:
                  const TextStyle(color: Colors.yellowAccent, fontSize: 16),
              onTap: () {
                _simulateApiCall();
              },
            ),
            const Spacer(
              flex: 1,
            ),
            Container(
                width: double.infinity,
                color: Colors.white,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _buttonState = ButtonState.defaultState;
                      });
                    },
                    child: const Text("Reset")))
          ],
        ),
      ),
    );
  }
}
