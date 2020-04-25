import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/recent_status.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:true_convos/models/user.dart';

import '../chat_page.dart';

class StatusTile extends StatelessWidget {
  final RecentStatus status;

  StatusTile({this.status});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            onTap: () {
              if (user.uid != status.uid) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      senderid: status.uid,
                      uname: status.username,
                      status: status.statusThread.last.status,
                    ),
                  ),
                );
              }
            },
            leading: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(status.username),
            subtitle: Text(status.statusThread.last.status),
            trailing: Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(
                int.parse(status.statusThread.last.timestamp))))),
      ),
    );
  }
}
