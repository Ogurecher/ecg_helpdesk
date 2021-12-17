import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:ecg_helpdesk/widgets/channel_tickets_tile.dart';
import 'package:ecg_helpdesk/widgets/create_floating_button.dart';
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

  final GlobalKey<FormState> _createTicketKey = GlobalKey<FormState>();
  final TextEditingController _createTicketNameFieldController = TextEditingController();

  snapshotOpenChannelTickets(String channelId) {
    DatabaseMethods.getUnassignedChannelTickets(channelId).then((value) {
      setState(()  {
        unassignedChannelTicketsSnapshot = value;
      });
    });
  }

  createTicket() {
    DatabaseMethods.addTicket(userIdMock, widget.channel.id, _createTicketNameFieldController.text);
    snapshotOpenChannelTickets(widget.channel.id);
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
      floatingActionButton: createFloatingButton(context, _createTicketKey, _createTicketNameFieldController, createTicket),
      body: Container(
        child: channelTicketsList(),
      ),
      bottomNavigationBar: bottomNavigationBar(widget.currentNavigationIndex, context),
    );
  }
}
