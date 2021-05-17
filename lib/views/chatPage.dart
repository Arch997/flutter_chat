import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:zuri_chat_app/models/users.dart';
import 'package:zuri_chat_app/widgets/drawerList.dart';
import 'package:zuri_chat_app/widgets/conversationList.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}): super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {

  List<ChatUser> users = [
    ChatUser(
      name: 'Mike Olowo',
      imageURL: 'https://i.pravatar.cc/150?img=1',
      message: 'Test message',
      time: 'Now'
    ), 
    ChatUser(
      name: 'John Barnes',
      imageURL: 'https://i.pravatar.cc/150?img=1',
      message: 'Heyy',
      time: 'Now',
    ),
  ];
  String image = '';
  String name = '';

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    CollectionReference firestoreUsers = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      drawer: DrawerList(name: name, imageURL: image),
      key: scaffoldKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => scaffoldKey.currentState!.openDrawer(),
                        child: Icon(
                        Icons.menu,
                        color: Colors.white70,
                      ),
                    ),
                    
                    Text(
                      'Messages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.tealAccent
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 2,
                        bottom: 2
                      ),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50]
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.pink, size: 20,),
                          SizedBox(width: 1.5),
                          Text('Start New', style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),)
                        ]
                      )
                    )
                  ],
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white70,),
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  filled: true,
                  fillColor: Colors.teal
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreUsers.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator.adaptive();
                }
                else if (snapshot.hasData || snapshot.data != null) {
                  var data = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // print(data[index]['time']);
                      if (data[index]['id'] == 
                        _auth.currentUser!.uid) {
                          name = data[index]['username'];
                          image = data[index]['photoURL'];
                          print('WIDGET NAME: $name: $image');
                          return Container(height: 0);   
                      } else {
                          return ConversationList(
                            name: data[index]['username'],
                            messageContent: '',
                            imageUrl: data[index]['photoURL'],
                            time: '',
                            messageRead: (index == 0 || index == 3) ? 
                              true : false,
                            uid: _auth.currentUser!.uid,
                            pid: data[index]['id'],
                            contact: data[index],
                        );
                      }
                      
                    },
                  );
                }
                return Text('Loading');
              },
            ),
          ]
        )
      ),
    );
  }
}
