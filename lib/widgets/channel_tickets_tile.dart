import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/ticket_messages.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:flutter/material.dart';

Widget channelTicketsTile(BuildContext context, QueryDocumentSnapshot ticket, int currentNavigationIndex) {
  DateTime dateCreated = ticket.get('dateCreated').toDate();
  String timeCreated = '${dateCreated.day.toString()}/${dateCreated.month.toString()}  ${dateCreated.hour.toString()}:${dateCreated.minute.toString()}';

  return ListTile(
    title: Text(ticket.get('name'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),),
    subtitle: Text('${timeCreated}  ${ticket.get('status')}'),
    trailing: AssignButton(ticket),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TicketMessages(ticket, currentNavigationIndex)));
    },
    contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
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
    HelperFunctions.getUserIdSharedPreference().then((userId) {
      setState(() {
        assignedToTicket = widget.ticket.get('assigneeId') == userId;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return assignedToTicket == false ? 
      TextButton(
        onPressed: () async {
          String? userId = await HelperFunctions.getUserIdSharedPreference();
          await DatabaseMethods.assignTicket(widget.ticket.id, userId!);
          updateTicketAssignment();
        },
        child: const Icon(Icons.contact_page)
      ) :
      TextButton(
        onPressed: () async {
          String? userId = await HelperFunctions.getUserIdSharedPreference();
          await DatabaseMethods.unassignTicket(widget.ticket.id, userId!);
          updateTicketAssignment();
        },
        child: const Icon(Icons.restore_page)
      );
  }
}
