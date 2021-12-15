import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/screens/channel_tickets.dart';
import 'package:flutter/material.dart';

Widget channelTile(BuildContext context, QueryDocumentSnapshot channel, int currentNavigationIndex, {bool isSubscribed = false}) {
  Icon notificationIcon = Icon(isSubscribed ? Icons.notifications_on : Icons.notifications_off);

  return Container(
    child: Row(
      children: [
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelTickets(channel, currentNavigationIndex)));
            },
            child: Text(channel.get('name'))
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: notificationIcon
        )
      ],
    ),
  );
}
