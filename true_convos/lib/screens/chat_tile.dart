import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/messege.dart';
import 'package:true_convos/models/status.dart';
import 'package:true_convos/models/user.dart';

class ChatTile extends StatelessWidget {
  final Messege messege;

  ChatTile({this.messege});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    bool isMe = user.uid == messege.senderid;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: isMe ? 100 : 12,
        right: !isMe ? 100 : 12,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: isMe ? Colors.transparent : Colors.grey.shade700,
        border: isMe ? Border.all(color: Colors.black54) : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomRight: isMe ? Radius.circular(6) : Radius.zero,
          bottomLeft: isMe ? Radius.zero : Radius.circular(6),
        ),
      ),
      child: Text(
        messege.messege,
        softWrap: true,
        // textAlign: isMe ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.montserrat(
          color: isMe ? Colors.black54 : Colors.white,
        ),
      ),
    );
  }
}
