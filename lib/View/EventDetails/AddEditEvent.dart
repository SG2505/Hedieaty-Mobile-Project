import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GradientButton.dart';
import 'package:hedieaty/main.dart';
import 'package:intl/intl.dart';
import 'package:hedieaty/Model/Event.dart'; // Import the Event model

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
  final eventFormKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // If editing an existing event, pre-fill the fields
    if (widget.event != null) {
      nameController.text = widget.event!.name;
      locationController.text = widget.event!.location ?? '';
      descriptionController.text = widget.event!.description ?? '';
      selectedDate = widget.event!.date;
      dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
    }
  }

  // Function to show the DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = selectedDate ?? currentDate;
    final DateTime firstDate = DateTime(1960);
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name can't be empty";
                    }
                    return null;
                  },
                ),
              ),
              ////////////Location form field////////////
              textFieldLabel('Location'),
              SizedBox(
                width: 0.83.sw,
                height: 0.065.sh,
                child: TextFormField(
                  controller: locationController,
                  decoration: ThemeClass.textFormFieldDecoration(),
                ),
              ),
              ////////////Date form fieldr////////////
              textFieldLabel('Date'),
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
                label: widget.event == null ? 'Add' : 'Save',
                onPressed: () {
                  if (eventFormKey.currentState?.validate() ?? false) {
                    // Update event logic here (save to database, etc.)
                    // If it's an edit, update the existing event in your database
                    // If it's an add, create a new event

                    final event = Event(
                      id: widget
                          .event?.id, // Pass the existing ID if it's editing
                      name: nameController.text,
                      date: selectedDate!,
                      location: locationController.text,
                      description: descriptionController.text,
                      userId: currentUser.id!, // Replace with actual userId
                    );

                    print('Event saved: ${event.name}, ${event.date}');
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
