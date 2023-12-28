import 'package:flutter/material.dart';
import 'package:flutter_intasend/flutter_intasend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FlutterIntasend.initCheckOut(
              context: context,
              isTest: true,
              publicKey: "ISPubKey_test_7fc9eb9b-66dc-47b3-af11-6b51502b6075",
              currency: Currency.kes,
              amount: 15,
            );
          },
          child: const Text("Complete Payment"),
        ),
      ),
    );
  }
}
