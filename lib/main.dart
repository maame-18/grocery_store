import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/tab_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';
import 'screens/onboarding_screen.dart';
import 'utils/app_colors.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        
        return MaterialApp(
          title: 'Food Shop',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              surface: AppColors.surface,
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.backgroundDark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              surface: AppColors.surfaceDark,
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: AuthService().authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return const MainScreen();
              }
              return const OnboardingScreen();
            },
          ),
        );
      },
    );
  }
}
