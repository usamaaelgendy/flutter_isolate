import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () async {
                log(complexTask().toString());
              },
              child: const Text("Without Isolate"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final ReceivePort receivePort = ReceivePort();
                await Isolate.spawn(isolateComplexTask, receivePort.sendPort);
                Isolate.run(() => isolateComplexTask);
                log(await receivePort.first);
              },
              child: const Text("With Isolate"),
            ),
          ],
        ),
      ),
    );
  }

  double complexTask() {
    double result = 1.0;
    for (int i = 0; i <= 1000000000; i++) {
      result += i;
    }
    return result;
  }
}

isolateComplexTask(SendPort sendPort) {
  double result = 1.0;
  for (int i = 0; i <= 1000000000; i++) {
    result += i;
  }
  sendPort.send(result);
}
