import 'package:flutter/material.dart';

Widget channelTile(String channelName, {bool isSubscribed = false}) {

  Icon notificationIcon = Icon(isSubscribed ? Icons.notifications_on : Icons.notifications_off);

  return Container(
    child: Row(
      children: [
        Container(
          child: Text(channelName),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: notificationIcon
        )
      ],
    ),
  );
}
