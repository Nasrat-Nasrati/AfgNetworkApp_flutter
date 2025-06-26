

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this in pubspec.yaml
import 'generated/l10n.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AfgNetworkApp());
}

class AfgNetworkApp extends StatefulWidget {
  const AfgNetworkApp({Key? key}) : super(key: key);

  @override
  State<AfgNetworkApp> createState() => _AfgNetworkAppState();
}

class _AfgNetworkAppState extends State<AfgNetworkApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AfgNetwork App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.robotoTextTheme(), // Optional: You can remove this line if you don’t want Roboto
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme), // Optional
      ),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(
        setLocale: _setLocale,
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
