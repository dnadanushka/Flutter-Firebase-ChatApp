import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/messege.dart';
import 'package:true_convos/models/status.dart';
import 'package:true_convos/models/user.dart';
import 'package:true_convos/screens/chat_tile.dart';
import 'package:true_convos/services/database.dart';

import 'Home/status_tile.dart';

class ChatPage extends StatefulWidget {
  final String senderid;
  final String uname;
  final String status;

  ChatPage({this.senderid, this.uname, this.status});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.uname),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: DatabaseService(uid: user.uid)
                  .messeges(widget.senderid, widget.status),
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

                return ListView.builder(
                    itemCount: messegeList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChatTile(
                        messege: messegeList[index],
                      );
                    });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        // bottom: 8,
                      ),
                      child: Transform.translate(
                        offset: Offset(0, -6),
                        child: TextField(
                          controller: messageController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -1,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        DatabaseService(uid: user.uid).sendMessage(
                            messageController.text,
                            widget.status,
                            widget.senderid);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
