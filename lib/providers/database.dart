import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  // CREATE

  static addChannel(String channelName) {
    Map<String, String> channelMap = {
      'name': channelName
    };

    return FirebaseFirestore.instance.collection('channels').add(channelMap);
  }

  static addTicket(String userId, String channelId, String ticketName) async {
    Map<String, dynamic> ticketMap = {
      'creatorId': userId,
      'assigneeId': '',
      'channelId': channelId,
      'name': ticketName,
      'status': 'open',
      'dateCreated': Timestamp.now()
    };

    DocumentReference ticket = await FirebaseFirestore.instance.collection('tickets').add(ticketMap);

    subscribeUserToTicket(userId, ticket.id);
  }

  static subscribeUserToTicket(String userId, String ticketId) {
    Map<String, String> ticketSubsctiptionMap = {
      'userId': userId,
      'ticketId': ticketId
    };

    FirebaseFirestore.instance.collection('ticketSubscriptions').add(ticketSubsctiptionMap);
  }

  static addMessage(String userId, String ticketId, String text, String fileURL) {
    Map<String, dynamic> messageMap = {
      'senderId': userId,
      'ticketId': ticketId,
      'text': text,
      'fileURL': fileURL,
      'dateSent': Timestamp.now()
    };

    FirebaseFirestore.instance.collection('messages').add(messageMap);
  }

  static addUser(String userName, String userEmail) async {
    Map<String, String> userMap = {
      'name': userName,
      'email': userEmail
    };

    return await FirebaseFirestore.instance.collection('users').add(userMap);
  }

  static subscribeUserToChannel(String channelId, String userId) {
    Map<String, String> channelSubscriptionMap = {
      'channelId': channelId,
      'userId': userId
    };

    FirebaseFirestore.instance.collection('channelSubscriptions').add(channelSubscriptionMap);
  }

  // READ

  static getChannelsListener() {
    return FirebaseFirestore.instance.collection('channels').snapshots();
  }

  static getChannels() async {
    return await FirebaseFirestore.instance.collection('channels').get();
  }

  static getChannelsById(List<String> channelIds) async {
    if (channelIds.isEmpty) {
      return null;
    } else {
      return await FirebaseFirestore.instance.collection('channels').where(FieldPath.documentId, whereIn: channelIds).get();
    }
  }

  static getTicketsById(List<String> ticketIds) async {
    if (ticketIds.isEmpty) {
      return null;
    } else {
    return await FirebaseFirestore.instance.collection('tickets').where(FieldPath.documentId, whereIn: ticketIds).get();
    }
  }

  static getChannelByName(String channelName) async {
    return await FirebaseFirestore.instance.collection('channels').where('name', isEqualTo: channelName).get();
  }

  static getSubscribedChannels(String userId) async {
    QuerySnapshot subscribedChannelIdsSnapshot = await FirebaseFirestore.instance.collection('channelSubscriptions').where('userId', isEqualTo: userId).get();

    List<String> channelIds = [];

    for (QueryDocumentSnapshot doc in subscribedChannelIdsSnapshot.docs) {
      channelIds.add(doc.get('channelId'));
    }

    return await getChannelsById(channelIds);
  }

  static getChannelSubscriptions(String channelId) async {
    return await FirebaseFirestore.instance.collection('channelSubscriptions').where('channelId', isEqualTo: channelId).get();
  }

  static getChannelTickets(String channelId) async {
    return await FirebaseFirestore.instance.collection('tickets').where('channelId', isEqualTo: channelId).get();
  }

  static getUnassignedChannelTickets(String channelId) async {
    return await FirebaseFirestore.instance.collection('tickets').where('channelId', isEqualTo: channelId)
      .where('status', isEqualTo: 'open')
      .where('assigneeId', isEqualTo: '')
      .get();
  }

  static getTicketMessagesStream(String ticketId) async {
    return FirebaseFirestore.instance.collection('messages').where('ticketId', isEqualTo: ticketId).orderBy('dateSent').snapshots();
  }

  static getUser(String userId) async {
    return await FirebaseFirestore.instance.collection('users').where('userId', isEqualTo: userId).get();
  }

  static getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).get();
  }

  static getUserTickets(String userId) async {
    QuerySnapshot userTicketsIdsSnapshot = await FirebaseFirestore.instance.collection('ticketSubscriptions').where('userId', isEqualTo: userId).get();

    List<String> ticketIds = [];

    for (QueryDocumentSnapshot doc in userTicketsIdsSnapshot.docs) {
      ticketIds.add(doc.get('ticketId'));
    }

    return await getTicketsById(ticketIds);
  }

  // UPDATE

  static assignTicket(String ticketId, String userId) {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'assigneeId': userId
    });

    subscribeUserToTicket(userId, ticketId);
  }

  static unassignTicket(String ticketId, String userId) async {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'assigneeId': ''
    });

    QuerySnapshot ticketSubscription = await FirebaseFirestore.instance.collection('ticketSubscriptions').where('ticketId', isEqualTo: ticketId).where('userId', isEqualTo: userId).get();
    ticketSubscription.docs.first.reference.delete();
  }

  static openTicket(String ticketId) {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'status': 'open'
    });
  }

  static closeTicket(String ticketId) {
    FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'status': 'closed'
    });
  }

  // DELETE

  static unsubscribeUserFromChannel(String channelId, String userId) async {
    QuerySnapshot channelSubscription = await FirebaseFirestore.instance.collection('channelSubscriptions').where('channelId', isEqualTo: channelId).where('userId', isEqualTo: userId).get();
    channelSubscription.docs.first.reference.delete();
  }

  static deleteChannel(String channelId) {

  }

  static deleteTicket(String ticketId) {

  }

  static deleteUser(String userId) {

  }
}
