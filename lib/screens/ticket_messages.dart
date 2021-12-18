import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:ecg_helpdesk/widgets/message_field.dart';
import 'package:flutter/material.dart';

class TicketMessages extends StatefulWidget {
  final QueryDocumentSnapshot ticket;
  final int currentNavigationIndex;
  
  const TicketMessages(this.ticket, this.currentNavigationIndex, { Key? key }) : super(key: key);

  @override
  _TicketMessagesState createState() => _TicketMessagesState();
}

class _TicketMessagesState extends State<TicketMessages> {

  final GlobalKey<FormState> _sendMessageKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  Stream<QuerySnapshot>? ticketMessagesStream;

  sendMessage() {
    DatabaseMethods.addMessage(userIdMock, widget.ticket.id, _messageController.text, '');
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: ticketMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Container(
              child: Text(snapshot.data!.docs[index].get('text')),
            );
          },
        ) : Container();
      }
    );
  }

  @override
  void initState() {
    DatabaseMethods.getTicketMessagesStream(widget.ticket.id).then((value) {
      setState(() {
        ticketMessagesStream = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.ticket.get('name')} chat')),
      body: Stack(
        children: [
          messageList(),
          messageField(_sendMessageKey, _messageController, sendMessage, (){})
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(widget.currentNavigationIndex, context),
    );
  }
}
