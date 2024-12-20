import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/View/EventDetails/EventDetailsTile.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';

class EventDetails extends StatefulWidget {
  final Event? event;
  const EventDetails({super.key, this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    DateTime eventDate = widget.event!.date;
    return Scaffold(
      appBar: CustomAppBar(appBarActions: [
        IconButton(
            onPressed: () {
              context.pushNamed("addEditEvents", extra: widget.event);
            },
            icon: Image.asset(
                width: 35,
                height: 35,
                'assets/icons/EventDetailsIcons/edit.png'))
      ], title: 'Event Details', isTherebackButton: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              ThemeClass.getCategoryImagePath(widget.event!.category),
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 20,
            ),

            ///event title - name//////
            Text(
              widget.event!.name!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),

            ///description///
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.event!.description!,
                  style: TextStyle(
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.grey.shade400,
            ),
            leftAlignedLabel('Date'),
            EventDetailsTile(
                text:
                    '${eventDate.day} - ${eventDate.month} - ${eventDate.year}',
                leadingImgPath: 'assets/icons/EventDetailsIcons/calendar.png'),
            leftAlignedLabel('Status'),
            EventDetailsTile(
                text: widget.event!.status!,
                leadingImgPath:
                    'assets/icons/EventDetailsIcons/completedEvent.png'),
            leftAlignedLabel('Category'),
            EventDetailsTile(
                text: widget.event!.category!,
                leadingImgPath:
                    ThemeClass.getCategoryImagePath(widget.event!.category)),
            leftAlignedLabel('Go to Gift List'),
            EventDetailsTile(
              text: 'Gift List',
              leadingImgPath: 'assets/icons/EventDetailsIcons/giftbox.png',
              trailingImgPath: 'assets/icons/EventDetailsIcons/next.png',
              isGoToGiftList: true,
              event: widget.event,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget leftAlignedLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
          )),
    );
  }
}
