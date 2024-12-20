import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/EventController.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:hedieaty/View/Widgets/TextFieldLabel.dart';
import 'package:hedieaty/main.dart';
import 'package:intl/intl.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart'; // Import the Event model

class AddEditEventScreen extends StatefulWidget {
  final Event? event;

  const AddEditEventScreen({super.key, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final eventFormKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      nameController.text = widget.event!.name!;
      locationController.text = widget.event!.location ?? '';
      descriptionController.text = widget.event!.description ?? '';
      selectedDate = widget.event!.date;
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      categoryController.text = widget.event!.category!;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = selectedDate ?? currentDate;
    final DateTime firstDate = DateTime.now();
    final DateTime lastDate = DateTime(2200);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBarActions: [],
          title: widget.event == null ? 'Add Event' : 'Edit Event',
          isTherebackButton: true),
      body: SingleChildScrollView(
        child: Form(
          key: eventFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                ThemeClass.getCategoryImagePath(categoryController.text),
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 20,
              ),
              /////////////name form field////////////
              TextFieldLable(text: 'Name'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: nameController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              ////////////Location form field////////////
              TextFieldLable(text: 'Location'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: locationController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              ////////////Date form field////////////
              TextFieldLable(text: 'Date'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  showCursor: false, cursorColor: Colors.transparent,
                  controller: dateController,
                  decoration: ThemeClass.textFormFieldDecoration(
                    suffixWidget: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  enabled: true,
                  keyboardType: TextInputType.none, // Disable manual editing
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Date can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              ////////////Description form field///////////
              TextFieldLable(text: 'Category'),
              DropdownMenu(
                  onSelected: (value) {
                    setState(() {});
                  },
                  width: 0.83.sw,
                  menuHeight: 200,
                  controller: categoryController,
                  inputDecorationTheme: ThemeClass.dropdownMenuDecoration(),
                  menuStyle: ThemeClass.dropdownMenuStyle(),
                  dropdownMenuEntries: [...getEventCategoriesDropdown()]),
              const SizedBox(
                height: 20,
              ),
              ////////////Description form field///////////
              TextFieldLable(text: 'Description'),
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
                label: widget.event == null ? 'Add' : 'Save',
                onPressed: () async {
                  if (eventFormKey.currentState?.validate() ?? false) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var uuid = Uuid();
                    final event = Event(
                        id: widget.event == null ? uuid.v4() : widget.event!.id,
                        name: nameController.text,
                        date: selectedDate!,
                        location: locationController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        userId: currentUser.id!,
                        status: widget.event == null
                            ? 'upcoming'
                            : widget.event!.status,
                        isPublished: 0);
                    bool result = widget.event == null
                        ? await EventController.addEvent(event)
                        : await EventController.updateEvent(event);
                    if (result) {
                      toastification.show(
                          icon: Icon(
                            Icons.check_circle,
                            color: const Color.fromARGB(255, 73, 225, 71),
                          ),
                          alignment: Alignment.topCenter,
                          autoCloseDuration: const Duration(seconds: 5),
                          context: context,
                          title: widget.event == null
                              ? Text('Event added successfully')
                              : Text('Event edited successfully'));
                      print(
                          'Event saved: ${event.name}, ${event.date} ${event.id} ${event.userId} ${event.category} ${event.status} ${event.isPublished} ${event.location}');
                      context.goNamed("myEvents");
                    } else {
                      toastification.show(
                          alignment: Alignment.topCenter,
                          autoCloseDuration: const Duration(seconds: 5),
                          context: context,
                          title: Text('Failed to add event'));
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

  List<DropdownMenuEntry<String>> getEventCategoriesDropdown() {
    List<Map<String, String>> categories = [
      {'value': 'anniversary', 'label': 'Anniversary'},
      {'value': 'birthday', 'label': 'Birthday'},
      {'value': 'wedding', 'label': 'Wedding'},
      {'value': 'engagement', 'label': 'Engagement'},
      {'value': 'celebration_party', 'label': 'Celebration Party'},
      {'value': 'baby_shower', 'label': 'Baby Shower'},
      {'value': 'graduation', 'label': 'Graduation'},
      {'value': 'retirement', 'label': 'Retirement'},
      {'value': 'new_years_eve', 'label': "New Year's Eve"},
      {'value': 'farewell_party', 'label': 'Farewell Party'},
      {'value': 'charity_event', 'label': 'Charity Event'},
    ];

    return categories
        .map((category) => DropdownMenuEntry<String>(
              value: category['value']!,
              label: category['label']!,
            ))
        .toList();
  }

  String getCategoryImagePath(String? category) {
    switch (category) {
      case "Anniversary":
        return "assets/icons/CategoryIcons/anniversary.png";
      case "Wedding":
        return "assets/icons/CategoryIcons/wedding.png";
      case "Celebration Party":
        return "assets/icons/CategoryIcons/party.png";
      case "Birthday":
        return "assets/icons/CategoryIcons/birthday.png";
      case "Graduation":
        return "assets/icons/CategoryIcons/Graduation.png";
      case "Baby Shower":
        return "assets/icons/CategoryIcons/baby.png";
      case "Engagement":
        return "assets/icons/CategoryIcons/engagement.png";
      case "Retirement":
        return "assets/icons/CategoryIcons/retirement.png";
      case "New Year's Eve":
        return "assets/icons/CategoryIcons/new_year.png";
      case "Farewell Party":
        return "assets/icons/CategoryIcons/farewell_party.png";
      case "Charity Event":
        return "assets/icons/CategoryIcons/charity.png";
      default:
        return "assets/icons/CategoryIcons/event.png";
    }
  }
}
