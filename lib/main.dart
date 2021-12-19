import 'package:ecg_helpdesk/screens/navigation_screen.dart';
import 'package:ecg_helpdesk/util/authenticate.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val ?? false;
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECG Helpdesk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn ? NavigationScreen(0) : Authenticate(),
    );
  }
}