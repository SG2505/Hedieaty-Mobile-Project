import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/View/EditInfo/EditInfoScreen.dart';
import 'package:hedieaty/View/EventDetails/EventDetailsScreen.dart';
import 'package:hedieaty/View/GiftDetails/GiftDetailsScreen.dart';
import 'package:hedieaty/View/GiftList/GiftListScreen.dart';
import 'package:hedieaty/View/HomeScreen/HomeScreen.dart';
import 'package:hedieaty/View/MyEvents/MyEventsScreen.dart';

class RouterClass {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Home
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Homescreen();
        },
        routes: <RouteBase>[
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
        ],
      ),
    ],
  );
}
