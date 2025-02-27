import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/FriendController.dart';
import 'package:hedieaty/Firebase/FCM.dart';
import 'package:hedieaty/Firebase/FIrebaseFriendService.dart';
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
        initialCountryCode: 'EG',
        decoration: ThemeClass.textFormFieldDecoration(),
        onChanged: (phone) {
          completePhoneNumber = phone.completeNumber;
        },
      ),
      actions: [
        isLoading
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () async {
                  if (phoneController.text.isNotEmpty) {
                    setState(() => isLoading = true);

                    var result = await FriendController.handleAddFriend(
                        completePhoneNumber);

                    if (result == "Added Friend Successfully") {
                      FirebaseFriendService fs = FirebaseFriendService();
                      var friendMap = await fs.getRecentlyAddedFriendwithEvents(
                          completePhoneNumber);
                      FirebaseMessagingService().sendNotification(
                          targetFCMToken:
                              friendMap['friend'].deviceMessageToken,
                          title: "A friend Added You 🥳",
                          body:
                              "${currentUser.name} added you to his friend list");
                      setState(() => isLoading = false);

                      if (mounted) {
                        Navigator.of(context).pop();

                        // Update the home screen state
                        if (!context.mounted) return;
                        context.pushReplacementNamed('home', extra: friendMap);
                      }
                    }
                    setState(() => isLoading = false);
                    toastification.show(
                        context: context,
                        title: Text(result),
                        autoCloseDuration: const Duration(seconds: 5),
                        alignment: AlignmentDirectional.topCenter,
                        icon: result == "Added Friend Successfully"
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                              )
                            : null);
                  } else {
                    toastification.show(
                        context: context,
                        alignment: AlignmentDirectional.topCenter,
                        autoCloseDuration: const Duration(seconds: 5),
                        title: Text("Please enter a phone number"));
                  }
                },
                child: Text('Add'),
              ),
      ],
    );
  }
}
