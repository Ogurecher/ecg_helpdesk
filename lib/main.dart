import 'package:firebase_core/firebase_core.dart';
import 'package:ecg_helpdesk/screens/channel_search.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Helpdesk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChannelSearch(),
    );
  }
}
