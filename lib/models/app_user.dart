import 'package:flutter/material.dart';
import '../constants.dart';

class AppUser {
  final String userID;

  String email;
  String firstName;
  String lastName;
  String username;
  String password;
  String profileImageURL;

  AppUser(this.userID, {
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    this.profileImageURL = '',
  });

  ImageProvider<Object> getProfileImage() {
    if (profileImageURL == '') {
      return const NetworkImage(defaultPictureProfileLink);
    } return NetworkImage(profileImageURL);
  }

  factory AppUser.fromFirestore(String userID, Map<String, dynamic> map) {
    return AppUser(userID,
      email: map['email'], 
      firstName: map['firstName'], 
      lastName: map['lastName'], 
      username: map['username'], 
      password: map['password'], 
      profileImageURL: map['profileImageURL']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "firstName" : firstName,
      "lastName" : lastName,
      "username" : username,
      "password" : password,
      "profileImageURL" : profileImageURL
    };
  }
  
}