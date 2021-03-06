import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/channel_tile.dart';
import 'package:ecg_helpdesk/widgets/create_floating_button.dart';
import 'package:ecg_helpdesk/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class MyChannels extends StatefulWidget {
  final int currentNavigationIndex = 1;
  const MyChannels({ Key? key }) : super(key: key);

  @override
  _MyChannelsState createState() => _MyChannelsState();
}

class _MyChannelsState extends State<MyChannels> {

  QuerySnapshot? myChannelsSnapshot;

  final GlobalKey<FormState> _createChannelKey = GlobalKey<FormState>();
  final TextEditingController _createChannelNameFieldController = TextEditingController();

  snapshotChannels() async {
    String? userId = await HelperFunctions.getUserIdSharedPreference();
    DatabaseMethods.getSubscribedChannels(userId!).then((value) {
      setState(()  {
        myChannelsSnapshot = value;
      });
    });
  }

  createChannel() async {
    DocumentReference channel = await DatabaseMethods.addChannel(_createChannelNameFieldController.text);
    String? userId = await HelperFunctions.getUserIdSharedPreference();

    DatabaseMethods.subscribeUserToChannel(channel.id, userId!);
    snapshotChannels();
  }

  @override
  void initState() {
    snapshotChannels();
    super.initState();
  }

  Widget myChannelsList() {
    return myChannelsSnapshot == null ? ListView() : ListView.separated(
      shrinkWrap: true,
      itemCount: myChannelsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return channelTile(context, myChannelsSnapshot!.docs[index], widget.currentNavigationIndex, isSubscribed: true);
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Channels"),
        actions: [
          logoutButton(context)
        ],
      ),
      floatingActionButton: createFloatingButton(context, _createChannelKey, _createChannelNameFieldController, createChannel),
      body: Container(
        child: myChannelsList(),
      ),
    );
  }
}
