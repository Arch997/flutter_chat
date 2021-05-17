import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zuri_chat_app/utils/helpers.dart';
import 'package:zuri_chat_app/views/chatDetail.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String name;
  String messageContent;
  String imageUrl;
  String time;
  bool messageRead;
  String uid;
  String pid;
  QueryDocumentSnapshot contact;

  ConversationList({
    required this.name, 
    required this.messageContent, 
    required this.imageUrl,
    required this.time,
    required this.messageRead,
    required this.uid,
    required this.pid,
    required this.contact,
  });
  @override
  _ConversationListState createState() => _ConversationListState();
}


class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => createConversation(context),
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 10
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.imageUrl,
                    ),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name, style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70
                          )),
                          SizedBox(height: 6),
                          Text(
                            widget.messageContent,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: widget.messageRead ? FontWeight.bold : FontWeight.normal
                            ),
                          )
                        ]
                      ),
                    )
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: widget.messageRead ? FontWeight.bold : FontWeight.normal
              ),
            )
          ],
        )
      )
    );
  }

  void createConversation(BuildContext context) {
    String convoID = Helpers.getConvoID(widget.uid, widget.pid);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ChatDetail(
        uid: widget.uid, 
        contact: widget.contact, 
        convoID: convoID,
        photoURL: widget.imageUrl,
      )));
  }
}

