import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class TicketMessages extends StatefulWidget {
  final QueryDocumentSnapshot ticket;
  final int currentNavigationIndex;
  
  const TicketMessages(this.ticket, this.currentNavigationIndex, { Key? key }) : super(key: key);

  @override
  _TicketMessagesState createState() => _TicketMessagesState();
}

class _TicketMessagesState extends State<TicketMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.ticket.get('name')} chat')),
      body: Container(),
      bottomNavigationBar: bottomNavigationBar(widget.currentNavigationIndex, context),
    );
  }
}
