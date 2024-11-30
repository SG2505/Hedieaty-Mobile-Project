import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';

class GiftDetailsScreen extends StatefulWidget {
  const GiftDetailsScreen({super.key});

  @override
  State<GiftDetailsScreen> createState() => _GiftDetailsScreenState();
}

class _GiftDetailsScreenState extends State<GiftDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final giftDetailsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarActions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              size: 40,
            ))
      ], title: 'Gift Details', isTherebackButton: true),
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
                  decoration: ThemeClass.textFormFieldDecoration(),
                ),
              ),
              ////////////price form field////////////
              textFieldLabel('Price'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: ThemeClass.textFormFieldDecoration(),
                ),
              ),
              ///////////////category form field/////////
              textFieldLabel('Category'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: categoryController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                ),
              ),
              ////////////////status dropdown////////////
              textFieldLabel('Status'),
              DropdownMenu(
                  controller: statusController,
                  width: 0.83.sw,
                  inputDecorationTheme: ThemeClass.dropdownMenuDecoration(),
                  menuStyle: MenuStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(ThemeClass.blueThemeColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)))),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'Available', label: 'Available'),
                    DropdownMenuEntry(value: 'Pledged', label: 'Pledged')
                  ]),
              ////////////description form field///////////
              textFieldLabel('Description'),
              Container(
                width: 0.83.sw,
                constraints: BoxConstraints(
                  minHeight: 0.065.sh, // Initial height
                ),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: ThemeClass.textFormFieldDecoration(),
                ),
              ),
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
