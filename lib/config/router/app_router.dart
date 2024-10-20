
import 'package:go_router/go_router.dart';
import 'package:ui_flutter/presentation/screens/screens.dart';

final approuter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen( ),
    ),
    GoRoute(
      path: '/addScreen',
      builder: (context, state) => const AddScreen(),
    ),
    GoRoute(
      path: '/editScreen/:id/:name',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'no-Id';
        final nameId = state.pathParameters['name'] ?? 'no-Name';
        final url = state.extra as String;

        return EditScreen( id: id, nameId: nameId, url: url);
      },
    )
  ]
);
