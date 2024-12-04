import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/View/EditInfo/EditInfoScreen.dart';
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
import 'package:hedieaty/View/SignUp/SignUpScreen.dart';

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

      // Home Screen Route (Root level)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const Homescreen();
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
              return const EventDetails();
            },
          ),
          GoRoute(
            path: 'GiftList',
            name: 'giftList',
            builder: (BuildContext context, GoRouterState state) {
              return const Giftlistscreen();
            },
          ),
          GoRoute(
            path: 'GiftDetails',
            name: 'giftDetails',
            builder: (BuildContext context, GoRouterState state) {
              return const GiftDetailsScreen();
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
              return const FriendGiftListScreen();
            },
          ),
          GoRoute(
            path: 'FriendEvents',
            name: 'friendEvents',
            builder: (BuildContext context, GoRouterState state) {
              return const FriendEventsScreen();
            },
          ),
        ],
      ),

      // Sign Up Route (Root level)
      GoRoute(
        path: '/SignUpScreen',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
    ],
  );
}
