import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/UserController.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final signUpDetailsFormKey = GlobalKey<FormState>();

  static const SizedBox sizedBox = SizedBox(
    height: 10,
  );
  var completePhoneNumber = '';
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [], title: 'Hedieaty', isTherebackButton: false),
      body: SingleChildScrollView(
        child: Form(
            key: signUpDetailsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBox,
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(150),
                  child: Ink(
                    width: 0.40.sw,
                    height: 0.2.sh,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeClass.blueThemeColor,
                    ),
                    child: Center(
                      child: Text(
                        'Tap to set image',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                sizedBox,
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
                sizedBox,
                ////////////////password form field////////////
                textFieldLabel('Password'),
                SizedBox(
                  width: 0.83.sw,
                  height: 80,
                  child: TextFormField(
                    style: ThemeClass.theme.textTheme.bodyMedium,
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: ThemeClass.textFormFieldDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixWidget: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(value)) {
                        return "Password must have one special character";
                      }
                      return null; // Validation passed
                    },
                  ),
                ),
                sizedBox,
                textFieldLabel('Confirm Password'),
                SizedBox(
                  width: 0.83.sw,
                  height: 80,
                  child: TextFormField(
                    style: ThemeClass.theme.textTheme.bodyMedium,
                    controller: confirmPasswordController,
                    obscureText: isConfirmPasswordHidden,
                    decoration: ThemeClass.textFormFieldDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      suffixWidget: IconButton(
                        icon: Icon(
                          isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "The passwords don't match";
                      }
                      return null;
                    },
                  ),
                ),
                sizedBox,
                GradientButton(
                    label: 'Sign Up',
                    onPressed: () {
                      if (signUpDetailsFormKey.currentState!.validate()) {
                        // All validations passed, proceed with the sign-up logic
                        print('Sign Up Successful');
                        print('Name: ${nameController.text}');
                        print('Email: ${emailController.text}');
                        print('Phone: ${completePhoneNumber}');
                        var message = UserController.handleSignUp(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            phoneNumber: completePhoneNumber);
                        print(message);
                      } else {
                        // Validation failed, errors will automatically display
                        print('Validation failed');
                      }
                    },
                    width: 0.3.sw,
                    height: 0.065.sh),
                sizedBox,
              ],
            )),
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
