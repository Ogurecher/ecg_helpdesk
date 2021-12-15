import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:ecg_helpdesk/widgets/channel_tickets_tile.dart';
import 'package:flutter/material.dart';

class ChannelTickets extends StatefulWidget {
  final QueryDocumentSnapshot channel;
  final int currentNavigationIndex;
  
  const ChannelTickets(this.channel, this.currentNavigationIndex, { Key? key }) : super(key: key);

  @override
  _ChannelTicketsState createState() => _ChannelTicketsState();
}

class _ChannelTicketsState extends State<ChannelTickets> {

  QuerySnapshot? unassignedChannelTicketsSnapshot;

  snapshotOpenChannelTickets(String channelId) {
    DatabaseMethods.getUnassignedChannelTickets(channelId).then((value) {
      setState(()  {
        unassignedChannelTicketsSnapshot = value;
      });
    });
  }

  @override
  void initState() {
    snapshotOpenChannelTickets(widget.channel.id);
    super.initState();
  }

  Widget channelTicketsList() {
    return unassignedChannelTicketsSnapshot == null ? ListView() : ListView.builder(
      shrinkWrap: true,
      itemCount: unassignedChannelTicketsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return channelTicketsTile(context, unassignedChannelTicketsSnapshot!.docs[index], widget.currentNavigationIndex);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.channel.get('name')} tickets')),
      body: Container(
        child: channelTicketsList(),
      ),
      bottomNavigationBar: bottomNavigationBar(widget.currentNavigationIndex, context),
    );
  }
}
