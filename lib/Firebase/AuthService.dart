import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is invalid.';
      } else {
        return 'An unknown error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<dynamic> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'This user is not registered.';
      } else if (e.code == 'wrong-password') {
        return 'The password is incorrect.';
      } else if (e.code == "invalid-email") {
        return "wrong email format";
      } else {
        return 'Unknown error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent to $email';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for this email address.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is invalid.';
      } else {
        return 'An error occurred while sending the password reset email. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<String> signOut() async {
    try {
      await firebaseAuth.signOut();
      return 'User signed out successfully';
    } catch (e) {
      return 'An error occurred while signing out: $e';
    }
  }
}
