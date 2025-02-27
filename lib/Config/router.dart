import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/Model/AppUser.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/View/EditInfo/EditInfoScreen.dart';
import 'package:hedieaty/View/EventDetails/AddEditEvent.dart';
import 'package:hedieaty/View/EventDetails/EventDetailsScreen.dart';
import 'package:hedieaty/View/FriendGiftList/FriendGiftList.dart';
import 'package:hedieaty/View/FriendPage/FriendEvents.dart';
import 'package:hedieaty/View/GiftDetails/GiftDetailsScreen.dart';
import 'package:hedieaty/View/GiftList/GiftListScreen.dart';
import 'package:hedieaty/View/HomeScreen/HomeScreen.dart';
import 'package:hedieaty/View/Login/LoginScreen.dart';
import 'package:hedieaty/View/MyEvents/MyEventsScreen.dart';
import 'package:hedieaty/View/MyPledgedGifts/MyPledgedGiftsScreen.dart';
import 'package:hedieaty/View/Profile/MyProfileScreen.dart';
import 'package:hedieaty/View/SettingsScreen/SettingsScreen.dart';
import 'package:hedieaty/View/SignUp/SignUpScreen.dart';
import 'package:hedieaty/View/SplashScreen/SplashScreen.dart';

class RouterClass {
  static final GoRouter router = GoRouter(
    initialLocation: '/LoginScreen',
    routes: <RouteBase>[
      // Login Screen Route (Root level)
      GoRoute(
        path: '/LoginScreen',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const Loginscreen();
        },
      ),
      // Sign Up Route (Root level)
      GoRoute(
        path: '/SignUpScreen',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: '/SplashScreen',
        name: 'splashScreen',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      // Home Screen Route (Root level)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? friendMap =
              state.extra as Map<String, dynamic>?;
          return Homescreen(
            extraFriendData: friendMap,
          );
        },
        routes: [
          // Nested routes under Home
          GoRoute(
            path: 'MyEvents',
            name: 'myEvents',
            builder: (BuildContext context, GoRouterState state) {
              return const MyEventsScreen();
            },
          ),
          GoRoute(
            path: 'EventDetails',
            name: 'eventDetails',
            builder: (BuildContext context, GoRouterState state) {
              final event = state.extra as Event?;
              return EventDetails(event: event);
            },
          ),
          GoRoute(
            path: 'AddEditEvents',
            name: 'addEditEvents',
            builder: (context, state) {
              final event = state.extra as Event?;
              return AddEditEventScreen(
                  event:
                      event); // Pass the event to the AddEditEventScreen if editing
            },
          ),
          GoRoute(
            path: 'GiftList',
            name: 'giftList',
            builder: (BuildContext context, GoRouterState state) {
              final event = state.extra as Event?;
              return Giftlistscreen(
                event: event,
              );
            },
          ),
          GoRoute(
            path: 'GiftDetails',
            name: 'giftDetails',
            builder: (BuildContext context, GoRouterState state) {
              final Map<String, dynamic> args =
                  state.extra as Map<String, dynamic>;
              final Gift? gift = args['gift'] as Gift?;
              final Event event = args['event'] as Event;

              return GiftDetailsScreen(gift: gift, event: event);
            },
          ),
          GoRoute(
            path: 'EditInfo',
            name: 'editInfo',
            builder: (BuildContext context, GoRouterState state) {
              return const EditInfoScreen();
            },
          ),
          GoRoute(
            path: 'MyProfile',
            name: 'myProfile',
            builder: (BuildContext context, GoRouterState state) {
              return const MyProfileScreen();
            },
          ),
          GoRoute(
            path: 'MyPledgedGifts',
            name: 'myPledgedGifts',
            builder: (BuildContext context, GoRouterState state) {
              return const MyPledgedGiftsScreen();
            },
          ),
          GoRoute(
            path: 'FriendGiftList',
            name: 'friendGiftList',
            builder: (BuildContext context, GoRouterState state) {
              final event = state.extra as Event;
              return FriendGiftListScreen(
                event: event,
              );
            },
          ),
          GoRoute(
            path: 'FriendEvents',
            name: 'friendEvents',
            builder: (BuildContext context, GoRouterState state) {
              final extra = state.extra as Map<String, dynamic>?;
              final events = extra?['events'] as List<Event>?;
              final friend = extra?['friend'] as AppUser;

              return FriendEventsScreen(
                events: events,
                friend: friend,
              );
            },
          ),
          GoRoute(
            path: 'Settings',
            name: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
          ),
        ],
      ),
    ],
  );
}
