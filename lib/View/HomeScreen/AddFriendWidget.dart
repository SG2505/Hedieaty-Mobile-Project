import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Firebase/FirebaseUserService.dart';
import 'package:hedieaty/main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:toastification/toastification.dart';

class AddFriendWidget extends StatefulWidget {
  const AddFriendWidget({super.key});

  @override
  State<AddFriendWidget> createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends State<AddFriendWidget> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  var completePhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      backgroundColor: ThemeClass.blueThemeColor,
      title: Text('Enter Phone Number'),
      content: IntlPhoneField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: ThemeClass.textFormFieldDecoration(),
        onChanged: (phone) {
          completePhoneNumber = phone.completeNumber;
        },
      ),
      actions: [
        isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  if (phoneController.text.isNotEmpty) {
                    setState(() => isLoading = true);
                    FirebaseUserService fc = FirebaseUserService();
                    await fc.addFriend(
                        currentUserId: currentUser.id!,
                        phoneNumber: completePhoneNumber);
                    setState(() => isLoading = false);
                    context.pop();
                  } else {
                    toastification.show(
                        title: Text("Please enter a phone number"));
                  }
                },
                child: Text('Add'),
              ),
      ],
    );
  }
}
