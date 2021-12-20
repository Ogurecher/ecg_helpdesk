import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecg_helpdesk/providers/database.dart';
import 'package:ecg_helpdesk/util/helper_functions.dart';
import 'package:ecg_helpdesk/util/mocks.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:ecg_helpdesk/widgets/message_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File? _imageFile;

  Stream<QuerySnapshot>? ticketMessagesStream;
  bool isOpen = true;
  String userId = '';

  sendMessage() async {
    String fileURL = '';

    if (_imageFile != null) {
      fileURL = await uploadImage();
    }

    String? userId = await HelperFunctions.getUserIdSharedPreference();

    DatabaseMethods.addMessage(userId!, widget.ticket.id, _messageController.text, fileURL);
  }

  pickImage() async {
    ImagePicker picker = ImagePicker();

    XFile? imageXFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      maxHeight: 400,
      imageQuality: 70
    );

    if (imageXFile != null) {
      File? imageFile = File(imageXFile.path);

      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  uploadImage() async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference ref = _storage.ref().child('img' + DateTime.now().toString());
    
    TaskSnapshot uploadTaskSnapshot = await ref.putFile(_imageFile!);

    setState(() {
      _imageFile = null;
    });

    return uploadTaskSnapshot.ref.getDownloadURL();
  }

  Widget imageFromURL(String url) {
    return url == '' ? Container() : Image.network(url);
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: ticketMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            HelperFunctions.getUserIdSharedPreference();
            return Container(
              padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
              child: Align(
                alignment: (snapshot.data!.docs[index].get('senderId') == userId ? Alignment.topRight : Alignment.topLeft),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (snapshot.data!.docs[index].get('senderId')  == userId ?  Colors.blue[200] : Colors.grey.shade200),
                  ),
                  padding: EdgeInsets.all(16),
                  child: snapshot.data!.docs[index].get('fileURL') != '' ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text(snapshot.data!.docs[index].get('text'), style: TextStyle(fontSize: 15),), padding: EdgeInsets.only(bottom: 8),),
                      imageFromURL(snapshot.data!.docs[index].get('fileURL')),
                    ],
                  ) : Text(snapshot.data!.docs[index].get('text'), style: TextStyle(fontSize: 15),),
                ),
              ),
            );
          },
        ) : Container();
      }
    );
  }

  FloatingActionButton closeTicketButton() {
    return FloatingActionButton(
      onPressed: () {
        if (isOpen == true) {
          DatabaseMethods.closeTicket(widget.ticket.id);
        } else {
          DatabaseMethods.openTicket(widget.ticket.id);
        }

        setState(() {
          isOpen = !isOpen;
        });
      },
      child: isOpen ? Icon(Icons.check) : Icon(Icons.settings_backup_restore),
      backgroundColor: Colors.green,
    );
  }

  updateUserId() {
    HelperFunctions.getUserIdSharedPreference().then((value) {
      setState(() {
        userId = value!;
      });
    });
  }

  @override
  void initState() {
    updateUserId();

    DatabaseMethods.getTicketMessagesStream(widget.ticket.id).then((value) {
      setState(() {
        ticketMessagesStream = value;
      });
    });

    setState(() {
      isOpen = widget.ticket.get('status') == 'open' ? true : false;
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
          messageField(_sendMessageKey, _messageController, sendMessage, pickImage)
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(widget.currentNavigationIndex, context),
      floatingActionButton: closeTicketButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
