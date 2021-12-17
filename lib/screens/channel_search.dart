import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/channel_tile.dart';
import 'package:ecg_helpdesk/widgets/create_floating_button.dart';
import 'package:flutter/material.dart';

class ChannelSearch extends StatefulWidget {
  final int currentNavigationIndex = 0;
  const ChannelSearch({ Key? key }) : super(key: key);

  @override
  _ChannelSearchState createState() => _ChannelSearchState();
}

class _ChannelSearchState extends State<ChannelSearch> {

  QuerySnapshot? allChannelsSnapshot;

  final GlobalKey<FormState> _createChannelKey = GlobalKey<FormState>();
  final TextEditingController _createChannelNameFieldController = TextEditingController();

  snapshotChannels() {
    DatabaseMethods.getChannels().then((value) {
      setState(()  {
        allChannelsSnapshot = value;
      });
    });
  }

  createChannel() async {
    DocumentReference channel = await DatabaseMethods.addChannel(_createChannelNameFieldController.text);
    DatabaseMethods.subscribeUserToChannel(channel.id, userIdMock);
    snapshotChannels();
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
        return channelTile(context, allChannelsSnapshot!.docs[index], widget.currentNavigationIndex);
      }
    );
  }

  @override
  void dispose() {
    _createChannelNameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Channel Search")),
      floatingActionButton: createFloatingButton(context, _createChannelKey, _createChannelNameFieldController, createChannel),
      body: Container(
        child: searchList(),
      ),
    );
  }
}
