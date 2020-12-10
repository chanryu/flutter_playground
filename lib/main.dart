import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Playground',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Playground"),
      ),
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('things').get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong :(');
            }

            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            return Text('All good!');
          },
        ),
      ),
    );
  }
}
