import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KindaCodeMain.com',
        theme: ThemeData(
          useMaterial3: true, // enable Material 3
          primarySwatch: Colors.blue,
        ),
        home: const KindaCodeDemo());
  }
}

class KindaCodeDemo extends StatelessWidget {
  const KindaCodeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KindaCode.com')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 80),
                    textStyle: const TextStyle(fontSize: 30)),
                child: const Text('Hi There')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 80)),
                child: const Text(
                  'Googbye',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Something')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    backgroundColor: Colors.indigo,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                label: const Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
