import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/channel_tickets.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
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
        SubscribeButton(channel, isSubscribed)
      ],
    ),
  );
}

class SubscribeButton extends StatefulWidget {
  final QueryDocumentSnapshot channel;
  final bool subscribedToChannel;
  const SubscribeButton(this.channel, this.subscribedToChannel, { Key? key }) : super(key: key);

  @override
  _SubscribeButtonState createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {

  bool subscribedToChannel = false;

  updateChannelSubscription() {
    setState(() {
      subscribedToChannel = !subscribedToChannel;
    });
  }

  @override
  void initState() {
    setState(() {
      subscribedToChannel = widget.subscribedToChannel;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return subscribedToChannel == false ? 
      TextButton(
        onPressed: () {
          DatabaseMethods.subscribeUserToChannel(widget.channel.id, userIdMock);
          updateChannelSubscription();
        },
        child: const Icon(Icons.notifications_off)
      ) :
      TextButton(
        onPressed: () {
          DatabaseMethods.unsubscribeUserFromChannel(widget.channel.id, userIdMock);
          updateChannelSubscription();
        },
        child: const Icon(Icons.notifications_on)
      );
  }
}
