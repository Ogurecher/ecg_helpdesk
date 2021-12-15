import 'package:flutter/material.dart';

class MyTickets extends StatefulWidget {
  final int currentNavigationIndex = 2;
  const MyTickets({ Key? key }) : super(key: key);

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets")),
      body: Container(),
    );
  }
}
