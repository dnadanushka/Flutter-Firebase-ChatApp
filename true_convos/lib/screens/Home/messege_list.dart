import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/messege.dart';
import 'package:true_convos/models/recentMessege.dart';
import 'package:true_convos/models/status.dart';
import 'package:true_convos/models/user.dart';
import 'package:true_convos/screens/Home/messege_tile.dart';
import 'package:true_convos/services/database.dart';

import 'status_tile.dart';

class MessegeList extends StatefulWidget {
  @override
  _MessegeListState createState() => _MessegeListState();
}

class _MessegeListState extends State<MessegeList> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).recentMesseges,
      builder: (context, snapshot) {
        List<Messege> messegeList = snapshot.data;
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (messegeList.isEmpty) {
          return Center(
            child: Text("No Messages"),
          );
        }
        List<RecentMessege> recentMessegeList = [];  
        for (int i = 0; i < messegeList.length; i++) {
          bool avaibale = false;
          int putIndex = 0;
          for (int k = 0; k < recentMessegeList.length; k++) {
            if (recentMessegeList[k].senderid == messegeList[i].senderid &&
                recentMessegeList[k].status == messegeList[i].status) {
              avaibale = true;
              putIndex = k;
            }
          }
          if (avaibale) {
            recentMessegeList[putIndex].messegeThread.add(messegeList[i]);
          } else {
            RecentMessege recentMessege = new RecentMessege(
              receiverid: messegeList[i].receiverid,
              senderid: messegeList[i].senderid,
              status: messegeList[i].status,
              senderusername: messegeList[i].senderusername,
            );
            recentMessege.messegeThread = [];
            recentMessege.messegeThread.add(messegeList[i]);

            recentMessegeList.add(recentMessege);
          }
        }
        return ListView.builder(
            itemCount: recentMessegeList.length,
            itemBuilder: (BuildContext ctx, int index) {
              return new MessegeTile(
                recentMessege: recentMessegeList[index],
              );
              // return new Text()
            });
      },
    );
  }
}
