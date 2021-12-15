import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/screens/ticket_messages.dart';
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
        TextButton(
          onPressed: () {},
          child: const Icon(Icons.contact_page)
        )
      ],
    ),
  );
}
