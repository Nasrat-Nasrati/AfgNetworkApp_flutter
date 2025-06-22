import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AfgNetworkApp());
}

class AfgNetworkApp extends StatelessWidget {
  const AfgNetworkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // برای حذف نوشته debug
      title: 'AfgNetwork App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans', // اگر فونت سفارشی دارید
      ),
      home: HomeScreen(), // صفحه اصلی
    );
  }
}
