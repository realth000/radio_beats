import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';

final _homeRoute = GoRoute(
  path: '/',
  builder: (context, state) => HomeScreen(),
);

final RBRouter = GoRouter(
  routes: [
    _homeRoute,
  ],
);
