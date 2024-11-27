import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';

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
  final giftDetailsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [], title: 'Edit Info', isTherebackButton: true),
      body: SingleChildScrollView(
        child: Form(
          key: giftDetailsFormKey,
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
                height: 0.065.sh,
                child: TextFormField(
                  controller: nameController,
                  decoration:
                      ThemeClass.textFormFieldDecoration("Name can't be empty"),
                ),
              ),
              ////////////email form field////////////
              textFieldLabel('Email'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: emailController,
                  decoration: ThemeClass.textFormFieldDecoration(
                      "Email can't be empty"),
                ),
              ),
              ////////////Phone form field////////////
              textFieldLabel('Phone'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: phoneController,
                  decoration: ThemeClass.textFormFieldDecoration(
                      "Enter a correct phone number"),
                ),
              ),
              ///////////////category form field///////// adjuuuuuuust to date picker
              textFieldLabel('Date of Birth'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: dateController,
                  decoration:
                      ThemeClass.textFormFieldDecoration("Name can't be empty"),
                ),
              ),
              ////////////////status dropdown////////////
              textFieldLabel('Gender'),
              DropdownMenu(
                  controller: genderController,
                  width: 0.83.sw,
                  inputDecorationTheme: ThemeClass.dropdownMenuDecoration(),
                  menuStyle: MenuStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(ThemeClass.blueThemeColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)))),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'male', label: 'Male'),
                    DropdownMenuEntry(value: 'female', label: 'Female')
                  ]),
              const SizedBox(
                height: 20,
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
