import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../global.dart';
import '../models/app_user.dart';
import 'firestore.dart';

class AuthenticationDatabase {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirestoreDatabase userDB = FirestoreDatabase('users');

  static Future<User?>? loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return credential.user;
    } on FirebaseAuthException { return null; }
  }

  static Future<String?>? signUpUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operator-not-allowed') { rethrow; }
      return e.code;
    }
  }

  static Future<void> loggingIn(User user) async {
    final userRef = userDB.getDocumentReference(user.uid);

    await userRef.get().then(
      (DocumentSnapshot doc) {
        final userData = doc.data() as Map<String, dynamic>;

        currentAppUser = AppUser.fromFirestore(userData);
        currentUser = user;
        print('logged in by ${currentAppUser!.username}');
      },
      onError: (e) => throw e
    );
  }

  static Future<void> signingUp(String? uid, AppUser appUser) async {
    await userDB.addDocument(uid, appUser.toFirestore());
  }

  static Future<String?> changePassword(String newPassword) async {
    try {
      await currentUser!.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

}