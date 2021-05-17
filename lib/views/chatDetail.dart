
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:zuri_chat_app/services/database.dart';


// ignore: must_be_immutable
class ChatDetail extends StatefulWidget {
  final String uid;
  final QueryDocumentSnapshot contact;
  final String convoID;
  String photoURL;

  ChatDetail({
    required this.uid, 
    required this.contact, 
    required this.convoID,
    required this.photoURL
  });

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late String convoID;
  late QueryDocumentSnapshot contact;
  List<DocumentSnapshot>? listMessage;
  late final String uid;
  late String photoURL;

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
      uid = widget.uid;
      convoID = widget.convoID;
      contact = widget.contact;
      photoURL = widget.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    Query firestoreMsgs = 
    FirebaseFirestore
      .instance
      .collection('messages')
      .doc(convoID)
      .collection(convoID)
      .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        // title: Text('Chat Detail'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),         
              ),
              SizedBox(width: 2),
              CircleAvatar(
                backgroundImage: 
                  NetworkImage(photoURL),
                maxRadius: 20,
              ),
              SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contact['username'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.cyanAccent
                    ), 
                  )
                ],
              )),
              Icon(Icons.settings)
            ],
          ),
        )),

      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestoreMsgs.snapshots(),
            builder: (
              BuildContext context, 
              AsyncSnapshot<QuerySnapshot> snapshot
            ) {
              if (snapshot.hasData || snapshot.data != null) {
                listMessage = snapshot.data!.docs;
                
                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: listMessage!.length,
                  itemBuilder: (BuildContext context, index) {
                    var doc = listMessage![index];
                    if (!doc['read'] && doc['idTo'] == uid) {
                      Database.updateMessageStatus(doc, convoID);
                    }
                    return Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                        bottom: 10
                      ),
                      child: Align(
                        // If my message, align to the right, 
                        // else align left
                        alignment: doc['idFrom'] == uid ? 
                          Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: doc['idFrom'] == uid ? Colors.deepOrange : Colors.lightBlue, 
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            doc['content'],
                            style: TextStyle(color: Colors.white70)
                          )
                        )
                      ),
                    );
                  }
                );
              }
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator.adaptive()
                );
              }
              return Center(child: CircularProgressIndicator.adaptive());
            }
          ),
          
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                bottom: 10,
                top: 10,
              ),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Write message',
                        // hintStyle: TextStyle()
                        border: InputBorder.none,
                      ),
                    )
                  ),
                  SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: () => onSend(textController.text),
                    child: Icon(Icons.send, size: 18),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  
  void onSend(String content) {
    if (content.trim() != '') {
      // If content is not empty string, set text controller to empty
      textController.clear();
      content = content.trim();
      Database.sendMessage(convoID, uid, contact.id, content,
          DateTime.now().millisecondsSinceEpoch.toString());
    }
  }
}