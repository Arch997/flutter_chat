import 'package:flutter/material.dart';
import 'package:zuri_chat_app/services/AuthService.dart';
import 'package:zuri_chat_app/views/signIn.dart';


// ignore: must_be_immutable
class DrawerList extends StatefulWidget {
  String name;
  String imageURL;

  DrawerList({required this.name, required this.imageURL});
  
  @override
  _DrawerListState createState() => _DrawerListState(); 
}


class _DrawerListState extends State<DrawerList> {
  
  // ScrollController _scrollController = ScrollController();

  final AuthService _auth = AuthService();

  signOut() async {
    await _auth.signOut();
    // After signing out, redirect to signIn page
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => SignIn()));
  }

  @override 
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        color: Colors.black87,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 3.0),
              // padding: EdgeInsets.fromLTRB(200.0, 0.0, 0.0, 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black26
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, right: 200),
                      child: Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 40,
                            backgroundImage: NetworkImage(widget.imageURL)
                          ),
                          Text(widget.name, style: TextStyle(
                            color: Colors.white70
                          )),
                        ],
                      )               
                  ),
                  SizedBox(width: 2),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Colors.lightBlue,
                            size: 20,
                        ),
                      ),
                    Expanded(
                      child: ListTile(
                        onTap: () => signOut(),
                        title: Text('Logout', style: TextStyle(
                          color: Colors.white70,
                        )),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,),
                          child: Icon(
                            Icons.settings,
                            color: Colors.cyan,
                            size: 20,
                        ),
                      ),
                    Expanded(
                      child: ListTile(
                        onTap: () {},
                        title: Text('Settings', style: TextStyle(
                          color: Colors.white70,
                        )),
                      ),
                    )
                  ],
                )
         
              ],
            )
          ],
        )
      ),
    );
  }
}