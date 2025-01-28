import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:manganjawa/routes/routes.dart';
import 'package:manganjawa/auth/auth_services/user_token_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserTokenService _tokenService = UserTokenService();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> updateUserName(String newName) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await user.updateDisplayName(newName);
        Get.snackbar("Success", "Profile name updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile name: ${e.toString()}");
    }
  }

  Future<void> updateProfilePicture(String newUrl) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await user.updatePhotoURL(newUrl);
        Get.snackbar("Success", "Profile picture updated successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile picture: ${e.toString()}");
    }
  }

  Future<User?> signUp(String emailAddress, String password) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user != null) {
        await _tokenService.saveUserToken(credential.user!.uid);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.snackbar("Error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.snackbar("Error", "The account already exists for that email.");
      } else {
        Get.snackbar("Error", e.message ?? "An unknown error occurred.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
    }
    return null;
  }

  Future<User?> logIn(String emailAddress, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user != null) {
        await _tokenService.saveUserToken(credential.user!.uid);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.user != null) {
      await _tokenService.saveUserToken(userCredential.user!.uid);
    }
    return userCredential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _tokenService.clearUserToken();
    Get.offAllNamed(MyRoutes.login);
  }

  Future<bool> isLoggedIn() async {
    return await _tokenService.isLoggedIn();
  }
}
