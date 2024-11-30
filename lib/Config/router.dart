import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/View/EditInfo/EditInfoScreen.dart';
import 'package:hedieaty/View/EventDetails/EventDetailsScreen.dart';
import 'package:hedieaty/View/FriendGiftList/FriendGiftList.dart';
import 'package:hedieaty/View/FriendPage/FriendEvents.dart';
import 'package:hedieaty/View/GiftDetails/GiftDetailsScreen.dart';
import 'package:hedieaty/View/GiftList/GiftListScreen.dart';
import 'package:hedieaty/View/MyEvents/MyEventsScreen.dart';
import 'package:hedieaty/View/MyPledgedGifts/MyPledgedGiftsScreen.dart';
import 'package:hedieaty/View/Profile/MyProfileScreen.dart';
import 'package:hedieaty/View/SignUp/SignUpScreen.dart';

class RouterClass {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Home
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'SignUpScreen',
            builder: (BuildContext context, GoRouterState state) {
              return const SignUpScreen();
            },
            routes: <RouteBase>[],
          ),
          GoRoute(
            path: 'MyEvents',
            builder: (BuildContext context, GoRouterState state) {
              return const MyEventsScreen();
            },
            routes: <RouteBase>[],
          ),
          GoRoute(
            path: 'EventDetails',
            builder: (BuildContext context, GoRouterState state) {
              return const EventDetails();
            },
            routes: <RouteBase>[],
          ),
          GoRoute(
            path: 'GiftList',
            builder: (BuildContext context, GoRouterState state) {
              return const Giftlistscreen();
            },
            routes: <RouteBase>[],
          ),
          GoRoute(
            path: 'GiftDetails',
            builder: (BuildContext context, GoRouterState state) {
              return const GiftDetailsScreen();
            },
            routes: [],
          ),
          GoRoute(
            path: 'EditInfo',
            builder: (BuildContext context, GoRouterState state) {
              return const EditInfoScreen();
            },
            routes: [],
          ),
          GoRoute(
            path: 'MyProfile',
            builder: (BuildContext context, GoRouterState state) {
              return const MyProfileScreen();
            },
            routes: [],
          ),
          GoRoute(
            path: 'MyPledgedGifts',
            builder: (BuildContext context, GoRouterState state) {
              return const MyPledgedGiftsScreen();
            },
            routes: [],
          ),
          GoRoute(
            path: 'FriendGiftList',
            builder: (BuildContext context, GoRouterState state) {
              return const FriendGiftListScreen();
            },
            routes: [],
          ),
          GoRoute(
            path: 'FriendEvents',
            builder: (BuildContext context, GoRouterState state) {
              return const FriendEventsScreen();
            },
            routes: [],
          ),
        ],
      ),
    ],
  );
}
