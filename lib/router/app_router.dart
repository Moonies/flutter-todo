import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/generator_screen.dart';
import '../screens/generator_detail_screen.dart';
import '../screens/favorite_screen.dart';
import '../widgets/custom_navigation_rail.dart';
import '../screens/generator_add_detail_screen.dart';
import 'page_transition.dart';
import 'transition_type.dart';

class AppRouter {
  static GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  // final GlobalKey<NavigatorState> _generateNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'generate');

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    // errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(location: state.matchedLocation, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder:
                (context, state) => PageTransitions.buildTransition(
                  context: context,
                  state: state,
                  child: HomeScreen(),
                  type: TransitionType.slide,
                ),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            pageBuilder:
                (context, state) => PageTransitions.buildTransition(
                  context: context,
                  state: state,
                  child: FavoriteScreen(),
                  type: TransitionType.slide,
                ),
          ),
          GoRoute(
            path: '/generator',
            name: 'generator',
            pageBuilder:
                (context, state) => PageTransitions.buildTransition(
                  context: context,
                  state: state,
                  child: GeneratorScreen(),
                  type: TransitionType.slide,
                ),
            routes: [
              GoRoute(
                path: 'detail/:id',
                name: 'generator-detail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'] ?? '0';
                  return PageTransitions.buildTransition(
                    context: context,
                    state: state,
                    child: GeneratorDetailScreen(
                      id: id,
                      details: state.extra as Map<String, dynamic>,
                    ),
                    type: TransitionType.slideRight,
                  );
                },
              ),
              GoRoute(
                path: 'add/:id',
                name: 'generator-add-detail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'] ?? '0';
                  return PageTransitions.buildTransition(
                    context: context,
                    state: state,
                    child: GeneratorAddDetailScreen(id: id),
                    type: TransitionType.slideRight,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
