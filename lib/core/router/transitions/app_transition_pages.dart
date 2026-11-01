import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vakif_atlas_admin/core/a11y/reduce_motion.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_durations.dart';

/// Sekme ve kök ekran geçişleri için yumuşak geçiş.
///
/// [duration] çağıran tarafından hareket azaltma ayarına göre verilir
/// (`context.motionDuration`); azaltma açıksa geçiş anlıktır.
class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  FadeTransitionPage({
    required super.child,
    required Duration duration,
    super.key,
    super.name,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             FadeTransition(
               opacity: CurveTween(curve: Curves.easeOut).animate(animation),
               child: child,
             ),
       );
}

/// Detay ekranları için sağdan kayan geçiş (hiyerarşide derinleşme).
class SlideTransitionPage<T> extends CustomTransitionPage<T> {
  SlideTransitionPage({
    required super.child,
    required Duration duration,
    super.key,
    super.name,
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final offset = Tween<Offset>(
             begin: const Offset(1, 0),
             end: Offset.zero,
           ).chain(CurveTween(curve: Curves.easeOutCubic));
           return SlideTransition(
             position: animation.drive(offset),
             child: child,
           );
         },
       );
}

/// Sekme ve kök ekranlar için hareket azaltmaya duyarlı yumuşak geçiş.
Page<void> fadePage(BuildContext context, GoRouterState state, Widget child) {
  return FadeTransitionPage<void>(
    key: state.pageKey,
    name: state.name,
    duration: context.motionDuration(AppDurations.normal),
    child: child,
  );
}

/// Detay ekranları için hareket azaltmaya duyarlı kayan geçiş.
Page<void> slidePage(BuildContext context, GoRouterState state, Widget child) {
  return SlideTransitionPage<void>(
    key: state.pageKey,
    name: state.name,
    duration: context.motionDuration(AppDurations.medium),
    child: child,
  );
}
