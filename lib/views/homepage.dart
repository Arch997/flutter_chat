import 'package:flutter/material.dart';

import 'package:zuri_chat_app/views/chatPage.dart';


class HomePage extends StatefulWidget {
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentSelected = 0;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  // final GlobalKey<_HomePageState> _homePageState = 
    // GlobalKey<_HomePageState>();

  void _onTap(int index) {
    index == 2 
      ? drawerKey.currentState!.openDrawer()
      : setState(() => _currentSelected = index);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
      // drawer: DrawerList(),
      key: drawerKey,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelected,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert_sharp),
            label: 'Settings'
          ),
        ],
        onTap: _onTap,
      )
    );
  }
}
