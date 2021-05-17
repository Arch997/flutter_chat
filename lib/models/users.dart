// import 'package:flutter/material.dart';

class ChatUser{
  dynamic name;
  String message;
  String imageURL;
  String time;
  String email;

  ChatUser({required this.name, this.message: '',
          required this.imageURL, required this.time,
          this.email: ''});
}


class CustomUser{
  final String id;
  final String username;
  final String email;
  final String userRole;
  final String photoURL;

  CustomUser({
    this.id: '', this.username: '', this.email: '', 
      this.userRole: '', this.photoURL: ''
  });
  CustomUser.fromData(Map<String, dynamic>? data)
    : id = data!['id'], username = data['username'],
      email = data['email'], userRole = data['userRole'],
      photoURL = data['photoURL'];

  Map<String, dynamic>toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'userRole': userRole,
      'photoURL': photoURL,
    };
  }
}