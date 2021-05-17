import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import 'package:zuri_chat_app/models/users.dart';
import 'package:zuri_chat_app/services/database.dart';
import 'package:zuri_chat_app/views/chatPage.dart';

class NewMessageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return StreamProvider<Iterable<CustomUser>>.value(
      value: Database.streamUsers(),
      child: ChatPage(),
    );
  }  
}
