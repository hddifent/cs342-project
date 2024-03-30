import 'package:cs342_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/app_user.dart';

ImageProvider<Object> profileImage = const NetworkImage(defaultPictureProfileLink);

AppUser? currentAppUser;

User? currentUser;

String? currentUid;