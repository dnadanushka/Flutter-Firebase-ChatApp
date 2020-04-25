import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/recent_status.dart';
import 'package:true_convos/models/status.dart';
import 'package:true_convos/models/user.dart';
import 'package:true_convos/services/database.dart';

import 'status_tile.dart';

class StatusList extends StatefulWidget {
  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _configureFirebaseListeners();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);


    return StreamBuilder<Object>(

      
      stream: DatabaseService(uid: user.uid).statuses,
      builder: (context, snapshot) {
        List<Status> statusList = snapshot.data;


        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (statusList.isEmpty) {
          return Center(
            child: Text("No Statuses"),
          );
        }

        List<RecentStatus> recentStatusList = [];
        for (int i = 0; i < statusList.length; i++) {
          bool avaibale = false;
          int putIndex = 0;
          for (int k = 0; k < recentStatusList.length; k++) {
            if (recentStatusList[k].uid == statusList[i].uid &&
                recentStatusList[k].username == statusList[i].username) {
              avaibale = true;
              putIndex = k;
            }
          }
          if (avaibale) {
            recentStatusList[putIndex].statusThread.add(statusList[i]);
          } else {
            RecentStatus recentMessege = new RecentStatus(
              uid: statusList[i].uid,
              username: statusList[i].username,
            );
            recentMessege.statusThread = [];
            recentMessege.statusThread.add(statusList[i]);

            recentStatusList.add(recentMessege);
          }
        }

        return ListView.builder(
            itemCount: recentStatusList.length,
            itemBuilder: (BuildContext ctx, int index) {
              return new StatusTile(status: recentStatusList[index]);
            });
      },
    );
  }
}
