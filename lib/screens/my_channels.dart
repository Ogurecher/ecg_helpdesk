import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/channel_tile.dart';
import 'package:flutter/material.dart';

class MyChannels extends StatefulWidget {
  final int currentNavigationIndex = 1;
  const MyChannels({ Key? key }) : super(key: key);

  @override
  _MyChannelsState createState() => _MyChannelsState();
}

class _MyChannelsState extends State<MyChannels> {

  QuerySnapshot? myChannelsSnapshot;

  snapshotChannels() {
    DatabaseMethods.getSubscribedChannels(userIdMock).then((value) {
      setState(()  {
        myChannelsSnapshot = value;
      });
    });
  }

  @override
  void initState() {
    snapshotChannels();
    super.initState();
  }

  Widget myChannelsList() {
    return myChannelsSnapshot == null ? ListView() : ListView.builder(
      shrinkWrap: true,
      itemCount: myChannelsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return channelTile(context, myChannelsSnapshot!.docs[index], widget.currentNavigationIndex);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Channels")),
      body: Container(
        child: myChannelsList(),
      ),
    );
  }
}
