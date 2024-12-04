import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/UserController.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:hedieaty/View/Widgets/TextFieldLabel.dart';
import 'package:toastification/toastification.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;

  final loginFormKey = GlobalKey<FormState>();
  static const sizedBox = SizedBox(
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.1.sh,
              ),
              Image.asset(
                "assets/icons/LoginScreenIcons/gift.png",
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Hedieaty",
                style: ThemeClass.theme.textTheme.headlineLarge,
              ),
              sizedBox,
              TextFieldLable(text: "Email"),
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
              sizedBox,
              TextFieldLable(text: 'Password'),
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
                    }
                    return null; // Validation passed
                  },
                ),
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(47, 198, 234, 1)),
                      )),
                ),
              ),
              sizedBox,
              GradientButton(
                  label: "Login",
                  onPressed: () async {
                    if (loginFormKey.currentState!.validate()) {
                      var result = await UserController.handleLogin(
                          email: emailController.text.trim(),
                          password: passwordController.text);
                      // handleLogin returns bool which is true only if success
                      if (result == true) {
                        context.goNamed('home');
                      } else {
                        toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            context: context,
                            title: Text(result));
                      }
                    }
                  },
                  width: 0.3.sw,
                  height: 0.065.sh),
              sizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  const SizedBox(
                    width: 3,
                  ),
                  TextButton(
                      onPressed: () {
                        context.push("/SignUpScreen");
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(47, 198, 234, 1)),
                      ))
                ],
              ),
              sizedBox
            ],
          ),
        ),
      ),
    );
  }
}
