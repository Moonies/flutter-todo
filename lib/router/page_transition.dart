// lib/router/page_transitions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'transition_type.dart';

class PageTransitions {
  // Main transition factory method
  static CustomTransitionPage<T> buildTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    TransitionType type = TransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        switch (type) {
          case TransitionType.fade:
            return FadeTransition(opacity: curvedAnimation, child: child);

          case TransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.slideLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.slideRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.slideUp:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.slideDown:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.rotation:
            return RotationTransition(
              turns: Tween<double>(
                begin: 0.5,
                end: 1.0,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.size:
            return SizeTransition(
              sizeFactor: curvedAnimation,
              axis: Axis.horizontal,
              axisAlignment: 0.0,
              child: child,
            );
        }
      },
    );
  }

  // Convenience methods for common transitions
  static CustomTransitionPage<T> fadeTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildTransition(
      context: context,
      state: state,
      child: child,
      type: TransitionType.fade,
      duration: duration,
    );
  }

  static CustomTransitionPage<T> slideTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    TransitionType slideDirection = TransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return buildTransition(
      context: context,
      state: state,
      child: child,
      type: slideDirection,
      duration: duration,
    );
  }
}
