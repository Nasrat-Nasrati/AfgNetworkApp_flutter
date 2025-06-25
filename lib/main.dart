

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'generated/l10n.dart'; // این فایل توسط flutter_intl ساخته می‌شود

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

  void _setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AfgNetwork App',
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans', // اگر فونت سفارشی دارید
      ),
      home: HomeScreen(setLocale: _setLocale), // ارسال تابع تغییر زبان
    );
  }
}
