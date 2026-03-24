import 'package:flutter/material.dart';
import 'package:formation_flutter/core/services/pocketbase_service.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/auth/login_screen.dart';
import 'package:formation_flutter/screens/auth/register_screen.dart';
import 'package:formation_flutter/screens/favorites/favorites_screen.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:formation_flutter/screens/recall/recall_screen.dart';
import 'package:formation_flutter/screens/scanner/scanner_screen.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PocketBaseService().init();
  runApp(const MyApp());
}

GoRouter _router = GoRouter(
  initialLocation: PocketBaseService().isAuthenticated ? '/' : '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (_, __) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/product',
      builder: (_, GoRouterState state) =>
          ProductPage(barcode: state.extra as String),
    ),
    GoRoute(
      path: '/favorites',
      builder: (_, __) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/recall',
      builder: (_, GoRouterState state) =>
          RecallScreen(recallData: state.extra as Map<String, dynamic>),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Open Food Facts',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.appBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBackground,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.blue),
        ),
        extensions: [OffThemeExtension.defaultValues()],
        fontFamily: 'Avenir',
        dividerTheme: DividerThemeData(color: AppColors.grey2, space: 1.0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.grey2,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppColors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
