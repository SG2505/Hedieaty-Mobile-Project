import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/SQL_Local/LocalDB.dart';
import 'package:hedieaty/Services/AuthService.dart';
import 'package:hedieaty/Services/FirebaseUserService.dart';
import 'package:hedieaty/main.dart';

class UserController {
  static final Authservice _authservice = Authservice();
  static final FirebaseUserService _firebaseUserService = FirebaseUserService();
  static final LocalDB _localDB = LocalDB();

  /// Handle user signup and return a status message.
  static Future<String> handleSignUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    String? profilePictureUrl,
    Map<String, dynamic>? preferences,
  }) async {
    var result = await _authservice.signUp(email: email, password: password);

    if (result is User) {
      AppUser newUser = AppUser(
        id: result.uid, // Firebase UID
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profilePictureUrl: profilePictureUrl,
        preferences: preferences,
      );

      await _firebaseUserService.createUser(newUser);
      await _localDB.insertUser(newUser);
      currentUser = newUser;
      return 'Sign Up Successful.';
    } else if (result is String) {
      // Failure: Return the error message
      return result;
    } else {
      return 'An unknown error occurred during sign-up.';
    }
  }

  static Future<dynamic> handleLogin({
    required String email,
    required String password,
  }) async {
    var result = await _authservice.signIn(email: email, password: password);

    if (result is User) {
      var userData = await _firebaseUserService.fetchUser(result.uid);
      currentUser = AppUser.fromJson(userData!);
      return true;
    } else {
      // Failure: Return the error message
      return result;
    }
  }

  static Future<dynamic> updateUser({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
    String? profilePictureUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      // Update the user in Firebase
      bool firebaseUpdateResult =
          await _firebaseUserService.updateUser(userId, {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'preferences': preferences,
      });

      if (firebaseUpdateResult) {
        // Update the user in the local database
        AppUser updatedUser = AppUser(
          id: userId,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          profilePictureUrl: profilePictureUrl,
          preferences: preferences,
        );

        await _localDB.updateUser(updatedUser);
        currentUser = updatedUser;

        // Debug: Fetch the updated user from the local database and print it
        AppUser? fetchedUser = await _localDB.getUserById(userId);
        if (fetchedUser != null) {
          print('Updated user from local DB:');
          print('Name: ${fetchedUser.name}');
          print('Email: ${fetchedUser.email}');
          print('Phone: ${fetchedUser.phoneNumber}');
          print('Profile Picture URL: ${fetchedUser.profilePictureUrl}');
          print('Preferences: ${fetchedUser.preferences}');
        } else {
          print('User not found in local database.');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return 'An error occurred while updating user data: $e';
    }
  }
}
