import 'package:go_router/go_router.dart';
import 'package:radio_beats/screens/home/home_screen.dart';

final _homeRoute = GoRoute(
  path: '/',
  builder: (context, state) => const HomeScreen(),
);

/// App router.
final rbRouter = GoRouter(
  routes: [
    _homeRoute,
  ],
);
