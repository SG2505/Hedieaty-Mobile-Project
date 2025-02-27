import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/UserController.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final editInfoFormKey = GlobalKey<FormState>();

  var completePhoneNumber = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: currentUser.name);
    emailController = TextEditingController(text: currentUser.email);
    phoneController = TextEditingController(text: currentUser.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [], title: 'Edit Info', isTherebackButton: true),
      body: SingleChildScrollView(
        child: Form(
          key: editInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(25),
                child: Ink(
                  width: 0.5.sw,
                  height: 0.15.sh,
                  decoration: BoxDecoration(
                      color: ThemeClass.blueThemeColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: Text(
                      'Tap to set image',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              /////////////name form field////////////
              textFieldLabel('Name'),
              SizedBox(
                width: 0.83.sw,
                height: 80,
                child: TextFormField(
                  style: ThemeClass.theme.textTheme.bodyMedium,
                  cursorHeight: 30,
                  controller: nameController,
                  decoration: ThemeClass.textFormFieldDecoration(
                      prefixIcon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              ////////////email form field////////////
              textFieldLabel('Email'),
              SizedBox(
                width: 0.83.sw,
                height: 80,
                child: TextFormField(
                  style: ThemeClass.theme.textTheme.bodyMedium,
                  controller: emailController,
                  decoration: ThemeClass.textFormFieldDecoration(
                      prefixIcon: Icon(
                    Icons.alternate_email_rounded,
                    color: Colors.grey,
                  )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email can't be empty";
                    }
                    // Regular expression for validating email format
                    else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
              ),

              ////////////Phone form field////////////
              textFieldLabel('Phone'),
              SizedBox(
                width: 0.83.sw,
                height: 80,
                child: TextFormField(
                  style: ThemeClass.theme.textTheme.bodyMedium,
                  controller: phoneController,
                  decoration: ThemeClass.textFormFieldDecoration(
                      prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.grey,
                  )),
                  onChanged: (phone) {
                    completePhoneNumber = phone;
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return "Phone number can't be empty";
                    }
                    if (value.length < 12) {
                      return "Please add numeric country code";
                    }
                    return null;
                  },
                ),
              ),
              isLoading
                  ? LoadingAnimationWidget.inkDrop(
                      color: ThemeClass.blueThemeColor, size: 60)
                  : GradientButton(
                      width: 0.3.sw,
                      height: 0.05.sh,
                      label: 'Save',
                      onPressed: () async {
                        if (editInfoFormKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var result = await UserController.updateUser(
                            userId: currentUser.id!,
                            name: nameController.text,
                            email: emailController.text.trim(),
                            phoneNumber: phoneController.text,
                            profilePictureUrl: currentUser.profilePictureUrl,
                            preferences: currentUser.preferences,
                          );

                          // Handle the result (show message, navigate, etc.)
                          if (result) {
                            setState(() {
                              isLoading = false;
                            });
                            toastification.show(
                                alignment: Alignment.topCenter,
                                autoCloseDuration: const Duration(seconds: 5),
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                context: context,
                                title: Text("Updated Data Successfully"));
                          } else {
                            toastification.show(
                                alignment: Alignment.topCenter,
                                autoCloseDuration: const Duration(seconds: 5),
                                context: context,
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                title: Text(result));
                          }
                        }
                      },
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldLabel(String text) {
    return Container(
      margin: EdgeInsets.only(left: 50, bottom: 10, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
