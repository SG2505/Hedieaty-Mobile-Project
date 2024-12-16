import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:hedieaty/View/Widgets/TextFieldLabel.dart';
import 'package:toastification/toastification.dart';

class GiftDetailsScreen extends StatefulWidget {
  final Gift? gift;
  final Event? event;
  const GiftDetailsScreen({super.key, this.gift, this.event});

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
  void initState() {
    super.initState();

    if (widget.gift != null) {
      nameController.text = widget.gift!.name;
      priceController.text = widget.gift!.price.toString();
      if (widget.gift!.description != null) {
        descriptionController.text = widget.gift!.description!;
      }
      categoryController.text = widget.gift!.category;
      statusController.text = widget.gift!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: widget.gift != null
              ? [
                  IconButton(
                    onPressed: () {
                      deleteGift();
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 40,
                    ),
                  ),
                ]
              : [],
          title: 'Gift Details',
          isTherebackButton: true),
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
              TextFieldLable(text: 'Name'),
              SizedBox(
                width: 0.83.sw,
                height: 0.08.sh,
                child: TextFormField(
                  controller: nameController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
              ),
              ////////////price form field////////////
              TextFieldLable(text: 'Price'),
              SizedBox(
                width: 0.83.sw,
                height: 0.08.sh,
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: ThemeClass.textFormFieldDecoration(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a price";
                    } else if (double.tryParse(value) == null) {
                      return "Please enter a correct number";
                    }
                    return null;
                  },
                ),
              ),
              ///////////////category dropdown/////////
              TextFieldLable(text: 'Category'),
              DropdownMenu(
                menuHeight: 200,
                initialSelection:
                    widget.gift == null ? 'Electronics' : widget.gift!.category,
                controller: categoryController,
                width: 0.83.sw,
                inputDecorationTheme: ThemeClass.dropdownMenuDecoration(),
                menuStyle: MenuStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ThemeClass.blueThemeColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                dropdownMenuEntries: [
                  ...getGiftCategories(),
                ],
              ),

              ////////////////status dropdown////////////
              TextFieldLable(text: 'Status'),
              DropdownMenu(
                  initialSelection:
                      widget.gift == null ? 'Available' : widget.gift!.status,
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
              TextFieldLable(text: 'Description'),
              Container(
                width: 0.83.sw,
                constraints: BoxConstraints(
                  minHeight: 0.08.sh, // Initial height
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
                  label: widget.gift == null ? 'Save' : 'Edit',
                  onPressed: () async {
                    if (giftDetailsFormKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      print("hello");
                      print(widget.event!.id);
                      // print(widget.gift!.name);
                      final gift = Gift(
                        id: widget.gift?.id,
                        name: nameController.text,
                        category: categoryController.text,
                        price: double.parse(priceController.text.trim()),
                        eventId: widget.event!.id!,
                        isPublished: 0,
                        description: descriptionController.text,
                        status: statusController.text,
                      );

                      bool result = widget.gift == null
                          ? await GiftController.addGift(gift)
                          : await GiftController.updateGift(gift);
                      if (result) {
                        toastification.show(
                            icon: Icon(
                              Icons.check_circle,
                              color: const Color.fromARGB(255, 73, 225, 71),
                            ),
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            context: context,
                            title: widget.gift == null
                                ? Text('Gift added successfully')
                                : Text('Gift edited successfully'));

                        context.pop();
                      } else {
                        toastification.show(
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 5),
                            context: context,
                            title: Text('Failed to add event'));
                      }
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuEntry<String>> getGiftCategories() {
    return [
      DropdownMenuEntry(value: 'Electronics', label: 'Electronics'),
      DropdownMenuEntry(value: 'Books', label: 'Books'),
      DropdownMenuEntry(value: 'Clothing', label: 'Clothing'),
      DropdownMenuEntry(value: 'Home & Kitchen', label: 'Home & Kitchen'),
      DropdownMenuEntry(value: 'Games & Consoles', label: 'Games & Consoles'),
      DropdownMenuEntry(
          value: 'Beauty & Personal Care', label: 'Beauty & Personal Care'),
      DropdownMenuEntry(
          value: 'Jewelry & Accessories', label: 'Jewelry & Accessories'),
      DropdownMenuEntry(value: 'Other', label: 'Other'),
    ];
  }

  void deleteGift() {
    try {
      GiftController.deleteGift(widget.gift!.id!);
      toastification.show(
          icon: Icon(
            Icons.check_circle,
            color: const Color.fromARGB(255, 73, 225, 71),
          ),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
          context: context,
          title: Text('Gift deleted successfully'));
      context.pop();
    } catch (e) {
      print(e);
      toastification.show(
          icon: Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
          context: context,
          title: Text('Error Deleting Gift'));
    }
  }
}
