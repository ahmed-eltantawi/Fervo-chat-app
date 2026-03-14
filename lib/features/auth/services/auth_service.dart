import 'package:chat_with_me_now/config/constants/collections.dart';
import 'package:chat_with_me_now/features/chat/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class AuthService {
  static Future<bool> isThisEmailExists(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  // =========== Make user and Sign in =========

  static Future<void> makeUser(
    BuildContext context,
    String email,
    String password,
    String userName, {
    image,
  }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(
      Collections.kFriendsCollection,
    );
    if (!await isThisEmailExists(email)) {
      users.add({
        'id': email,
        'name': userName,
        'createdAt': DateTime.now(),
        'image': image ?? '',
      });
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeView.id,
      (route) => false,
      arguments: email,
    );
  }

  //========== Register ===========

  static Future<void> registerFunction({
    context,
    email,
    password,
    userName,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userLogin(context, email, password);
    await makeUser(context, email, password, userName);
  }

  //============ Social Sing in ==============

  //=== Google ===
  static Future<UserCredential> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
      serverClientId:
          "703670720492-m5f6qv65mik327ckvk13o03331rlti6h.apps.googleusercontent.com",
    );

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // === Facebook ===
  static Future<UserCredential> facebookSignIn() async {
    // Trigger the sign-in flow

    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  // ================= User login ================

  static Future<void> userLogin(
    BuildContext context,
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //========== Make social User ============
  static Future<void> makeGoogleOrFacebookUser(BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser!;
    await AuthService.makeUser(
      context,
      user.email!,
      user.uid,
      user.displayName!,
      image: user.photoURL,
    );
  }
}
