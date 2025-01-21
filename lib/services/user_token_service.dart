import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserTokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> saveUserToken() async {
    try {
      // Get the current user
      final user = _auth.currentUser;
      if (user != null) {
        // Get the FCM token
        final fcmToken = await _messaging.getToken();
        
        if (fcmToken != null) {
          // Save to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'fcmToken': fcmToken,
            'lastUpdated': FieldValue.serverTimestamp(),
            'platform': Theme.of(Get.context!).platform.toString(),
          }, SetOptions(merge: true));
          
          print('FCM Token saved for user: ${user.uid}');
        }
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<void> removeUserToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': FieldValue.delete(),
        });
      }
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }

  Stream<String?> getUserToken(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['fcmToken'] as String?);
  }
}