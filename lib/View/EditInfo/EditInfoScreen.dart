import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final editInfoFormKey = GlobalKey<FormState>();

  var completePhoneNumber = '';

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
                child: IntlPhoneField(
                  style: ThemeClass.theme.textTheme.bodyMedium,
                  controller: phoneController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                  initialCountryCode: 'EG',
                  onChanged: (phone) {
                    completePhoneNumber = phone.completeNumber;
                  },
                ),
              ),
              GradientButton(
                  width: 0.3.sw,
                  height: 0.05.sh,
                  label: 'Save',
                  onPressed: () {}),
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
