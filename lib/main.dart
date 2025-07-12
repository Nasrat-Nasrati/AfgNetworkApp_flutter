//
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'screens/home_screen.dart';
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
//   ThemeMode _themeMode = ThemeMode.light;
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
//       title: 'شبکه افغانستان',  // عنوان برنامه به فارسی دری
//       theme: ThemeData(
//         brightness: Brightness.light,
//         fontFamily: 'IranianSans',  // فونت دلخواه
//         scaffoldBackgroundColor: Colors.grey[100],
//         cardColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//         ),
//         textTheme: GoogleFonts.robotoTextTheme(),
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         fontFamily: 'IranianSans',
//         scaffoldBackgroundColor: Colors.grey[900],
//         cardColor: Colors.grey[800],
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.grey[850],
//           foregroundColor: Colors.white,
//         ),
//         textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
//       ),
//       themeMode: _themeMode,
//       home: HomeScreen(
//         toggleTheme: _toggleTheme,
//         isDarkMode: _themeMode == ThemeMode.dark,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize sqflite for desktop/testing environments
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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
      title: 'شبکه افغانستان',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'IranianSans',
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
