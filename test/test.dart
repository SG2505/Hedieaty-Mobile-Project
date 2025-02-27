import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/firebase_options.dart';
import 'package:hedieaty/main.dart';
import 'package:flutter/material.dart';

void main() async {
  // Initialize the integration test binding before running tests
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  /////////////////////////////////remove splash screen from home route to work//////////////////////////////////////
  setUpAll(() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  // Now run the test
  testWidgets('User logs in and adds a friend', (tester) async {
    // Ensure widget tree is pumped and ready
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    //await tester.pump(const Duration(seconds: 20));
    // Find login screen widgets
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginButton = find.text('Login');

    // Enter login credentials
    await tester.enterText(emailField, 'salahgad24@gmail.com');
    await tester.enterText(passwordField, '12345678#');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // // Verify home screen is displayed
    // expect(find.text('Hello,'), findsOneWidget);

    // Open add friend dialog
    final addFriendButton = find.byTooltip('Add Friend');
    await tester.tap(addFriendButton);
    await tester.pumpAndSettle();

    // Enter friend phone number
    final phoneField = find.byType(TextFormField).first;
    final addButton = find.text('Add');

    await tester.enterText(phoneField, '1236459780');
    await tester.tap(addButton);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Verify friend is added
    expect(find.textContaining('test'), findsOneWidget);
  });
}
