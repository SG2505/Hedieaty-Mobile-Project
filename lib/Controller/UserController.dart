import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Services/AuthService.dart';
import 'package:hedieaty/Services/FirebaseUserService.dart';

class UserController {
  static final Authservice _authservice = Authservice();
  static final FirebaseUserService _firebaseUserService = FirebaseUserService();

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
      return 'Sign Up Successful.';
    } else if (result is String) {
      // Failure: Return the error message
      return result;
    } else {
      return 'An unknown error occurred during sign-up.';
    }
  }
}
