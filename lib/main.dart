import 'package:material_ui/material_ui.dart';

import 'screens/auth_screen.dart';

void main() {
  runApp(const PlaniApp());
}

class PlaniApp extends StatelessWidget {
  const PlaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    const violet = Color(0xFF6857F5);

    return MaterialApp(
      title: 'Plani — Organizador diário',
      debugShowCheckedModeBanner: false,

locale: const Locale('pt', 'BR'),

localizationsDelegates:
    GlobalMaterialLocalizations.delegates,

supportedLocales: const [
  Locale('pt', 'BR'),
],

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: violet,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6FC),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F4FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFECEAF5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: violet,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
