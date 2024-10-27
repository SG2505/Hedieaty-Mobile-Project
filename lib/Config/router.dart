import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hedieaty/View/EventDetails/EventDetails.dart';
import 'package:hedieaty/View/HomeScreen/HomeScreen.dart';
import 'package:hedieaty/View/MyEvents/MyEvents.dart';

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
          // MyEvents --> EventDetails
          GoRoute(
            path: 'MyEvents',
            builder: (BuildContext context, GoRouterState state) {
              return const MyEvents();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'EventDetails',
                builder: (BuildContext context, GoRouterState state) {
                  return const EventDetails();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
