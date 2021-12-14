import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/widgets/channel_tile.dart';
import 'package:flutter/material.dart';

class ChannelSearch extends StatefulWidget {
  const ChannelSearch({ Key? key }) : super(key: key);

  @override
  _ChannelSearchState createState() => _ChannelSearchState();
}

class _ChannelSearchState extends State<ChannelSearch> {

  QuerySnapshot? allChannelsSnapshot;

  snapshotChannels() {
    DatabaseMethods.getChannels().then((value) {
      setState(()  {
        allChannelsSnapshot = value;
      });
    });
  }

  @override
  void initState() {
    snapshotChannels();
    super.initState();
  }

  Widget searchList() {
    return allChannelsSnapshot == null ? ListView() : ListView.builder(
      shrinkWrap: true,
      itemCount: allChannelsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return channelTile(allChannelsSnapshot!.docs[index].get('name'));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Channel Search")),
      body: Container(
        child: searchList(),
      ),
    );
  }
}
