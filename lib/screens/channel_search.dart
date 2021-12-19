import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/auth.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/authenticate.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
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
  List<String> subscribedChannelIds = [];

  final GlobalKey<FormState> _createChannelKey = GlobalKey<FormState>();
  final TextEditingController _createChannelNameFieldController = TextEditingController();

  snapshotChannels() {
    DatabaseMethods.getChannels().then((value) {
      setState(()  {
        allChannelsSnapshot = value;
      });
    });
  }

  updateSubscribedChannelIds() async {
    String? userId = await HelperFunctions.getUserIdSharedPreference();
    DatabaseMethods.getSubscribedChannels(userId!).then((value) {
      if (value != null) {
        List<String> documentIds = [];
        for (QueryDocumentSnapshot doc in value.docs) {
          documentIds.add(doc.id);
        }

        setState(() {
          subscribedChannelIds = documentIds;
        });
      }
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
    // updateSubscribedChannelIds();
    super.initState();
  }

  Widget searchList() {
    return allChannelsSnapshot == null ? ListView() : ListView.builder(
      shrinkWrap: true,
      itemCount: allChannelsSnapshot!.docs.length,
      itemBuilder: (context, index) {
        bool isSubscribed = subscribedChannelIds.contains(allChannelsSnapshot!.docs[index].id);
        return channelTile(context, allChannelsSnapshot!.docs[index], widget.currentNavigationIndex, isSubscribed: isSubscribed);
      }
    );
  }

  @override
  void dispose() {
    _createChannelNameFieldController.dispose();
    super.dispose();
  }

  AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Channels"),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authenticate()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      floatingActionButton: createFloatingButton(context, _createChannelKey, _createChannelNameFieldController, createChannel),
      body: Container(
        child: searchList(),
      ),
    );
  }
}
