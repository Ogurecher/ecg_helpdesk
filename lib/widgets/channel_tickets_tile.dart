import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/ticket_messages.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:flutter/material.dart';

Widget channelTicketsTile(BuildContext context, QueryDocumentSnapshot ticket, int currentNavigationIndex, {bool isSubscribed = false}) {
  return Container(
    child: Row(
      children: [
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TicketMessages(ticket, currentNavigationIndex)));
            },
            child: Text(ticket.get('name'))
          ),
        ),
        Spacer(),
        AssignButton(ticket)
      ],
    ),
  );
}

class AssignButton extends StatefulWidget {
  final QueryDocumentSnapshot ticket;
  const AssignButton(this.ticket, { Key? key }) : super(key: key);

  @override
  _AssignButtonState createState() => _AssignButtonState();
}

class _AssignButtonState extends State<AssignButton> {

  bool assignedToTicket = false;

  updateTicketAssignment() {
    setState(() {
      assignedToTicket = !assignedToTicket;
    });
  }

  @override
  void initState() {
    setState(() {
      assignedToTicket = widget.ticket.get('assigneeId') == userIdMock;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return assignedToTicket == false ? 
      TextButton(
        onPressed: () {
          DatabaseMethods.assignTicket(widget.ticket.id, userIdMock);
          updateTicketAssignment();
        },
        child: const Icon(Icons.contact_page)
      ) :
      TextButton(
        onPressed: () {
          DatabaseMethods.unassignTicket(widget.ticket.id, userIdMock);
          updateTicketAssignment();
        },
        child: const Icon(Icons.restore_page)
      );
  }
}
