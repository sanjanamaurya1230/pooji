import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poojify_landing_site/featured/home/view/home_view.dart';
import 'package:poojify_landing_site/featured/home/view_model/home_view_model.dart';
import 'package:poojify_landing_site/featured/home/widget/policy_page.dart';
import 'package:poojify_landing_site/view_model/app_setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'core/theme/app_theme.dart';

// ── Router globally defined ──────────────────────────────────────────────────
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/policy/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? '';
        return PolicyPage(initialSlug: slug);
      },
    ),
  ],
);

void main() {
  setPathUrlStrategy(); // Removes # from web URL

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AppSettingViewModel()),
      ],
      child: const PoojifyApp(),
    ),
  );
}

class PoojifyApp extends StatelessWidget {
  const PoojifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Poojify - Sacred Essentials Delivered',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}