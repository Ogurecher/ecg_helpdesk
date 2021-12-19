import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/channel_tickets_tile.dart';
import 'package:flutter/material.dart';

class MyTickets extends StatefulWidget {
  final int currentNavigationIndex = 2;
  const MyTickets({ Key? key }) : super(key: key);

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {

  QuerySnapshot? myTicketsSnapshot;

  snapshotTickets() async {
    String? userId = await HelperFunctions.getUserIdSharedPreference();
    DatabaseMethods.getUserTickets(userId!).then((value) {
      setState(()  {
        myTicketsSnapshot = value;
      });
    });
  }

  Widget myTicketsList() {
    return myTicketsSnapshot == null ? ListView() : ListView.builder(
      shrinkWrap: true,
      itemCount: myTicketsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return channelTicketsTile(context, myTicketsSnapshot!.docs[index], widget.currentNavigationIndex);
      }
    );
  }

  @override
  void initState() {
    snapshotTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets")),
      body: Container(
        child: myTicketsList()
      ),
    );
  }
}
