import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/screens/channel_tickets.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:flutter/material.dart';

Widget channelTile(BuildContext context, QueryDocumentSnapshot channel, int currentNavigationIndex, {bool isSubscribed = false}) {
  Icon notificationIcon = Icon(isSubscribed ? Icons.notifications_on : Icons.notifications_off);

  return ListTile(
    title: Text(channel.get('name'), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),),
    trailing: SubscribeButton(channel, isSubscribed),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelTickets(channel, currentNavigationIndex)));
    },
    contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
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
        onPressed: () async {
          String? userId = await HelperFunctions.getUserIdSharedPreference();
          await DatabaseMethods.subscribeUserToChannel(widget.channel.id, userId!);
          updateChannelSubscription();
        },
        child: const Icon(Icons.notifications_off)
      ) :
      TextButton(
        onPressed: () async {
          String? userId = await HelperFunctions.getUserIdSharedPreference();
          await DatabaseMethods.unsubscribeUserFromChannel(widget.channel.id, userId!);
          updateChannelSubscription();
        },
        child: const Icon(Icons.notifications_on)
      );
  }
}
