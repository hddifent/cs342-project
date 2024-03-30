import '../constants.dart';

class AppUser {
  String email;
  String firstName;
  String lastName;
  String username;
  String password;
  String profileImageURL;

  AppUser({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.profileImageURL,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'], 
      firstName: map['firstName'], 
      lastName: map['lastName'], 
      username: map['username'], 
      password: map['password'], 
      profileImageURL: map['profileImageURL'] ?? defaultPictureProfileLink
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