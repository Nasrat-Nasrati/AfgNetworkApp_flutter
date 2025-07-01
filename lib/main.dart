// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_fonts/google_fonts.dart'; // keep if you want fallback fonts or mix usage
// import 'generated/l10n.dart';
// import 'screens/home_screen.dart';
//
//
// void main() {
//   runApp(const AfgNetworkApp());
// }
//
// class AfgNetworkApp extends StatefulWidget {
//   const AfgNetworkApp({Key? key}) : super(key: key);
//
//   @override
//   State<AfgNetworkApp> createState() => _AfgNetworkAppState();
// }
//
// class _AfgNetworkAppState extends State<AfgNetworkApp> {
//   Locale _locale = const Locale('fa'); // Default to Persian/Dari
//   ThemeMode _themeMode = ThemeMode.light;
//
//   void _setLocale(Locale newLocale) {
//     setState(() {
//       _locale = newLocale;
//     });
//   }
//
//   void _toggleTheme() {
//     setState(() {
//       _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'AfgNetwork App',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         fontFamily: 'IranianSans',  // Custom Dari font for light theme
//         scaffoldBackgroundColor: Colors.grey[100],
//         cardColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//         ),
//         // Optional fallback text theme, can be combined or removed if you want pure IranianSans
//         textTheme: GoogleFonts.robotoTextTheme(),
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         fontFamily: 'IranianSans',  // Custom Dari font for dark theme
//         scaffoldBackgroundColor: Colors.grey[900],
//         cardColor: Colors.grey[800],
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.grey[850],  // این خط حالا اشکال ندارد
//           foregroundColor: Colors.white,
//         ),
//
//         textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
//       ),
//       themeMode: _themeMode,
//       locale: _locale,
//       supportedLocales: S.delegate.supportedLocales,
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: HomeScreen(
//         setLocale: _setLocale,
//         toggleTheme: _toggleTheme,
//         isDarkMode: _themeMode == ThemeMode.dark,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شبکه افغانستان',  // عنوان برنامه به فارسی دری
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'IranianSans',  // فونت دلخواه
        scaffoldBackgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'IranianSans',
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: _themeMode,
      home: HomeScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
